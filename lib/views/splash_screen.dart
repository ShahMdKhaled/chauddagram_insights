import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chauddagram_insights/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Color?> _colorAnimation;

  final List<Color> _brandColors = [
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.tealAccent.shade400,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _textOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: _brandColors[0],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const BottomNav(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <-- White background
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Logo
                Container(
                  width: 120,
                  height: 120,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: _colorAnimation.value!.withOpacity(0.3),
                  //       blurRadius: 25,
                  //       spreadRadius: 5,
                  //     ),
                  //   ],
                  // ),
                  child: Image.asset('assets/images/bgrlogo.png', height: 80),
                ),

                const SizedBox(height: 30),

                // App Title
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Text(
                      'Chauddagram Insights',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Text(
                    'সকল সেবা একই সাথে',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loader
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _colorAnimation.value ?? Colors.blueAccent,
                  ),
                  strokeWidth: 3,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
