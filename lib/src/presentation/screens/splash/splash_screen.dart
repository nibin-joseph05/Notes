import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../src/core/routes/app_routes.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _textController;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();


    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);


    _scaleController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation =
        Tween<double>(begin: 0.75, end: 1.0).animate(CurvedAnimation(
          parent: _scaleController,
          curve: Curves.easeOutBack,
        ));


    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));


    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 250), () => _fadeController.forward());
    Future.delayed(const Duration(milliseconds: 450), () => _textController.forward());


    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                "assets/logo/logo.webp",
                width: 150,
              ),
            ),
            const SizedBox(height: 18),
            SlideTransition(
              position: _textSlideAnimation,
              child: const Text(
                "Your thoughts in one place",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 35),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation(
                    Color(0xFF121530),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
