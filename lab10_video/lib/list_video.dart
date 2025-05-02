import 'package:flutter/material.dart';
import 'item_usuario.dart';

class ListVideo extends StatelessWidget {
  final List<Map<String, dynamic>> videos = [
    {
      'name': 'Cocción de avena',
      'time': '0:26',
      'size': '15 MB',
      'url':
          'https://videos.pexels.com/video-files/31145489/13307747_1920_1080_30fps.mp4',
    },
    {
      'name': 'Preparación pastas',
      'time': '0:06',
      'size': '22 MB',
      'url':
          'https://videos.pexels.com/video-files/4146104/4146104-hd_1920_1080_24fps.mp4',
    },
    {
      'name': 'Pintado',
      'time': '0:04',
      'size': '10 MB',
      'url':
          'https://videos.pexels.com/video-files/15832152/15832152-hd_1920_1080_30fps.mp4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return ItemUsuario(video: videos[index]);
      },
    );
  }
}
