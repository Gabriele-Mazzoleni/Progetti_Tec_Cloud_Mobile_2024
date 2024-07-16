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
        //resizeToAvoidBottomInset: false,
        body: LogInPage(),
      ),
    );
  }
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _signInMailController = TextEditingController();
  final TextEditingController _signInUsernameController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();

  String errorMessage = '';
  String signInErrorMessage = '';
  bool isLoading = false;
  bool isSignInLoading = false;

  void _navigateToTopicSelectionPage(UserData user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicSelectionPage(userData: user),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = await userSearcher(
        _mailController.text,
        _passwordController.text,
      );
      _navigateToTopicSelectionPage(user);
    } catch (e) {
      setState(() {
        errorMessage = 'Invalid credentials. Please try again.';
        isLoading = false;
        _mailController.clear();
        _passwordController.clear();
      });
    }
  }

  void _showSignInModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Sign In'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _signInMailController,
                      decoration: InputDecoration(
                        hintText: 'Mail',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: tedTokColors.tedRed),
                        ),
                      ),
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    TextField(
                      controller: _signInPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: tedTokColors.tedRed),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    TextField(
                      controller: _signInUsernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: tedTokColors.tedRed),
                        ),
                      ),
                    ),
                    if (signInErrorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          signInErrorMessage,
                          style: TextStyle(color: tedTokColors.tedRed),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: tedTokColors.tedRed, // Rosso TedTok
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                        ),
                      ),
                  onPressed: () {
                    signInErrorMessage='';
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: tedTokColors.tedRed, // Rosso TedTok
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                        ),
                      ),
                  onPressed: isSignInLoading ? null : () {
                    setState(() {
                      isSignInLoading = true;
                      signInErrorMessage = '';
                    });
                    _signin(setState);
                  },
                  child: isSignInLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _signin(StateSetter setState) async {
    try {
      final user = await userAdder(
        _signInMailController.text,
        _signInUsernameController.text,
        _signInPasswordController.text,
      );
      Navigator.of(context).pop();
      _navigateToTopicSelectionPage(user);
    } catch (e) {
      setState(() {
        signInErrorMessage = 'Error during sign-in. Please try again.';
        isSignInLoading = false;
        _signInMailController.clear();
        _signInUsernameController.clear();
        _signInPasswordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:SafeArea(
      child: SingleChildScrollView(
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
                  CarouselView() // immagini sono predeterminate
                ],
              ),
            ),
            SizedBox(height: sizes.stdPaddingSpace),
            // log-in/sign-in box
            Padding(
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
                    TextField(
                      // campo per inserire la mail
                      controller: _mailController,
                      decoration: const InputDecoration(
                        hintText: 'Mail',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: tedTokColors.tokBlue),
                        ),
                      ),
                      cursorColor: tedTokColors.tokBlue,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    TextField(
                      // campo per inserire la password
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: tedTokColors.tokBlue),
                        ),
                      ),
                      cursorColor: tedTokColors.tokBlue,
                      obscureText: true,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    // loginButton
                    if (isLoading)
                      CircularProgressIndicator(color: tedTokColors.tokBlue)
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tedTokColors.tokBlue, // Azzurro TedTok
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                          ),
                        ),
                        onPressed: _login,
                        child: const Center(
                          child: Text(
                            "LOG IN",
                            style: fontStyles.buttonText,
                          ),
                        ),
                      ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: tedTokColors.tedRed),
                        ),
                      ),
                    SizedBox(height: sizes.stdPaddingSpace),
                    Text(
                      'Not registered yet?',
                      style: fontStyles.flavourText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sizes.smallPaddingSpace),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tedTokColors.tedRed, // Rosso TedTok
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                        ),
                      ),
                      onPressed: () {
                        _showSignInModal(context);
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
            SizedBox(height: sizes.stdPaddingSpace),
          ],
        ),
      ),
      ),
    );
  }
}
