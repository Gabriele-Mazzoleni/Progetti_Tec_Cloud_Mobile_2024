import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TedxTok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> _isChecked = [];
  List<String> _tags = [
    'Immigration',
    'TED Connects',
    'Decision-making',
    'Marketing',
    'Planets',
    'Beauty',
    'Photography',
    'AI',
    'Motivation',
    'Painting',
    'Egypt',
    'Crime',
    'Design',
    'Discovery',
    'Exercise',
    'Medical research',
    'Sleep',
    'Evolution',
    'Leadership',
    'Gaming',
  ];

  @override
  void initState() {
    super.initState();
    _isChecked = List.filled(_tags.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'Welcome to TedxTok',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Please select a list of topics that might interest you:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0), // Spazio tra il testo e i checkbox
                    Column(
                      children: _tags.map((tag) {
                        int index = _tags.indexOf(tag);
                        return CheckboxRow(
                          index: index,
                          isChecked: _isChecked[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked[index] = value ?? false;
                            });
                          },
                          tag: tag,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0), // Margine sopra al bottone
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Get the selected tags
                    List<String> selectedTags = [];
                    for (int i = 0; i < _isChecked.length; i++) {
                      if (_isChecked[i]) {
                        selectedTags.add(_tags[i]);
                      }
                    }

                    // Navigate to the next page with selected tags
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondPage(selectedTags: selectedTags),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.lightBlue, // Colore del bottone azzurro
                    foregroundColor: Colors.white, // Colore del testo bianco
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Bordi arrotondati
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20), // Aumenta l'area di click
                  ),
                  child: Text("LET'S BEGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckboxRow extends StatelessWidget {
  final int index;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String tag;

  CheckboxRow({
    required this.index,
    required this.isChecked,
    required this.onChanged,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align to the left
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(tag),
      ],
    );
  }
}
class SecondPage extends StatefulWidget {
  final List<String> selectedTags;

  SecondPage({required this.selectedTags});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      );
      await _videoPlayerController.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: true,
          allowPlaybackSpeedChanging: true,
          allowFullScreen: true,
          placeholder: Container(
            color: Colors.black,
          ),
        );
        setState(() {});
      });
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    if (_videoPlayerController.value.isInitialized) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Center(
                child: Text(
                  'TedxTok',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'This is a sample video description. You can add your own video description here',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('TedxTok'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
