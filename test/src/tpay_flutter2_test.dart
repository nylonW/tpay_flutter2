// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:tpay_flutter2/tpay_flutter.dart';

void main() {
  group('TpayFlutter2', () {
    // test transaction
    test('test transaction', () async {
      final payment = TpayPayment(
        id: '51092',
        amount: '1.0',
        description: 'test',
        crc: 'test',
        securityCode: 'E71y1g0H1Y66FaRl',
        clientEmail: 'mrvrota+dev6@gmail.com',
        clientName: r'Marcin $Ślusarek',
      );

      final url = payment.paymentLink;
      expect(url, isNotNull);
      print(url);
    });
  });
}
