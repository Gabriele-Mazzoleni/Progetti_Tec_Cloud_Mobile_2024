import 'package:flutter/material.dart';

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
      home: TopicSelectionPage(),
    );
  }
}

class TopicSelectionPage extends StatefulWidget {
  @override
  _TopicSelectionPageState createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
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

  late List<bool> checkedTopics;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    checkedTopics = List<bool>.filled(topics.length, false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredTopics = topics
        .where(
            (topic) => topic.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('TedxTok'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please select a list of topics that might interest you:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a topic',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: filteredTopics.map((topic) {
                        int index = topics.indexOf(topic);
                        return CheckboxListTile(
                          title: Text(topic),
                          value: checkedTopics[index],
                          onChanged: (bool? value) {
                            setState(() {
                              checkedTopics[index] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    List<String> selectedTopics = [];
                    for (int i = 0; i < topics.length; i++) {
                      if (checkedTopics[i]) {
                        selectedTopics.add(topics[i]);
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondPage(selectedTags: selectedTopics),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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

class SecondPage extends StatelessWidget {
  final List<String> selectedTags;

  SecondPage({required this.selectedTags});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Tags:'),
            Column(
              children: selectedTags.map((tag) => Text(tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
