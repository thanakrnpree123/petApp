import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/config/legal_links.dart';

/// Shipped app builds link to these URLs, so each must map to a page the
/// web deploy publishes (web/ is served at /petApp/).
void main() {
  final links = {
    'terms': LegalLinks.termsOfUse,
    'privacy': LegalLinks.privacyPolicy,
    'account deletion': LegalLinks.accountDeletion,
  };

  for (final MapEntry(key: name, value: url) in links.entries) {
    test('the $name link points at a page in web/', () {
      expect(url.scheme, 'https');
      expect(url.path, startsWith('/petApp/'));
      final file = File('web/${url.path.substring('/petApp/'.length)}');
      expect(file.existsSync(), isTrue, reason: '${file.path} missing');

      final html = file.readAsStringSync();
      expect(html, contains('<title>'));
      // Each page links to the other two.
      for (final other in links.values) {
        expect(html, contains('href="${other.pathSegments.last}"'));
      }
    });
  }

  test('the support page exists and links to every legal page', () {
    final url = LegalLinks.support;
    final file = File('web/${url.path.substring('/petApp/'.length)}');
    expect(file.existsSync(), isTrue);
    final html = file.readAsStringSync();
    for (final other in links.values) {
      expect(html, contains('href="${other.pathSegments.last}"'));
    }
    expect(html, contains('mailto:'));
  });
}
