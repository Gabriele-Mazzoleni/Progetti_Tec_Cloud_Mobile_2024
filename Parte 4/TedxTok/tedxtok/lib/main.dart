import 'package:flutter/material.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';

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
            color: tedTokColors.tedRed, //Rosso TedTok
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Image.asset(
                  'assets/images/Logo_Bianco.png', // Path to the image asset
                  height: 50, // Adjust the height as needed
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Instructions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please select a list of topics that might interest you',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  borderRadius: BorderRadius.circular(10),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                // Funzione di OnPressed, la aggiungeremo più tardi
              },
              child: Center(
                child: Text(
                  "LET'S BEGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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

class topicItem extends StatelessWidget {
  final String topic;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  topicItem({required this.topic, required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: tedTokColors.tokBlue
          ),
          SizedBox(width: 10),
          Text(
            topic,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
