// lib/screens/shared/youtube_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewtube/webviewtube.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String? title;

  const YouTubePlayerScreen({
    super.key,
    required this.videoId,
    this.title,
  });

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  WebviewtubeController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initController();
  }

  void _initController() {
    try {
      _controller = WebviewtubeController(
        options: const WebviewtubeOptions(
          showControls: true,
        ),
        onPlayerError: (_) {
          if (mounted) setState(() => _hasError = true);
        },
      );
    } catch (e) {
      _hasError = true;
    }
  }

  @override
  void dispose() {
    try {
      _controller?.dispose();
    } catch (_) {
      // Ignore platform channel errors during disposal
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: widget.title != null
            ? Text(
                widget.title!,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
      body: _hasError || _controller == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load video player',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _initController();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Center(
              child: WebviewtubePlayer(
                videoId: widget.videoId,
                controller: _controller!,
              ),
            ),
    );
  }
}
