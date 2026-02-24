import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessagePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const AudioMessagePlayer({
    super.key,
    required this.audioUrl,
    required this.isMe,
  });

  @override
  State<AudioMessagePlayer> createState() => _AudioMessagePlayerState();
}

class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setSourceUrl(widget.audioUrl);

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.completed) {
            _position = Duration.zero;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = widget.isMe ? Colors.white : Colors.black87;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: fgColor),
                )
              : Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                  color: fgColor),
          onPressed: () async {
            if (_isPlaying) {
              await _player.pause();
            } else {
              setState(() => _isLoading = true);
              try {
                await _player.resume();
              } catch (e) {
                // handle error
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            }
          },
        ),
        Slider(
          activeColor: fgColor,
          inactiveColor: fgColor.withValues(alpha: 0.3),
          min: 0,
          max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
          value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0),
          onChanged: (val) {
            _player.seek(Duration(seconds: val.toInt()));
          },
        ),
        Text(
          _formatDuration(_position.inSeconds > 0 ? _position : _duration),
          style: TextStyle(color: fgColor, fontSize: 12),
        ),
      ],
    );
  }
}
