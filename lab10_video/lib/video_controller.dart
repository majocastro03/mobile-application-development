import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoController({Key? key, required this.controller}) : super(key: key);

  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  @override
  Widget build(BuildContext context) {
    // Super poner elementos
    return Stack(
      children: [
        //Icono para reproducir el video
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ),
                ),
        ),
        //Detectar para pausar o reproducir el video
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
      ],
    );
  }
}
