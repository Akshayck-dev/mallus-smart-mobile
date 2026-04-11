import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/screens/onboarding_screen.dart';
import 'package:mallu_smart/widgets/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    Widget nextScreen = isFirstLaunch ? const OnboardingScreen() : const MainNavigation();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle Kerala-inspired background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: PatternPainter(),
            ),
          ).animate().fadeIn(duration: 1500.ms),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Container with a premium glow
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CuratorDesign.primaryOrange.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.storefront_rounded, 
                                size: 80, 
                                color: CuratorDesign.primaryOrange
                              ),
                              const SizedBox(height: 8),
                              Text('LOGO HERE', 
                                style: CuratorDesign.label(10, color: CuratorDesign.textLight)
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ).animate()
                 .scale(duration: 1000.ms, curve: Curves.easeOutBack)
                 .fadeIn(duration: 800.ms)
                 .shimmer(delay: 1500.ms, duration: 2000.ms, color: Colors.white54),
                
                const SizedBox(height: 50),
                
                // Animated Branding
                Column(
                  children: [
                    Text(
                      'MALLU\'S MART',
                      style: CuratorDesign.display(32, color: CuratorDesign.textDark)
                          .copyWith(letterSpacing: 4, fontWeight: FontWeight.w900),
                    ).animate()
                     .slideY(begin: 0.5, duration: 800.ms, delay: 500.ms)
                     .fadeIn(duration: 800.ms, delay: 500.ms),
                    
                    const SizedBox(height: 12),
                    
                    Container(
                      height: 2,
                      width: 40,
                      color: CuratorDesign.primaryOrange,
                    ).animate()
                     .scaleX(begin: 0, duration: 600.ms, delay: 1000.ms),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'KERALA HOMEPRENEURS UNITED',
                      style: CuratorDesign.label(12, color: CuratorDesign.textLight)
                          .copyWith(letterSpacing: 2),
                    ).animate()
                     .slideY(begin: 1.0, duration: 800.ms, delay: 1200.ms)
                     .fadeIn(duration: 800.ms, delay: 1200.ms),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom subtle indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CuratorDesign.primaryOrange.withValues(alpha: 0.3)
                  ),
                ),
              ),
            ).animate()
             .fadeIn(delay: 2000.ms),
          ),
        ],
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CuratorDesign.primaryOrange.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 60.0;
    for (double i = 0; i < size.width + spacing; i += spacing) {
      for (double j = 0; j < size.height + spacing; j += spacing) {
        // Draw a subtle leaf-like motif or geometric pattern
        _drawMotif(canvas, Offset(i, j), paint);
      }
    }
  }

  void _drawMotif(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    const size = 15.0;
    
    // Subtle diamond/leaf shape
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx + size, center.dy, center.dx, center.dy + size);
    path.quadraticBezierTo(center.dx - size, center.dy, center.dx, center.dy - size);
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
