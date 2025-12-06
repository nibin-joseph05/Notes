import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AddNoteAudioRecorder extends StatefulWidget {
  final void Function(File file) onFinished;
  final Color? buttonColor;

  const AddNoteAudioRecorder({
    super.key,
    required this.onFinished,
    this.buttonColor,
  });

  @override
  State<AddNoteAudioRecorder> createState() => _AddNoteAudioRecorderState();
}

class _AddNoteAudioRecorderState extends State<AddNoteAudioRecorder>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  late AnimationController _animationController;
  late Animation<double> _animation;

  
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();
  final StreamController<bool> _pauseController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required to record audio'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${directory.path}/recording_$timestamp.m4a';

      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      if (mounted) {
        setState(() {
          _isRecording = true;
          _isPaused = false;
          _recordingDuration = Duration.zero;
        });
      }

      _startTimer();
      _showRecordingDialog();
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording({bool save = true}) async {
    _timer?.cancel();
    _animationController.stop();

    try {
      await _audioRecorder.stop();

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isPaused = false;
        });
      }

      if (save && _recordingPath != null && File(_recordingPath!).existsSync()) {
        widget.onFinished(File(_recordingPath!));
      } else if (_recordingPath != null) {
        
        final file = File(_recordingPath!);
        if (file.existsSync()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _audioRecorder.pause();
      if (mounted) {
        setState(() => _isPaused = true);
        _pauseController.add(true);
      }
      _timer?.cancel();
      _animationController.stop();
    } catch (e) {
      print('Error pausing recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      if (mounted) {
        setState(() => _isPaused = false);
        _pauseController.add(false);
      }
      _startTimer();
      _animationController.repeat(reverse: true);
    } catch (e) {
      print('Error resuming recording: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording && !_isPaused) {
        _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        _durationController.add(_recordingDuration);
      }
    });
  }

  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RecordingOverlay(
            isRecording: _isRecording,
            isPaused: _isPaused,
            duration: _recordingDuration,
            animation: _animation,
            durationStream: _durationController.stream,
            pauseStream: _pauseController.stream,
            onStop: () async {
              await _stopRecording(save: true);
              if (mounted) Navigator.of(dialogContext).pop();
            },
            onPause: _pauseRecording,
            onResume: _resumeRecording,
            onCancel: () async {
              await _stopRecording(save: false);
              if (mounted) Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _audioRecorder.dispose();
    _durationController.close();
    _pauseController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.buttonColor ?? Theme.of(context).primaryColor;

    return IconButton(
      icon: Icon(
        Icons.mic,
        color: buttonColor,
        size: 26,
      ),
      onPressed: _startRecording,
      tooltip: 'Start recording',
    );
  }
}

class RecordingOverlay extends StatefulWidget {
  final bool isRecording;
  final bool isPaused;
  final Duration duration;
  final Animation<double> animation;
  final Stream<Duration> durationStream;
  final Stream<bool> pauseStream;
  final VoidCallback onStop;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const RecordingOverlay({
    super.key,
    required this.isRecording,
    required this.isPaused,
    required this.duration,
    required this.animation,
    required this.durationStream,
    required this.pauseStream,
    required this.onStop,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  @override
  State<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends State<RecordingOverlay> {
  late Duration _currentDuration;
  late bool _currentIsPaused;

  @override
  void initState() {
    super.initState();
    _currentDuration = widget.duration;
    _currentIsPaused = widget.isPaused;

    
    widget.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _currentDuration = duration;
        });
      }
    });

    
    widget.pauseStream.listen((isPaused) {
      if (mounted) {
        setState(() {
          _currentIsPaused = isPaused;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12 * widget.animation.value,
                    decoration: BoxDecoration(
                      color: _currentIsPaused ? Colors.orange : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _currentIsPaused ? 'Recording Paused' : 'Recording...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            _formatDuration(_currentDuration),
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),

          const SizedBox(height: 32),

          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.05),
            ),
            child: CustomPaint(
              painter: _WaveformPainter(
                animationValue: widget.animation.value,
                isActive: widget.isRecording && !_currentIsPaused,
                waveColor: Colors.tealAccent,
              ),
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onStop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.stop, size: 28),
              ),

              ElevatedButton(
                onPressed: () {
                  if (_currentIsPaused) {
                    widget.onResume();
                  } else {
                    widget.onPause();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: Icon(
                  _currentIsPaused ? Icons.play_arrow : Icons.pause,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: widget.onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isActive;
  final Color waveColor;

  _WaveformPainter({
    required this.animationValue,
    required this.isActive,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = 4.0;
    final spacing = 2.0;
    final barsCount = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < barsCount; i++) {
      final x = i * (barWidth + spacing);
      final height = isActive
          ? (centerY * 0.7 * (1 + 0.3 * (animationValue - 1))) *
          (0.5 + 0.5 * (i % 3) / 3) *
          (1 + 0.2 * ((i * animationValue) % 2))
          : centerY * 0.3;

      final rect = Rect.fromLTWH(x, centerY - height / 2, barWidth, height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        isActive != oldDelegate.isActive ||
        waveColor != oldDelegate.waveColor;
  }
}