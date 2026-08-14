import 'package:flutter_test/flutter_test.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';

void main() {
  test(
      'different context ids create different conversation ids for the same users',
      () {
    final first = buildConversationId(
      userAId: 'user-a',
      userBId: 'user-b',
      contextId: 'request-1',
    );
    final second = buildConversationId(
      userAId: 'user-a',
      userBId: 'user-b',
      contextId: 'request-2',
    );

    expect(first, isNot(equals(second)));
  });

  test('same context id reuses the same conversation id', () {
    final first = buildConversationId(
      userAId: 'user-a',
      userBId: 'user-b',
      contextId: 'request-1',
    );
    final second = buildConversationId(
      userAId: 'user-a',
      userBId: 'user-b',
      contextId: 'request-1',
    );

    expect(first, equals(second));
  });
}
