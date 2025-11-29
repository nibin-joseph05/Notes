import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/settings_provider.dart';
import 'settings_toggle.dart';

class PermissionWidget extends ConsumerStatefulWidget {
  const PermissionWidget({super.key});

  @override
  ConsumerState<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends ConsumerState<PermissionWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPermission();
    }
  }

  Future<void> checkPermission() async {
    final status = await Permission.microphone.status;
    ref.read(settingsProvider.notifier)
        .toggleVoicePermission(status.isGranted);
  }

  Future<void> requestMic() async {
    await Permission.microphone.request();
    await checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return SettingsToggle(
      title: "Voice Permission",
      value: settings.voicePermission,
      onToggle: (val) async {
        if (val) {
          await requestMic();
        } else {
          ref.read(settingsProvider.notifier)
              .toggleVoicePermission(false);
        }
      },
    );
  }
}
