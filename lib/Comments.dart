class Comments {

  final String comment_id;
  final String content;
  final String to_char;

  Comments({required this.content, required this.comment_id, required this.to_char});

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      comment_id: json['comment_id'] as String,
      content: json['content'] as String,
      to_char: json['to_char'] as String,
    );
  }
}