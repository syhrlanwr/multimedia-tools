import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class AudioCompress extends StatefulWidget {
  const AudioCompress({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AudioCompress> createState() => _AudioCompressState();
}

class _AudioCompressState extends State<AudioCompress> {
  AudioPlayer player = AudioPlayer();
  File? compressedAudio;
  File? selectedAudio;
  bool isCompressing = false;

  saveAudio() async {
    if (compressedAudio == null) return;
    final directory = await getExternalStorageDirectory();
    final name = path.basename(compressedAudio!.path);
    final newPath = path.join(directory!.path, name);
    await compressedAudio!.copy(newPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to $newPath'),
      ),
    );
  }

  Future<void> getAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'wav', 'ogg', 'aac', 'amr', 'flac'],
    );
    if (result == null) return;
    final path = result.files.single.path!;
    final file = File(path);
    setState(() {
      selectedAudio = file;
      player.setFilePath(path);
    });
  }

  compressAudio() async {
    if (selectedAudio == null) return;
    setState(() {
      isCompressing = true;
    });
    final directory = await getTemporaryDirectory();
    final output = path.join(directory.path, 'output.m4a');
    final arguments =
        '-i ${selectedAudio!.path} -map 0:a:0 -c:a aac $output -y';
    FFmpegKit.execute(arguments).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        setState(() {
          compressedAudio = File(output);
          player.setFilePath(output);
          isCompressing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compression complete'),
          ),
        );
        Navigator.pop(context);
      } else if (ReturnCode.isCancel(returnCode)) {
        print('Compression cancelled');
      } else {
        print('Error during compression');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during compression'),
          ),
        );
        final logs = await session.getAllLogs();
        print('FFmpeg process exited with rc $returnCode and the following '
            'output logs:');
        for (final log in logs) {
          print(log.getMessage());
        }
      }
    });
  }

  Future<void> playAudio() async {
    if (selectedAudio == null) return;
    await player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: selectedAudio != null
            ? [
                IconButton(
                  onPressed: () => saveAudio(),
                  icon: Icon(Icons.save),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedAudio != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Icon(Icons.play_arrow),
                        onPressed: () => playAudio(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Icon(Icons.pause),
                        onPressed: () => player.pause(),
                      ),
                    ),
                  ],
                ),
              // show audio progress bar
              if (selectedAudio != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<Duration?>(
                    stream: player.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          var position = snapshot.data ?? Duration.zero;
                          if (position > duration) {
                            position = duration;
                          }
                          return ProgressBar(
                            progress: position,
                            total: duration,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

              if (selectedAudio == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => getAudio(),
                    child: Text('Select audio'),
                  ),
                ),
              if (selectedAudio != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Audio size: ${num.parse((selectedAudio!.lengthSync() / 1024 / 1024).toStringAsFixed(2))} MB',
                  ),
                ),
              if (compressedAudio != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Compressed audio size: ${num.parse((compressedAudio!.lengthSync() / 1024 / 1024).toStringAsFixed(2))} MB',
                  ),
                ),
              if (selectedAudio != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          child: Text('Compress audio'),
                          onPressed: () {
                            compressAudio();
                            if (isCompressing) {
                              // show loading dialog when isCompressing is true and hide it when it's false
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 16),
                                      Text('Compressing audio...'),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text('Clear audio'),
                        onPressed: () => setState(() {
                          File(selectedAudio!.path).delete();
                          if (compressedAudio != null) {
                            File(compressedAudio!.path).delete();
                          }
                          compressedAudio = null;
                          selectedAudio = null;
                          // clear file cache
                          player.dispose();
                          player = AudioPlayer();
                        }),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
