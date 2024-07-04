import 'package:flutter/material.dart';
import 'package:tedxtok/Styles/TedTokColors.dart';

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