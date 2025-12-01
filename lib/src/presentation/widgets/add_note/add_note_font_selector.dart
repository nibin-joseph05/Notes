import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/fonts/app_fonts.dart';

class AddNoteFontSelector extends StatelessWidget {
  final String? selectedFont;
  final ValueChanged<String?> onFontSelected;

  const AddNoteFontSelector({
    super.key,
    required this.selectedFont,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: AppFonts.fontNames.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final font = AppFonts.fontNames[i];
            final isSelected = selectedFont == font;

            return GestureDetector(
              onTap: () => onFontSelected(font),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(.22)
                      : Colors.white.withOpacity(.09),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.greenAccent : Colors.white24,
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  font,
                  style: GoogleFonts.getFont(
                    font,
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
