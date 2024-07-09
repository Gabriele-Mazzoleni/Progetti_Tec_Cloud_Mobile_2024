import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/talk_list.dart';
import 'package:tedxtok/Models/Talk.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SecondPage extends StatefulWidget {
  final List<String> selectedTags;

  SecondPage({required this.selectedTags});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late Future<List<Talk>> _talks;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _talks = getTalkstByTagList(widget.selectedTags);
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _buildHtmlVideoPage(String videoUrl) {
    // Estrae l'ID del talk dall'URL
    final talkId = videoUrl.split('/').last;
    final embedUrl = 'https://embed.ted.com/talks/$talkId';

    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: black;
          }
          iframe {
            width: 100%;
            height: 100%;
          }
        </style>
      </head>
      <body>
        <iframe src="$embedUrl" frameborder="0" allowfullscreen></iframe>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Talk>>(
        future: _talks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No talks available'),
            );
          } else {
            List<Talk> talks = snapshot.data!;
            return PageView.builder(
              scrollDirection:
                  Axis.vertical, // Abilita lo scorrimento verticale
              itemCount: talks.length,
              itemBuilder: (context, index) {
                Talk talk = talks[index];
                String videoUrl = talk.url;
                String htmlString = _buildHtmlVideoPage(videoUrl);

                return Column(
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
                              icon: Icon(Icons.arrow_back_rounded,
                                  color: Colors.white, size: sizes.iconSize),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                'assets/images/Logo_Bianco.png', // Percorso per l'immagine
                                height: sizes.imgSize,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                _launchUrl(talk.url);
                              },
                              child: Icon(Icons.send_rounded,
                                  color: Colors.white, size: sizes.iconSize),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: InAppWebView(
                          initialData:
                              InAppWebViewInitialData(data: htmlString),
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true, // Abilita JavaScript
                            useOnLoadResource:
                                true, // Utilizza per il caricamento delle risorse
                          ),
                          onWebViewCreated: (controller) {
                            _webViewController = controller;
                          },
                          onLoadError: (controller, url, code, message) {
                            print('WebView error: $code, $message');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: tedTokColors.tokBlue, // Blu TedTok
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
                              talk.title,
                              style: fontStyles.TalkTitle,
                            ),
                            Text(talk.mainSpeaker,
                                style: fontStyles.TalkSubitle),
                            Text('Duration: ${talk.duration} seconds',
                                style: fontStyles.TalkSubitle),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
