import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/talk_list.dart';
import 'package:tedxtok/Models/Talk.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondPage extends StatefulWidget {
  final List<String> selectedTags;

  SecondPage({required this.selectedTags});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  //late Future<List<Talk>> _talks;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    //_talks= getTalkstByTagList(widget.selectedTags);
    
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

    void _launchUrl() async {
    final url = 'https://www.ted.com/talks/jessie_christiansen_what_the_discovery_of_exoplanets_reveals_about_the_universe';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            //header
            Container( 
              decoration: const BoxDecoration(
                color: tedTokColors.tedRed, // Rosso TedTok
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(sizes.stdRoundedCorner),
                  bottomRight: Radius.circular(sizes.stdRoundedCorner),
                ),
              ),
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      //icon: Icon(Icons.add_box_outlined, color: Colors.whitesize: sizes.iconSize,), 
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: sizes.iconSize,), 
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/Logo_Bianco.png', // Path to the image asset
                        height: sizes.imgSize,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.send_rounded, color: Colors.white, size:sizes.iconSize),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                color: tedTokColors.tokBlue, // Rosso TedTok
                borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(sizes.stdRoundedCorner),
                   topRight: Radius.circular(sizes.stdRoundedCorner),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample video title',
                      style: fontStyles.TalkTitle,
                    ),
                    Text(
                      'Sample video description',
                      style:fontStyles.TalkSubitle,
                    ),
                    ElevatedButton(
                      onPressed: _launchUrl,
                      child: Text('Visit TED.com'),
                    ),
                  ], 
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Image.asset(
                  'assets/images/Logo_Bianco.png', // Path to the image asset
                  height: sizes.imgSize*2,
                ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
