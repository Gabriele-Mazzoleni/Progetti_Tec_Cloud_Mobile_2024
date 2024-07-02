class RelatedTalk{
  final String id;
  final String title;
  final String mainSpeaker;
  final String url;

  RelatedTalk.fromJSON(Map<String, dynamic> jsonMap) :
    id= jsonMap['related_video_ids'],
    title = jsonMap['related_video_title'],
    mainSpeaker = (jsonMap['related_presentedBy'] ?? ""),
    url = (jsonMap['related_url'] ?? "");
}