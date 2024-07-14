import 'package:flutter/material.dart';
import 'package:tedxtok/Functions/database.dart';
import 'package:tedxtok/Models/topicItem.dart';
import 'package:tedxtok/Models/userData.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';
import 'package:tedxtok/Styles/fontStyles.dart';
import 'package:tedxtok/Styles/sizes.dart';
import 'package:tedxtok/talkDisplayPage.dart';

class TopicSelectionPage extends StatefulWidget {
  final UserData userData;
  TopicSelectionPage({required this.userData});

  @override
  _TopicSelectionPageState createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
  late List<String> topics=[];
  late List<bool> checkedTopics;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    await Database.init();
    topics = await Database.getTopics();
    checkedTopics = List<bool>.filled(topics.length, false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredTopics = topics
        .where(
            (topic) => topic.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: tedTokColors.tedRed,
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
                    'assets/images/Logo_Bianco.png',
                    height: sizes.imgSize,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Hello, ${widget.userData.username}',
                style: fontStyles.introText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'please select a list of topics that might interest you',
                style: fontStyles.introText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(sizes.smallRoundedCorner),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for a topic',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizes.smallRoundedCorner),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredTopics.length,
                          itemBuilder: (context, index) {
                            String topic = filteredTopics[index];
                            int originalIndex = topics.indexOf(topic);
                            return topicItem(
                              topic: topic,
                              isChecked: checkedTopics[originalIndex],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedTopics[originalIndex] = value ?? false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tedTokColors.tokBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sizes.stdRoundedCorner),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
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
                          TalkDisplayPage(selectedTags: selectedTopics),
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
      ),
    );
  }
}
