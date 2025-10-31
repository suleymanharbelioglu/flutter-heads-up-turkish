import 'dart:async'; // Timer ve StreamSubscription için
import 'package:ben_kimim/common/helper/sound/sound.dart'; // Oyundaki sesleri çalmak için
import 'package:ben_kimim/core/configs/theme/app_color.dart'; // Uygulama renklerini almak için
import 'package:ben_kimim/presentation/bottom_nav/page/bottom_nav.dart';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart'; // Sonuçları yönetmek için
import 'package:ben_kimim/presentation/game_result/page/game_result.dart'; // Oyun bitince sonuç sayfasına geçmek için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ekran yönünü değiştirmek ve system UI için
import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC state management için
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart'; // Şu anki isimleri yönetmek için
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart'; // Skoru yönetmek için
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart'; // Oyunun süresini yönetmek için
import 'package:ben_kimim/presentation/game/widget/game_score.dart'; // Skor widgetı
import 'package:ben_kimim/presentation/game/widget/game_timer.dart'; // Zamanlayıcı widgetı
import 'package:sensors_plus/sensors_plus.dart'; // Cihaz sensörlerini almak için (accelerometer)

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState(); // Stateful widget için state oluşturuyor
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  // Animasyonlar için controller
  late AnimationController _controller;
  late Animation<Offset>
  _oldOffsetAnimation; // Eski kartın yukarı kayma animasyonu
  late Animation<Offset>
  _newOffsetAnimation; // Yeni kartın aşağıdan gelme animasyonu

  // Kart bilgilerinin saklanması
  String? _oldName; // Önceki kartın ismi
  String? _newName; // Gelecek kartın ismi
  Color? _oldCardColor; // Kartın renk değişimi (doğru/pas)
  String? _oldCardText; // Kart üzerinde gösterilecek metin (PASS/DOĞRU)

  // Durumlar
  bool _isAnimating = false; // Kart animasyonu devam ediyor mu
  bool _isTimeOver = false; // Süre doldu mu
  int? _remainingSeconds; // Kalan saniye

  StreamSubscription<AccelerometerEvent>? _sensorSub; // Sensör dinlemesi
  String _currentZone = "play"; // Şu anki kart bölgesi (play/pass/correct)
  Timer? _timer; // Oyun timerı
  bool _isPaused = false; // Oyun duraklatıldı mı

  @override
  void initState() {
    super.initState();
    _setupOrientation(); // Oyuna özel ekran yönünü ayarlama
    _setupAnimations(); // Kart animasyonlarını oluşturma
    _loadInitialNameAndStartTimer(); // İlk ismi yükle ve timer başlat
    _startSensorListening(); // Cihaz hareketlerini dinle
  }

  @override
  void dispose() {
    _controller.dispose(); // Animasyon controllerını temizle
    _timer?.cancel(); // Timerı iptal et
    _sensorSub?.cancel(); // Sensör dinlemeyi kapat
    _resetOrientation(); // Ekran yönünü eski haline getir
    super.dispose();
  }

  // Oyuna özel ekran yönünü ayarlama (landscape ve UI gizleme)
  void _setupOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  // Ekran yönünü eski hale getirme (portrait)
  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // Kart animasyonlarını tanımlama
  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Animasyon süresi
    );

    _oldOffsetAnimation = Tween<Offset>(
      begin: Offset.zero, // Başlangıç pozisyonu
      end: const Offset(0, -1), // Yukarı kayma
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _newOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Aşağıdan başla
      end: Offset.zero, // Ortaya gel
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // İlk kartı yükle ve timer başlat
  void _loadInitialNameAndStartTimer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nameCubit = context.read<CurrentNameCubit>();
      nameCubit.generateNewName(); // İlk ismi üret
      setState(() => _oldName = nameCubit.state); // _oldName olarak ata
      _startTimer(); // Timer başlat
    });
  }

  // Timer başlatma ve her saniye azaltma
  void _startTimer() {
    final timerCubit = context.read<TimerCubit>();
    _remainingSeconds = timerCubit.state; // Timerın toplam süresi

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isPaused) return; // Duraklatılmışsa ilerleme
      if (_remainingSeconds != null && _remainingSeconds! > 0) {
        setState(() => _remainingSeconds = _remainingSeconds! - 1);

        // ⏰ Son 5 saniyede ses çal
        if (_remainingSeconds == 5) {
          SoundHelper.playLastSeconds();
        }
      } else {
        t.cancel(); // Süre dolduysa timer durdur
        _onTimeOver(); // Süre bitti işlemleri
      }
    });
  }

  // Süre dolunca yapılacak işlemler
  void _onTimeOver() async {
    // 1️⃣ Son kelimeyi kontrol et
    final resultCubit = context.read<ResultCubit>();

    // Eğer son kelime işaretlenmemişse (PASS/DOĞRU yapılmamışsa) ekle
    if (_oldName != null &&
        (_oldCardText == null || _oldCardText == _oldName)) {
      resultCubit.addPassWord(_oldName!); // ya da istersen addCorrectWord()
    }
    setState(() {
      _isTimeOver = true;
      _isAnimating = true; // Animasyon durumu true, kart kaydırılamaz
    });

    await SoundHelper.playTimeUp(); // 🔊 Süre bitti sesi

    Future.delayed(const Duration(seconds: 1), () {
      // Sonuç sayfasına geç

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameResultPage()),
      );
    });
  }

  // Sensörleri dinleme başlat
  void _startSensorListening() {
    _sensorSub = accelerometerEvents.listen((event) {
      if (_isAnimating || _isTimeOver || _isPaused)
        return; // Kart animasyonu veya süre dolduysa ignore

      final zone = _detectZone(
        event.x,
        event.y,
        event.z,
      ); // Hangi bölgedeyiz kontrol et
      if (zone != null && zone != _currentZone) {
        _handleZoneTransition(
          from: _currentZone,
          to: zone,
        ); // Bölge değişirse işle
      }
    });
  }

  // Kartın hangi bölgesinde olduğunu belirleme (play/pass/correct)
  String? _detectZone(double x, double y, double z) {
    bool inRange(double value, double a, double b) {
      final min = a < b ? a : b;
      final max = a < b ? b : a;
      return value >= min && value <= max;
    }

    // play bölgesi
    if (inRange(x, 8, 10) && inRange(y, -4, 4) && inRange(z, -6, 6)) {
      return "play";
    }
    // pass bölgesi
    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, 7, 10)) {
      return "pass";
    }
    // correct bölgesi
    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, -10, -7)) {
      return "correct";
    }
    return null; // Hiçbir bölgeye girmediyse null
  }

  // Bölge geçişini yönet
  void _handleZoneTransition({required String from, required String to}) {
    if (_isAnimating || _isTimeOver || _isPaused) return;

    // play -> pass/correct
    if (from == "play" && (to == "pass" || to == "correct")) {
      setState(() {
        _currentZone = to;
        _oldCardColor = to == "pass"
            ? AppColors.pass
            : AppColors.correct; // Renk değişimi
        _oldCardText = to == "pass" ? "PASS" : "DOĞRU"; // Kart üzerindeki metin
      });

      // 🔊 Sesleri SoundHelper'dan çalıyoruz
      if (to == "pass") {
        SoundHelper.playPass();
      } else {
        SoundHelper.playCorrect();
      }

      return;
    }

    // pass/correct -> play (kart yenileniyor)
    if ((from == "pass" || from == "correct") && to == "play") {
      _handleReturnToPlay(fromZone: from);
      return;
    }
  }

  // Kart eski bölgeden play alanına döndüğünde yapılacaklar
  Future<void> _handleReturnToPlay({required String fromZone}) async {
    if (_isAnimating || _isTimeOver || _isPaused) return;

    final currentNameCubit = context.read<CurrentNameCubit>();
    final scoreCubit = context.read<ScoreCubit>();
    final resultCubit = context.read<ResultCubit>();

    // Doğruysa skor ekle, pass ise result listesine ekle
    if (fromZone == "correct") {
      scoreCubit.increment();
      resultCubit.addCorrectWord(currentNameCubit.state);
    } else if (fromZone == "pass") {
      resultCubit.addPassWord(currentNameCubit.state);
    }

    currentNameCubit.generateNewName(); // Yeni kart ismi
    final nextName = currentNameCubit.state;

    setState(() {
      _isAnimating = true; // Animasyon aktif
      _newName = nextName; // Yeni kart set edildi
      _currentZone = "play";
    });

    await _controller.forward(); // Animasyonu başlat

    // Animasyon sonrası durumu resetle
    setState(() {
      _oldName = nextName;
      _oldCardColor = null;
      _oldCardText = null;
      _newName = null;
      _isAnimating = false;
    });

    _controller.reset(); // Animasyon controller reset
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildAnimatedNames(), // Kart animasyonları
            _buildBackButton(), // Geri butonu
            _buildScore(), // Skor
            _buildTimer(), // Zamanlayıcı
            if (_isTimeOver) _buildTimeOverOverlay(), // Süre bitti overlay
          ],
        ),
      ),
    );
  }

  // Kart animasyonları
  Widget _buildAnimatedNames() {
    return Stack(
      children: [
        if (_oldName != null)
          SlideTransition(
            position: _oldOffsetAnimation, // Yukarı kayma animasyonu
            child: _buildCard(
              text: _oldCardText ?? _oldName!, // Kart üzerindeki metin
              color: _oldCardColor ?? AppColors.game, // Kart rengi
            ),
          ),
        if (_newName != null)
          SlideTransition(
            position: _newOffsetAnimation, // Aşağıdan gelme animasyonu
            child: _buildCard(text: _newName!, color: AppColors.game),
          ),
      ],
    );
  }

  // Kart widget'ı
  Widget _buildCard({required String text, required Color color}) {
    return SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        color: color, // Kart rengi
        child: Text(
          text, // Kart üzerindeki yazı
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Geri butonu
  Widget _buildBackButton() {
    return Positioned(
      top: 20,
      left: 20,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
        onPressed: _onBackPressed, // Geri basınca duraklat ve dialog aç
      ),
    );
  }

  void _onBackPressed() {
    print("on back pressed ..............");
    setState(() => _isPaused = true); // Oyun duraklatıldı
    _showPauseDialog(); // Duraklatma dialogu aç
    SoundHelper.pauseLastSeconds();
  }

  // Duraklatma dialogu
  Future<void> _showPauseDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışında dokunulmaz
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 320,
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Üst mor bar
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5058E2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      "DURAKLATILDI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Uyarı yazısı
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Çıkmak istediğine emin misin?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Butonlar (Ana Menü / Devam Et)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Ana Menü (sol)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4F81),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Cubitleri resetle
                            context.read<CurrentNameCubit>().reset();
                            context.read<ScoreCubit>().reset();
                            _timer?.cancel();
                            _sensorSub?.cancel();

                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BottomNavPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Ana Menü",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Devam Et (sağ)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CD964),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() => _isPaused = false); // Oyuna devam et
                            SoundHelper.resumeLastSeconds();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Devam Et",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Skor widgetı
  Widget _buildScore() {
    return Align(alignment: Alignment.bottomCenter, child: GameScore());
  }

  // Timer widgetı
  Widget _buildTimer() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GameTimer(
          remainingSeconds:
              _remainingSeconds ?? context.read<TimerCubit>().state,
          totalSeconds: context.read<TimerCubit>().state,
        ),
      ),
    );
  }

  // Süre bitti overlay
  Widget _buildTimeOverOverlay() {
    return Container(
      color: AppColors.timeUp,
      alignment: Alignment.center,
      child: const Text(
        "Süre Bitti!",
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
