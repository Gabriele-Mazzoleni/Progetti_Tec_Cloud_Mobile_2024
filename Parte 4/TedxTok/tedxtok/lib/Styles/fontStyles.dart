import 'package:flutter/material.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';

class fontStyles{
  fontStyles._();

  static const TextStyle headerText= TextStyle (color :  Colors.white,fontSize: 18,fontWeight: FontWeight.bold,);
  static const TextStyle introText= TextStyle(color :  Colors.black,fontSize: 16, fontWeight: FontWeight.bold); 
  static const TextStyle flavourText= TextStyle(color :  Colors.black,fontSize: 14, fontWeight: FontWeight.bold);                     
  static const TextStyle buttonText= TextStyle(color :  Colors.white,fontSize: 16, fontWeight: FontWeight.bold);   
  static const TextStyle TalkTitle= TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold );            
  static const TextStyle TalkSubitle= TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal ); 
  static const TextStyle ErrorText=TextStyle(fontSize: 16.0, color:tedTokColors.tokBlue,fontWeight: FontWeight.normal  );

}