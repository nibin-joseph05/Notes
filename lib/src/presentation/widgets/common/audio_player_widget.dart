import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onRemove;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.onRemove,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late PlayerController waveController;
  late AudioPlayer audioPlayer;

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool waveformReady = false;

  @override
  void initState() {
    super.initState();

    waveController = PlayerController();
    audioPlayer = AudioPlayer();

    if (File(widget.audioPath).existsSync()) _init();
  }

  Future<void> _init() async {
    waveController.updateFrequency = UpdateFrequency.high;

    await waveController.extractWaveformData(
      path: widget.audioPath,
      noOfSamples: 800,
    );
    waveformReady = true;

    await waveController.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: false,
    );

    await waveController.setFinishMode(finishMode: FinishMode.loop);

    await audioPlayer.setFilePath(widget.audioPath);

    audioPlayer.positionStream.listen((p) {
      position = p;
      waveController.seekTo(position.inMilliseconds);
      if (mounted) setState(() {});
    });

    audioPlayer.durationStream.listen((d) {
      if (d != null && mounted) setState(() => duration = d);
    });

    if (mounted) setState(() {});
  }

  Future<void> togglePlay() async {
    if (!waveformReady) return;

    if (!isPlaying) {
      await audioPlayer.play();
      await waveController.startPlayer();
    } else {
      await audioPlayer.pause();
      await waveController.pausePlayer();
    }

    if (mounted) setState(() => isPlaying = !isPlaying);
  }

  String format(Duration d) =>
      "${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  void dispose() {
    try {
      audioPlayer.stop();
      audioPlayer.dispose();
      waveController.stopPlayer();
      waveController.dispose();
    } catch (_) {}
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!File(widget.audioPath).existsSync()) return const SizedBox();

    final isTablet = MediaQuery.of(context).size.width > 700;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 14,
        vertical: isTablet ? 14 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: togglePlay,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: isTablet ? 44 : 32,
                  color: Colors.tealAccent,
                ),
              ),
              Expanded(
                child: AudioFileWaveforms(
                  size: Size(double.infinity, isTablet ? 55 : 40),
                  playerController: waveController,
                  enableSeekGesture: true,
                  waveformType: WaveformType.long,
                  playerWaveStyle: PlayerWaveStyle(
                    fixedWaveColor: Colors.tealAccent.withOpacity(0.45),
                    liveWaveColor: Colors.tealAccent,
                    scaleFactor: isTablet ? 160 : 130,
                    spacing: 6,
                  ),
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(format(position), style: TextStyle(color: Colors.white70)),
              Text(format(duration), style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
