import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/fonts/app_fonts.dart';
import '../../providers/settings_provider.dart';

class FontSelectorWidget extends ConsumerWidget {
  const FontSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final fonts = [
      "Poppins",
      "Roboto",
      "Lato",
      "Montserrat",
      "Nunito",
      "Inter",
      "Quicksand",
      "Open Sans",
      "Manrope",
      "Caveat",
      "Indie Flower",
    ];

    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final tileHeight = isTablet ? 175 : 160;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Font Style",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fonts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: tileHeight / 160,
          ),
          itemBuilder: (context, index) {
            final font = fonts[index];
            final isSelected = settings.fontFamily == font;

            return GestureDetector(
              onTap: () => ref.read(settingsProvider.notifier).changeFont(font),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: isSelected ? 2.4 : 1.2,
                    color: isSelected
                        ? Colors.greenAccent
                        : Colors.white.withOpacity(0.12),
                  ),
                  color: Colors.white.withOpacity(isSelected ? 0.14 : 0.05),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.22),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      font,
                      style: GoogleFonts.getFont(
                        font,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        AppFonts.previewText,
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.getFont(
                          font,
                          fontSize: 15,
                          height: 1.35,
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: isSelected
                            ? const Icon(Icons.check_circle,
                            key: ValueKey(1),
                            color: Colors.greenAccent,
                            size: 20)
                            : const Icon(Icons.circle_outlined,
                            key: ValueKey(2),
                            color: Colors.white38,
                            size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
