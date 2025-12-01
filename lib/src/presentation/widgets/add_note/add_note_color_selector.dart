import 'package:flutter/material.dart';

class AddNoteColorSelector extends StatelessWidget {
  final int? selectedColor;
  final ValueChanged<int?> onColorSelected;

  const AddNoteColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.white,
      Colors.yellow.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.pink.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
    ];

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
          itemCount: colors.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            if (i == 0) {
              return GestureDetector(
                onTap: () => onColorSelected(null),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == null ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              );
            }

            final color = colors[i - 1];
            final isSelected = selectedColor == color.value;

            return GestureDetector(
              onTap: () => onColorSelected(color.value),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
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
