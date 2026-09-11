import 'package:cloud_firestore/cloud_firestore.dart';

/// Text stored once per app language, e.g. `{en: ..., th: ..., zh: ...}`.
class LocalizedText {
  final Map<String, String> _byLanguage;

  const LocalizedText(this._byLanguage);

  /// Reads a `{language: text}` map. A plain string — the format articles
  /// had before they were translated — counts as English.
  factory LocalizedText.fromFirestore(Object? value) => switch (value) {
    String text => LocalizedText({'en': text}),
    Map<Object?, Object?> map => LocalizedText({
      for (final MapEntry(:key, :value) in map.entries)
        if (key is String && value is String && value.trim().isNotEmpty)
          key: value,
    }),
    _ => const LocalizedText({}),
  };

  /// The text in [languageCode], else English, else any language there is.
  String of(String languageCode) =>
      _byLanguage[languageCode] ??
      _byLanguage['en'] ??
      (_byLanguage.isEmpty ? '' : _byLanguage.values.first);
}

class Article {
  final String id;
  final LocalizedText title;
  final String category;
  final LocalizedText content;
  final String? imageUrl;
  final DateTime publishedAt;

  const Article({
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
      title: LocalizedText.fromFirestore(data['title']),
      category: data['category'] as String,
      content: LocalizedText.fromFirestore(data['content']),
      imageUrl: data['image_url'] as String?,
      publishedAt: (data['published_at'] as Timestamp).toDate(),
    );
  }

  /// Fallback label for a category the app has no translation for.
  String get categoryLabel => category
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
