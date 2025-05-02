import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'info_video.dart';
import 'video_controller.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String videoName;
  final String videoTime;
  final String videoSize;

  const VideoPage({
    Key? key,
    required this.videoUrl,
    required this.videoName,
    required this.videoTime,
    required this.videoSize,
  }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideo;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _initializeVideo = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName),
      ),
      body: Column(
        children: [
          //Carga del video
          FutureBuilder(
            future: _initializeVideo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  //Vista del video
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller),
                          VideoController(controller: _controller),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InfoVideo(
              name: widget.videoName,
              time: 'Duración: ${widget.videoTime}',
              size: 'Tamaño: ${widget.videoSize}',
            ),
          ),
        ],
      ),
    );
  }
}
