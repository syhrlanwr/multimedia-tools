import 'package:flutter/material.dart';
import 'package:mulmed/screens/audio_compress.dart';
import 'package:mulmed/screens/home.dart';
import 'package:mulmed/screens/image_filter.dart';
import 'package:mulmed/screens/image_resize.dart';
import 'package:mulmed/screens/image_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multimedia Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      routes: {
        '/': (context) => const Home(title: 'Multimedia Tools'),
        '/image/resize': (context) => const ImageResize(title: 'Resize Image'),
        '/image/transform': (context) =>
            const ImageTransform(title: 'Transform Image'),
        '/image/filter': (context) => const ImageFilter(title: 'Filter Image'),
        '/audio/compress': (context) =>
            const AudioCompress(title: 'Compress Audio'),
      },
    );
  }
}
