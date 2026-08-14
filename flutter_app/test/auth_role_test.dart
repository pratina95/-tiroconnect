import 'package:flutter_test/flutter_test.dart';
import 'package:tiroconnect/src/features/auth/domain/account_role.dart';

void main() {
  test('maps customer and worker roles to the correct destination', () {
    expect(getDestinationForRole('customer'), '/customer_home');
    expect(getDestinationForRole('worker'), '/worker-dashboard');
    expect(getDestinationForRole('unknown'), '/role');
  });
}
