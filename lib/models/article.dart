import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String category;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromFirestore(String id, Map<String, dynamic> data) {
    return Article(
      id: id,
      title: data['title'] as String,
      category: data['category'] as String,
      content: data['content'] as String,
      imageUrl: data['image_url'] as String?,
      publishedAt: (data['published_at'] as Timestamp).toDate(),
    );
  }

  String get categoryLabel => category
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
