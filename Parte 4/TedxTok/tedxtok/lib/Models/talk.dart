class Talk{
  final String title;
  final String mainSpeaker;
  final String url;
  final String duration;

  Talk.fromJSON(Map<String, dynamic> jsonMap) :
    title = jsonMap['title'],
    mainSpeaker = (jsonMap['speakers'] ?? ""),
    url = (jsonMap['url'] ?? ""),
    duration=(jsonMap['duration']??"");
}