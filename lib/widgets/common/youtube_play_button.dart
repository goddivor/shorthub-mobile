// lib/widgets/common/youtube_play_button.dart
import 'package:flutter/material.dart';

class YouTubePlayButton extends StatelessWidget {
  final double size;

  const YouTubePlayButton({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.7,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}
