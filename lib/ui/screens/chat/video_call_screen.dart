import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String otherName;
  const VideoCallScreen({super.key, required this.otherName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _micEnabled = true;
  bool _cameraEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey.shade900,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                        size: 100, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 20),
                    Text(
                      widget.otherName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "جارٍ الاتصال...",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlBtn(
                    icon: _micEnabled ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                    bgColor: Colors.white.withValues(alpha: 0.2),
                    onTap: () => setState(() => _micEnabled = !_micEnabled),
                  ),
                  _buildControlBtn(
                    icon: Icons.call_end,
                    color: Colors.white,
                    bgColor: Colors.redAccent,
                    onTap: () => Navigator.pop(context),
                    size: 70,
                  ),
                  _buildControlBtn(
                    icon: _cameraEnabled ? Icons.videocam : Icons.videocam_off,
                    color: Colors.white,
                    bgColor: Colors.white.withValues(alpha: 0.2),
                    onTap: () =>
                        setState(() => _cameraEnabled = !_cameraEnabled),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 100,
                height: 140,
                color: Colors.black54,
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBtn({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
    double size = 50,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
