import 'package:expenz/services/exceptions/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapFirebaseAuthExceptionCode', () {
    test('maps network errors to a useful message', () {
      expect(
        mapFirebaseAuthExceptionCode('network-request-failed'),
        isNot(equals('An unknown error occurred.')),
      );
    });

    test('maps internal auth errors to a useful message', () {
      expect(
        mapFirebaseAuthExceptionCode('internal-error'),
        isNot(equals('An unknown error occurred.')),
      );
    });
  });
}
