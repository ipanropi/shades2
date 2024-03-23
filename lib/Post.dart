class Post {

  final String content;
  final String post_id;
  final String title;
  final String to_char;
  final int views;

  Post({required this.content, required this.post_id ,required this.title, required this.to_char, required this.views});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'] as String,
      post_id: json['post_id'] as String,
      title: json['title'] as String,
      to_char: json['to_char'] as String,
      // Ensure comments is a List<String>, assuming it's already in that format from the API
      views: json['views'] as int,
    );
  }
}