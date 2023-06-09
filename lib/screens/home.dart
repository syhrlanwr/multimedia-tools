import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = <Widget>[
      Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Resize'),
            subtitle: const Text('Resize an image'),
            leading: const Icon(Icons.aspect_ratio),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/image/resize');
            },
          ),
          ListTile(
            title: const Text('Transform'),
            subtitle:
                const Text('Transform an image, such as rotate, flip, etc.'),
            leading: const Icon(Icons.rotate_90_degrees_ccw),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/image/transform');
            },
          ),
          ListTile(
            title: const Text('Filter'),
            subtitle: const Text('Apply a filter to an image'),
            leading: const Icon(Icons.filter),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/image/filter');
            },
          ),
        ],
      ),
      Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Compress'),
            subtitle: const Text('Reduce the size of an audio'),
            leading: const Icon(Icons.compress),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/audio/compress');
            },
          ),
          ListTile(
            title: const Text('Convert'),
            subtitle: const Text('Convert an audio to another format'),
            leading: const Icon(Icons.swap_horiz),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/audio/convert');
            },
          ),
          ListTile(
            title: const Text('Pitch'),
            subtitle: const Text('Change the pitch of an audio'),
            leading: const Icon(Icons.music_note),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/audio/pitch');
            },
          ),
          ListTile(
            title: const Text('Speed'),
            subtitle: const Text('Change the speed of an audio'),
            leading: const Icon(Icons.speed),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/audio/speed');
            },
          ),
          ListTile(
            title: const Text('Concat'),
            subtitle: const Text('Concatenate two or more audios'),
            leading: const Icon(Icons.merge_type),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/audio/trim');
            },
          ),
        ],
      ),
      Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Under construction'),
            IconButton(
              icon: const Icon(Icons.construction),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: tabs[selectedIndex],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                label: 'Image Processing',
                icon: Icon(Icons.image),
              ),
              BottomNavigationBarItem(
                label: 'Audio Processing',
                icon: Icon(Icons.audiotrack),
              ),
              BottomNavigationBarItem(
                label: 'Video Processing',
                icon: Icon(Icons.video_collection),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: (index) => setState(() => selectedIndex = index)));
  }
}
