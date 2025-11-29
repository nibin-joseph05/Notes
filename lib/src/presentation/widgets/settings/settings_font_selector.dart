import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class FontSelectorWidget extends ConsumerWidget {
  const FontSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final fonts = ["Poppins", "Roboto", "Lato", "Montserrat"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Font Style", style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 5),
        DropdownButton<String>(
          value: settings.fontFamily,
          dropdownColor: Colors.black,
          iconEnabledColor: Colors.white,
          items: fonts.map((font) {
            return DropdownMenuItem(value: font, child: Text(font));
          }).toList(),
          onChanged: (value) {
            ref.read(settingsProvider.notifier).changeFont(value!);
          },
        ),
      ],
    );
  }
}
