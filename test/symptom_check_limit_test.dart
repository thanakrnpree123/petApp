import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/services/symptom_check_service.dart';

void main() {
  group('SymptomCheckService.failOpen', () {
    test('blocks when the limit is known to be reached', () async {
      expect(await SymptomCheckService.failOpen(() async => true), isTrue);
    });

    test('allows when the limit is known not to be reached', () async {
      expect(await SymptomCheckService.failOpen(() async => false), isFalse);
    });

    test('allows the check when the count fails (e.g. offline)', () async {
      // Firestore count() queries need the server and throw offline.
      final result = await SymptomCheckService.failOpen(
        () async => throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unavailable',
        ),
      );
      expect(result, isFalse);
    });

    test('allows the check when the count hangs past the timeout', () async {
      final never = Completer<bool>();
      final result = await SymptomCheckService.failOpen(
        () => never.future,
        timeout: const Duration(milliseconds: 20),
      );
      expect(result, isFalse);
    });
  });
}
