import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class WallpaperCropScreen extends StatefulWidget {
  final String imagePath;
  const WallpaperCropScreen({super.key, required this.imagePath});

  @override
  State<WallpaperCropScreen> createState() => _WallpaperCropScreenState();
}

class _WallpaperCropScreenState extends State<WallpaperCropScreen> {
  final _cropController = CropController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Adjust Wallpaper",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Stack(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.70,
                child: Crop(
                  image: File(widget.imagePath).readAsBytesSync(),
                  controller: _cropController,
                  onCropped: (output) {
                    Navigator.pop(context, output);
                  },
                  initialSize: 0.75,
                  withCircleUi: false,
                  interactive: true,
                ),
              ),
            ),
          ),

          if (_loading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            setState(() => _loading = true);
            _cropController.crop();
          },
          child: const Text(
            "Apply Wallpaper",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
