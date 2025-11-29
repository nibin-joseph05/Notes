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
        title: const Text("Adjust Wallpaper"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Crop(
            image: File(widget.imagePath).readAsBytesSync(),
            controller: _cropController,
            onCropped: (output) {
              Navigator.pop(context, output);
            },
            withCircleUi: false,
            initialSize: 0.9,
            interactive: true,
          ),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
          onPressed: () async {
            setState(() => _loading = true);
            _cropController.crop();
          },
          child: const Text("Apply"),
        ),
      ),
    );
  }
}
