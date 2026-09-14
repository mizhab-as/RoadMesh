import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Branded in-app splash.
///
/// Android 12+ always shows a brief system splash (icon on white bg).
/// This screen appears to continue from that — the icon is at FULL opacity
/// from frame 0 so there is no "second splash" feeling. The pulse rings
/// and text then animate in on top of the already-visible icon.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Pulse rings loop continuously
  late final AnimationController _pulseController;

  // Text + rings fade IN quickly (not the icon — icon is visible from frame 0)
  late final AnimationController _textFadeController;
  late final Animation<double> _textFade;

  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textFade = CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeOut,
    );
    // Brief delay then fade text in — rings already pulsing from frame 0
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _textFadeController.forward();
    });

    _splashTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _pulseController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.iconBackground),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon — NO fade-in, visible immediately at full opacity
              // so it looks like a direct continuation of the system splash
              SizedBox(
                width: 220,
                height: 220,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _MeshBeaconPainter(progress: _pulseController.value),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              // Text fades in shortly after so it feels like the icon
              // was always there and now the brand completes
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                        children: [
                          TextSpan(
                            text: 'ROAD',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: 'MESH',
                            style: TextStyle(color: AppColors.meshGreenDark),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'COOPERATIVE VEHICLE AWARENESS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeshBeaconPainter extends CustomPainter {
  _MeshBeaconPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.54);
    final top = Offset(size.width / 2, size.height * 0.20);
    final left = Offset(size.width * 0.24, size.height * 0.72);
    final right = Offset(size.width * 0.76, size.height * 0.72);

    // Pulse rings
    for (final phase in [0.0, 0.33, 0.66]) {
      final t = (progress + phase) % 1.0;
      final radius = 14 + t * 46;
      final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
      final ringPaint = Paint()
        ..color = AppColors.alertRed.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(center, radius, ringPaint);
    }

    // Mesh edges
    final linePaint = Paint()
      ..color = AppColors.lineStructure
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(top, left, linePaint);
    canvas.drawLine(top, right, linePaint);
    canvas.drawLine(left, right, linePaint);
    canvas.drawLine(top, center, linePaint);
    canvas.drawLine(center, left, linePaint);
    canvas.drawLine(center, right, linePaint);

    // Outer nodes — green
    final nodePaint = Paint()..color = AppColors.meshGreen;
    for (final p in [top, left, right]) {
      canvas.drawCircle(p, 8.5, nodePaint);
    }

    // Ego vehicle — blue
    final glowPaint = Paint()
      ..color = AppColors.vehicleBlue.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, 18, glowPaint);
    canvas.drawCircle(center, 12, Paint()..color = AppColors.vehicleBlue);
  }

  @override
  bool shouldRepaint(covariant _MeshBeaconPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
