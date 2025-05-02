import 'package:flutter/material.dart';
import 'list_video.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor de Videos'),
      ),
      body: ListVideo(),
    );
  }
}
