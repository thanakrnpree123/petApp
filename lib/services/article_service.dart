import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/article.dart';

class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Article>> watchArticles() {
    return _firestore
        .collection('articles')
        .orderBy('published_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Article.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }
}
