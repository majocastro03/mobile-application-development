import 'package:flutter/material.dart';

import 'video_page.dart';

class ItemUsuario extends StatelessWidget {
  final Map<String, dynamic> video;

  const ItemUsuario({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill,
                    color: Colors.red, size: 60),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPage(
                        videoUrl: video['url'],
                        videoName: video['name'],
                        videoTime: video['time'],
                        videoSize: video['size'],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('Tiempo: ${video['time']}'),
                  Text('Tamaño: ${video['size']}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
