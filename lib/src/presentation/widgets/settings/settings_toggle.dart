import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsToggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onToggle;

  const SettingsToggle({
    super.key,
    required this.title,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        FlutterSwitch(
          value: value,
          width: 55,
          height: 28,
          toggleSize: 22,
          borderRadius: 20,
          padding: 3.5,
          activeColor: Colors.greenAccent.shade400,
          inactiveColor: Colors.white24,
          activeToggleColor: Colors.white,
          inactiveToggleColor: Colors.grey.shade300,
          duration: const Duration(milliseconds: 200),
          onToggle: onToggle,
        ),
      ],
    );
  }
}
