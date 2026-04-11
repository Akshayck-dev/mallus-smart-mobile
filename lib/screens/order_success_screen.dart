import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/design_system.dart';
import '../widgets/deep_heat_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Cinematic backdrop
      body: Stack(
        children: [
          // 1. Layered Background Build
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF151515), Colors.black],
                ),
              ),
            ),
          ),
          
          // Cinematic Lens Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ).animate().fadeIn(duration: 800.ms),

          // 2. The Trophy Build
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Lottie with glow
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: CuratorDesign.primaryOrange.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CuratorDesign.primaryOrange.withOpacity(0.4),
                            blurRadius: 60,
                            spreadRadius: 20,
                          )
                        ],
                      ),
                    ).animate().scale(begin: const Offset(0, 0), curve: Curves.easeOutBack, duration: 800.ms),
                    
                    Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_kz9pjcsh.json',
                      width: 240,
                      height: 240,
                      repeat: false,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'ORDER IN PREPARATION',
                  style: CuratorDesign.label(12, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 4),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                
                const SizedBox(height: 12),
                
                Text(
                  'SUCCESS!',
                  style: CuratorDesign.display(48, color: Colors.white).copyWith(letterSpacing: 2),
                ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ),

          // 3. Floating Glassmorphic Order Card
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'REDIRECTED TO WHATSAPP',
                        style: CuratorDesign.label(10, color: Colors.white70).copyWith(letterSpacing: 2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Our curators are now processing your request. You\'ll receive a confirmation chat shortly.',
                        textAlign: TextAlign.center,
                        style: CuratorDesign.body(14, color: Colors.white54).copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      DeepHeatButton(
                        text: 'RETURN TO GALLERY',
                        onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}
