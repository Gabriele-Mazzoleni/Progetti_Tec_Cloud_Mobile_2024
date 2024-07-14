import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/buildHtmlVideoPage.dart';
import 'package:tedxtok/Functions/database.dart';
import 'package:tedxtok/Functions/talk_list.dart';
import 'package:tedxtok/Models/Talk.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

class TalkDisplayPage extends StatefulWidget {
  final List<String> selectedTags;

  TalkDisplayPage({required this.selectedTags});

  @override
  _TalkDisplayPageState createState() => _TalkDisplayPageState();
}

class _TalkDisplayPageState extends State<TalkDisplayPage> {
  late Future<List<Talk>> _talks;
  late InAppWebViewController? _webViewController;
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _talks = getTalkstByTagList(widget.selectedTags);
  }

   @override
  void dispose() { // Cancella il timer se esiste quando la pagina viene eliminata
    _timer?.cancel(); 
    super.dispose();
  }

 void _stopVideo(List<Talk> talks) {
  int currentPage = _pageController.page?.toInt() ?? 0;
  if (currentPage < talks.length - 1) {
    _pageController.animateToPage(
      currentPage + 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  } else {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}

  void _startTimer(List<Talk> talks) {
  _timer?.cancel(); // Cancella qualsiasi timer esistente
  _timer = Timer(Duration(minutes: 1), () => _stopVideo(talks)); // Imposta il timer per 1 minuto
}

  
  void _launchUrl(String url) async {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Talk>>(
        future: _talks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: tedTokColors.tokBlue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No talks available',style: fontStyles.ErrorText,),
            );
          } else {
            List<Talk> talks = snapshot.data!;
            return PageView.builder(
              controller: _pageController,
              scrollDirection:
                  Axis.vertical, // Abilita lo scorrimento verticale
              itemCount: talks.length,
              itemBuilder: (context, index) {
                Talk talk = talks[index];
                String videoUrl = talk.url;
                String htmlString = buildHtmlVideoPage(videoUrl);

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
                              child: Icon(Icons.link_rounded,
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
                        borderRadius: BorderRadius.circular(sizes.smallRoundedCorner),
                        child: InAppWebView(
                          initialData:
                              InAppWebViewInitialData(data: htmlString),
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true, // Abilita JavaScript
                            useOnLoadResource: true, // Utilizza per il caricamento delle risorse
                          ),
                          onWebViewCreated: (controller) {
                            _webViewController = controller;
                            _startTimer(talks); // Avvia il timer quando il WebView viene creato
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