class Story {
  final String id;
  final String coment;
  final String content;

  Story({
    required this.id,
    required this.coment,
    required this.content,
  });

  factory Story.fromMap(String id, Map<String, dynamic> map) {
    return Story(
      id: id,
      coment: map['coment'] ?? '',
      content: map['content'] ?? '',
    );
  }
}
