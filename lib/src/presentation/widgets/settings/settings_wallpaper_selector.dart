import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/settings_provider.dart';
import 'WallpaperCropScreen.dart';

class WallpaperSelectorWidget extends ConsumerWidget {
  const WallpaperSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return ListTile(
      title: const Text("Wallpaper", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        settings.wallpaperPath.isNotEmpty
            ? "Custom wallpaper selected"
            : "Default wallpaper",
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => const _WallpaperDialog(),
        );
      },
    );
  }
}

class _WallpaperDialog extends ConsumerWidget {
  const _WallpaperDialog();

  Future<void> _changeWallpaper(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(settingsProvider.notifier);
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final croppedBytes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WallpaperCropScreen(imagePath: picked.path),
      ),
    );

    if (croppedBytes != null) {
      final file = File("${picked.path}_crop.png");
      await file.writeAsBytes(croppedBytes);
      notifier.setWallpaper(file.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final size = MediaQuery.of(context).size;


    final dialogWidth = size.width * 0.88;
    final previewHeight = size.height * 0.24;
    final isSmallPhone = size.height < 650;

    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.82),
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(isSmallPhone ? 14 : 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Wallpaper",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: previewHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: settings.wallpaperPath.isNotEmpty
                        ? FileImage(File(settings.wallpaperPath))
                        : const AssetImage("assets/bg-image/bg.webp")
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo, size: 20),
                    label: const Text("Change"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: isSmallPhone ? 10 : 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () => _changeWallpaper(context, ref),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.restore, size: 20),
                    label: const Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: isSmallPhone ? 10 : 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      notifier.setWallpaper("");
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Go Back",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
