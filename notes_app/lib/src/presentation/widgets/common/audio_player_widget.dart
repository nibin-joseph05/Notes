import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onRemove;
  final Color? waveColor;
  final Color? backgroundColor;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.onRemove,
    this.waveColor,
    this.backgroundColor,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;

  bool _isInitialized = false;
  bool _isLoading = false;
  Duration? _duration;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState(false, ProcessingState.idle);
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioSession();
    _initPlayer();
  }

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(
        AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.duckOthers,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ),
      );
    } catch (e) {
      print('Error initializing audio session: $e');
    }
  }

  Future<void> _initPlayer() async {
    if (!File(widget.audioPath).existsSync()) {
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _audioPlayer.setFilePath(widget.audioPath);
      _duration = _audioPlayer.duration;

      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (mounted && !_isSeeking) {
          setState(() => _playerState = state);
        }
      });

      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        if (mounted && !_isSeeking) {
          setState(() => _position = position);
        }
      });

      _durationSubscription = _audioPlayer.durationStream.listen((duration) {
        if (mounted) {
          setState(() => _duration = duration);
        }
      });

      _audioPlayer.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
          if (mounted) {
            setState(() {
              _playerState = PlayerState(false, ProcessingState.completed);
            });
          }
        }
      });

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing audio player: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _playPause() async {
    if (!_isInitialized || _isLoading) return;

    if (_playerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> _seekToPosition(double value) async {
    if (_duration == null) return;

    setState(() => _isSeeking = true);
    final position = Duration(
      milliseconds: (value * _duration!.inMilliseconds).round(),
    );
    await _audioPlayer.seek(position);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _isSeeking = false);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!File(widget.audioPath).existsSync()) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Audio file not found',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading audio...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Failed to load audio',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    final isTablet = MediaQuery.of(context).size.width > 700;
    final waveColor = widget.waveColor ?? Colors.tealAccent;
    final backgroundColor =
        widget.backgroundColor ?? Colors.black.withOpacity(0.05);
    final progress = _duration != null && _duration!.inMilliseconds > 0
        ? _position.inMilliseconds / _duration!.inMilliseconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 14,
        vertical: isTablet ? 14 : 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _playPause,
                icon: Icon(
                  _playerState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: isTablet ? 44 : 32,
                  color: waveColor,
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: waveColor,
                        inactiveTrackColor: waveColor.withOpacity(0.3),
                        thumbColor: waveColor,
                        overlayColor: waveColor.withOpacity(0.1),
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: _seekToPosition,
                        onChangeStart: (_) => _isSeeking = true,
                        onChangeEnd: (_) => _isSeeking = false,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration ?? Duration.zero),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.onRemove != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
