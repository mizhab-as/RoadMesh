import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Branded splash shown immediately after the native (static) splash hands
/// off to Flutter. Reproduces the mesh/beacon/radar mark with a live pulse
/// on the app's actual light surface, then calls [onDone].
///
/// Usage:
///   MaterialApp(home: SplashScreen(onDone: () => Navigator.pushReplacement(...)))
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2200), widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
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
              SizedBox(
                width: 220,
                height: 220,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _MeshBeaconPainter(progress: _controller.value),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                  children: [
                    TextSpan(text: 'ROAD', style: TextStyle(color: AppColors.textPrimary)),
                    TextSpan(text: 'MESH', style: TextStyle(color: AppColors.meshGreenDark)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'COOPERATIVE VEHICLE AWARENESS',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
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

  /// 0..1, looping
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.54);
    final top = Offset(size.width / 2, size.height * 0.20);
    final left = Offset(size.width * 0.24, size.height * 0.72);
    final right = Offset(size.width * 0.76, size.height * 0.72);

    // Collision-radar pulse — red, three staggered rings looping on `progress`,
    // matching the live in-app alert halo around the vehicle marker.
    for (final phase in [0.0, 0.33, 0.66]) {
      final t = (progress + phase) % 1.0;
      final radius = 14 + t * 46;
      final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
      final ringPaint = Paint()
        ..color = AppColors.alertRed.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(center, radius, ringPaint);
    }

    // Mesh edges — structural, road-like
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

    // Outer mesh nodes — connected vehicles, safe/green
    final nodePaint = Paint()..color = AppColors.meshGreen;
    for (final p in [top, left, right]) {
      canvas.drawCircle(p, 8.5, nodePaint);
    }

    // Ego vehicle beacon — blue, matches the map's own car marker
    final glowPaint = Paint()
      ..color = AppColors.vehicleBlue.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, 18, glowPaint);
    canvas.drawCircle(center, 12, Paint()..color = AppColors.vehicleBlue);
  }

  @override
  bool shouldRepaint(covariant _MeshBeaconPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
