import 'package:flutter/material.dart';

class WallpaperSelectorWidget extends StatelessWidget {
  const WallpaperSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Change Wallpaper", style: TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.image, color: Colors.white),
      onTap: () {
        // later: open image picker
      },
    );
  }
}
