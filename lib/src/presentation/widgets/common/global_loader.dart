import 'package:flutter/material.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.45),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.82, end: 1.0),
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Image.asset("assets/logo/logo.webp", width: 65),
                  );
                },
              ),

              const SizedBox(height: 26),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF121530)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


void showGlobalLoader(BuildContext context) {
  showDialog(
    context: Navigator.of(context, rootNavigator: true).context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (_) => const GlobalLoader(),
  );
}

void hideGlobalLoader(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

