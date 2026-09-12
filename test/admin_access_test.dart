import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/providers/subscription_provider.dart';
import 'package:pawhealth/services/admin_access.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Fails the test if the admin path touches RevenueCat at all.
class _RecordingRevenueCat implements RevenueCatService {
  final calls = <String>[];
  CustomerInfoUpdateListener? listener;

  @override
  bool get canSell {
    calls.add('canSell');
    return true;
  }

  @override
  Future<bool> init({required String appUserId}) async {
    calls.add('init');
    return true;
  }

  @override
  Future<OfferingsResult> fetchOfferings() async {
    calls.add('fetchOfferings');
    return const OfferingsUnavailable(OfferingsFailure.notSetUp);
  }

  @override
  Future<void> logOut() async => calls.add('logOut');

  @override
  void addCustomerInfoListener(CustomerInfoUpdateListener l) => listener = l;

  @override
  void removeCustomerInfoListener(CustomerInfoUpdateListener l) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Any Firestore use throws: the admin path must not need it.
class _UnusedFirestore implements FirebaseFirestore {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('isAdminEmail', () {
    test('matches the admin address however it is cased or padded', () {
      expect(AdminAccess.isAdminEmail('Thanakarn.123@gmail.com'), isTrue);
      // What Firebase Auth actually returns: lowercased.
      expect(AdminAccess.isAdminEmail('thanakarn.123@gmail.com'), isTrue);
      expect(AdminAccess.isAdminEmail(' THANAKARN.123@GMAIL.COM '), isTrue);
    });

    test('rejects anything else', () {
      expect(AdminAccess.isAdminEmail(null), isFalse);
      expect(AdminAccess.isAdminEmail(''), isFalse);
      expect(AdminAccess.isAdminEmail('thanakarn.1234@gmail.com'), isFalse);
      expect(
        AdminAccess.isAdminEmail('thanakarn.123@gmail.com.evil.io'),
        isFalse,
      );
      expect(AdminAccess.isAdminEmail('thanakarn.preecha@gmail.com'), isFalse);
    });
  });

  group('SubscriptionProvider admin override', () {
    late _RecordingRevenueCat revenueCat;
    late SubscriptionProvider provider;

    setUp(() {
      revenueCat = _RecordingRevenueCat();
      provider = SubscriptionProvider(
        service: revenueCat,
        firestore: _UnusedFirestore(),
      );
    });

    test('grants Plus without touching RevenueCat or Firestore', () async {
      await provider.init('uid-1', email: 'thanakarn.123@gmail.com');

      expect(provider.isPlusMember, isTrue);
      expect(provider.isAdmin, isTrue);
      expect(provider.errorCode, isNull);
      expect(revenueCat.calls, isEmpty);
    });

    test(
      'a RevenueCat update without the entitlement keeps admin Plus',
      () async {
        await provider.init('uid-1', email: 'thanakarn.123@gmail.com');
        revenueCat.listener!(CustomerInfo.fromJson(_noEntitlements));

        expect(provider.isPlusMember, isTrue);
      },
    );

    test('everyone else goes through RevenueCat', () async {
      await provider.init('uid-2', email: 'someone@example.com');

      expect(provider.isAdmin, isFalse);
      expect(provider.isPlusMember, isFalse);
      expect(revenueCat.calls, containsAll(['init', 'fetchOfferings']));
      expect(provider.errorCode, 'not-set-up');
      expect(provider.availability, PurchaseAvailability.unavailable);
    });

    test('signing out drops admin access for the next user', () async {
      await provider.init('uid-1', email: 'thanakarn.123@gmail.com');
      await provider.reset();

      expect(provider.isAdmin, isFalse);
      expect(provider.isPlusMember, isFalse);
    });
  });
}

// A minimal CustomerInfo payload, as the native SDK would send it.
const _noEntitlements = <String, dynamic>{
  'entitlements': {'all': {}, 'active': {}, 'verification': 'NOT_REQUESTED'},
  'allPurchaseDates': {},
  'activeSubscriptions': [],
  'allPurchasedProductIdentifiers': [],
  'nonSubscriptionTransactions': [],
  'firstSeen': '2026-09-12T00:00:00.000Z',
  'originalAppUserId': 'uid-1',
  'allExpirationDates': {},
  'requestDate': '2026-09-12T00:00:00.000Z',
  'latestExpirationDate': null,
  'originalPurchaseDate': null,
  'originalApplicationVersion': null,
  'managementURL': null,
};
