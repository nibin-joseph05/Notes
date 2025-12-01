import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNoteAudioRecorder extends StatefulWidget {
  final void Function(File file) onFinished;
  const AddNoteAudioRecorder({super.key, required this.onFinished});

  @override
  State<AddNoteAudioRecorder> createState() => _AddNoteAudioRecorderState();
}

class _AddNoteAudioRecorderState extends State<AddNoteAudioRecorder> {
  late RecorderController recorderController;
  String? audioPath;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..sampleRate = 44100
      ..bitRate = 128000;
  }

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required")),
      );
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    audioPath = "${dir.path}/note_audio_${DateTime.now().millisecondsSinceEpoch}.m4a";

    await recorderController.record(path: audioPath!);
    setState(() => isRecording = true);

    showRecordingOverlay();
  }

  void showRecordingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.45),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.88),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.tealAccent, width: 1.2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Recording…",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    AudioWaveforms(
                      size: const Size(250, 45),
                      recorderController: recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.tealAccent,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.stop),
                      label: const Text("Stop"),
                      onPressed: () async {
                        await recorderController.stop();
                        Navigator.pop(context);
                        setState(() => isRecording = false);

                        if (audioPath != null && File(audioPath!).existsSync()) {
                          widget.onFinished(File(audioPath!));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic, color: Colors.white, size: 26),
      onPressed: startRecording,
    );
  }
}
