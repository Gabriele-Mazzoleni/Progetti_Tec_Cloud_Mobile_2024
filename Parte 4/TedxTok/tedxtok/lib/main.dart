import 'package:flutter/material.dart';
import 'package:tedxtok/Models/topicItem.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:tedxtok/secondPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Lista dei topic, per la build demo iniziamo con 20 argomenti possibili
  final List<String> topics = [
    'TED Membership',
    'evolution',
    'wildlife',
    'aliens',
    'bionics',
    'painting',
    'personal growth',
    'war',
    'augmented reality',
    'communication',
    'crime',
    'encryption',
    'medical research',
    'nuclear energy',
    'ocean',
    'religion',
    'sleep',
    'visualizations',
    'beauty',
    'metaverse',
  ];

  // Lista di booleani per tenere traccia dello stato delle checkbox
  late List<bool> checkedTopics;

  @override
  void initState() {
    super.initState();
    // Inizializza la lista dei booleani con 'false'
    checkedTopics = List<bool>.filled(topics.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: tedTokColors.tedRed, // Rosso TedTok
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(sizes.stdRoundedCorner),
                bottomRight: Radius.circular(sizes.stdRoundedCorner),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'WELCOME',
                      style: fontStyles.headerText,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'TO',
                      style: fontStyles.headerText,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/Logo_Bianco.png', // Path to the image asset
                  height: sizes.imgSize,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please select a list of topics that might interest you',
              style: fontStyles.introText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          // List of Topics
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(sizes.smallRoundedCorner),
                ),
                child: ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return topicItem(
                      topic: topics[index],
                      isChecked: checkedTopics[index],
                      onChanged: (bool? value) {
                        setState(() {
                          checkedTopics[index] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Button

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tedTokColors.tokBlue, // Azzurro TedTok
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                // Raccogli i tag selezionati
                List<String> selectedTopics = [];
                for (int i = 0; i < topics.length; i++) {
                  if (checkedTopics[i]) {
                    selectedTopics.add(topics[i]);
                  }
                }
                // Naviga alla seconda pagina
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondPage(selectedTags: selectedTopics),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "LET'S BEGIN",
                  style: fontStyles.buttonText,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

