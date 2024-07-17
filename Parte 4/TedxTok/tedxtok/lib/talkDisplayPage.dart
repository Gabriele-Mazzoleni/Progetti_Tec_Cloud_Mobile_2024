import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/buildHtmlVideoPage.dart';
import 'package:tedxtok/Functions/database.dart';
import 'package:tedxtok/Functions/talk_list.dart';
import 'package:tedxtok/Models/Talk.dart';
import 'package:tedxtok/Models/userData.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:tedxtok/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

class TalkDisplayPage extends StatefulWidget {
  final List<String> selectedTags;
  final UserData userData;

  TalkDisplayPage({required this.selectedTags, required this.userData});

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

      //drawer contenente i dati dell'utente e le operazioni di logout
        endDrawer: Drawer(
          backgroundColor: tedTokColors.tedRed,
            child: Column(
              children: [
               Container(
                height: sizes.drawerHeaderSize,
                 child: DrawerHeader(
                    child: Text('User Information', style: fontStyles.TalkTitle),
                 ),
               ),
              ListTile(
                title: Text('Username: ${widget.userData.username}', style: fontStyles.TalkSubitle),
              ),
              ListTile(
                title: Text('Mail: ${widget.userData.mail}', style: fontStyles.TalkSubitle),
              ),
              SizedBox(height: sizes.stdPaddingSpace),
            SizedBox(
              width: 120.0,
              child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                            backgroundColor: tedTokColors.tokBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                              side: BorderSide(
                                color: Colors.white, // Specifica il colore del bordo desiderato
                                width: 3, // Specifica la larghezza del bordo
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LogInPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('LOG OUT',style: fontStyles.logoutButtonText ),
              ),
            ),
          ],
        ),
      ),

      //pagina vera e propria
      body: Builder(
        builder: (context) => FutureBuilder<List<Talk>>(
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
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No talks available', style: fontStyles.ErrorText),
              );
            } else {
              List<Talk> talks = snapshot.data!;
              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
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
                          color: tedTokColors.tedRed,
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
                                  'assets/images/Logo_Bianco.png',
                                  height: sizes.imgSize,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () { //apertura del drawer laterale
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: Icon(Icons.person,
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
                            initialData: InAppWebViewInitialData(data: htmlString),
                            initialSettings: InAppWebViewSettings(
                              javaScriptEnabled: true,
                              useOnLoadResource: true,
                            ),
                            onWebViewCreated: (controller) {
                              _webViewController = controller;
                              _startTimer(talks);
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
                            color: tedTokColors.tokBlue,
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
                              Text(talk.mainSpeaker, style: fontStyles.TalkSubitle),
                              Text('Duration: ${talk.duration} seconds', style: fontStyles.TalkSubitle),
                              InkWell(
                                onTap: () {
                                  _launchUrl(talk.url);
                                },
                                child: Icon(Icons.link_rounded, color: Colors.white, size: sizes.iconSize),
                              ),
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
      ),
    );
  }
}