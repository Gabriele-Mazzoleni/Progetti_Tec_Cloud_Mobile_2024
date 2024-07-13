import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/log_in.dart';
import 'package:tedxtok/Models/carousel_view.dart';
import 'package:tedxtok/Models/userData.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:tedxtok/Styles/tedTokColors.dart';
import 'package:tedxtok/topicSelectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LogInPage(),
      ),
    );
  }
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}


//pagina di Login
class _LogInPageState extends State<LogInPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<UserData> user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Logo dell'applicazione
          Container(
            padding: EdgeInsets.symmetric(vertical: sizes.smallPaddingSpace),
            child: Image.asset(
              alignment: Alignment.center,
              'assets/images/TedTokLogo.png', // Path to the image asset
              height: sizes.smallimgSize,
            ),
          ),
          SizedBox(height: sizes.smallPaddingSpace),
          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'Here you can access a wide variety of talks, spanning hundreds of topics!',
                  style: fontStyles.flavourText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: sizes.smallPaddingSpace),
                CarouselView() //immagini sono predeterminate
              ],
            ),
          ),

          SizedBox(height: sizes.stdPaddingSpace),

          //log-in/sign-in box  
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: tedTokColors.tokBlue),
                  borderRadius: BorderRadius.circular(sizes.smallRoundedCorner),
                ),
                child: Column(
                  children: [
                    Text(
                      'Log in if you already have an account',
                      style: fontStyles.flavourText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    TextField( //campo per inserire la mail
                      controller: _mailController,
                      decoration:
                          const InputDecoration(hintText: 'Mail', 
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: tedTokColors.tokBlue),),
                          ),
                          cursorColor: tedTokColors.tokBlue,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    TextField( //campo per inserire la password
                      controller: _passwordController,
                      decoration:
                          const InputDecoration(hintText: 'Password',
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: tedTokColors.tokBlue),)
                          ),
                          cursorColor: tedTokColors.tokBlue,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    //loginButton
                   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tedTokColors.tokBlue, // Azzurro TedTok
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                      ),
                      ),
                      onPressed: () {
                        //esecuzione funzioni di login
                        setState(() {
                          try{
                            user = userSearcher(_mailController.text, _passwordController.text);
                            Navigator.push(
                            context,
                              MaterialPageRoute(
                                builder: (context) =>TopicSelectionPage(userData:user),),
                          );
                          }
                          catch(Exception){
                            Text(
                            'Invalid credentials. Please try again.',
                            style: TextStyle(color: tedTokColors.tedRed),
                            );
                          }
                          
                        });
                      },
                      child: const Center(
                        child: Text(
                         "LOG IN",
                         style: fontStyles.buttonText,
                       ),
                      ),
                    ),
                    SizedBox(height: sizes.stdPaddingSpace),
                    Text(
                      'Not registered yed?',
                      style: fontStyles.flavourText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tedTokColors.tedRed, // Azzurro TedTok
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                      ),
                      ),
                      onPressed: () {
                        //esecuzione funzioni di signin

                      },
                      child: const Center(
                        child: Text(
                         "SIGN IN",
                         style: fontStyles.buttonText,
                       ),
                      ),
                    ),
                  ],
              ),
              ),
            ),
          ),
          SizedBox(height: sizes.stdPaddingSpace),
          
        ],
      ),
    );
  }
}



