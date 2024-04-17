import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Tpay payment model.
class TpayPayment {
  /// Creates a new Tpay payment.
  TpayPayment({
    required this.id,
    required this.amount,
    required this.description,
    required this.crc,
    this.securityCode,
    this.md5Code,
    this.online,
    this.canal,
    this.group,
    this.direct,
    this.resultUrl,
    this.resultEmail,
    this.sellerDescription,
    this.additionalDescription,
    this.returnUrl = 'https://secure.tpay.com/mobile-sdk/success',
    this.returnErrorUrl = 'https://secure.tpay.com/mobile-sdk/error',
    this.language,
    this.clientEmail,
    this.clientName,
    this.clientAddress,
    this.clientCity,
    this.clientCode,
    this.clientCountry,
    this.clientPhone,
    this.acceptTerms,
  })  : paymentLink = _buildPaymentLink(
          id: id,
          amount: amount,
          description: description,
          crc: crc,
          securityCode: securityCode,
          online: online,
          canal: canal,
          group: group,
          direct: direct,
          resultUrl: resultUrl,
          resultEmail: resultEmail,
          sellerDescription: sellerDescription,
          additionalDescription: additionalDescription,
          returnUrl: returnUrl,
          returnErrorUrl: returnErrorUrl,
          language: language,
          clientEmail: clientEmail,
          clientName: clientName,
          clientAddress: clientAddress,
          clientCity: clientCity,
          clientCode: clientCode,
          clientCountry: clientCountry,
          clientPhone: clientPhone,
          acceptTerms: acceptTerms,
        ),
        assert(
          md5Code != null || securityCode != null,
          'You must provide either md5Code or securityCode',
        );

  /// Creates a new Tpay payment from a payment link.
  TpayPayment.fromLink(this.paymentLink)
      : id = null,
        amount = null,
        description = null,
        crc = null,
        securityCode = null,
        md5Code = null,
        online = null,
        canal = null,
        group = null,
        direct = null,
        resultUrl = null,
        resultEmail = null,
        sellerDescription = null,
        additionalDescription = null,
        returnUrl = 'about:blank?status=success',
        returnErrorUrl = 'about:blank?status=error',
        language = null,
        clientEmail = null,
        clientName = null,
        clientAddress = null,
        clientCity = null,
        clientCode = null,
        clientCountry = null,
        clientPhone = null,
        acceptTerms = null;

  final String? paymentLink;
  final String? id;
  final String? amount;
  final String? description;
  final String? crc;
  final String? securityCode;
  final String? md5Code;
  final String? online;
  final String? canal;
  final String? group;
  final String? direct;
  final String? resultUrl;
  final String? resultEmail;
  final String? sellerDescription;
  final String? additionalDescription;
  final String returnUrl;
  final String returnErrorUrl;
  final String? language;
  final String? clientEmail;
  final String? clientName;
  final String? clientAddress;
  final String? clientCity;
  final String? clientCode;
  final String? clientCountry;
  final String? clientPhone;
  final String? acceptTerms;

  TpayPayment copyWith({
    String? paymentLink,
    String? id,
    String? amount,
    String? description,
    String? crc,
    String? securityCode,
    String? md5Code,
    String? online,
    String? canal,
    String? group,
    String? direct,
    String? resultUrl,
    String? resultEmail,
    String? sellerDescription,
    String? additionalDescription,
    String? returnUrl,
    String? returnErrorUrl,
    String? language,
    String? clientEmail,
    String? clientName,
    String? clientAddress,
    String? clientCity,
    String? clientCode,
    String? clientCountry,
    String? clientPhone,
    String? acceptTerms,
  }) {
    return TpayPayment(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      crc: crc ?? this.crc,
      securityCode: securityCode ?? this.securityCode,
      md5Code: md5Code ?? this.md5Code,
      online: online ?? this.online,
      canal: canal ?? this.canal,
      group: group ?? this.group,
      direct: direct ?? this.direct,
      resultUrl: resultUrl ?? this.resultUrl,
      resultEmail: resultEmail ?? this.resultEmail,
      sellerDescription: sellerDescription ?? this.sellerDescription,
      additionalDescription:
          additionalDescription ?? this.additionalDescription,
      returnUrl: returnUrl ?? this.returnUrl,
      returnErrorUrl: returnErrorUrl ?? this.returnErrorUrl,
      language: language ?? this.language,
      clientEmail: clientEmail ?? this.clientEmail,
      clientName: clientName ?? this.clientName,
      clientAddress: clientAddress ?? this.clientAddress,
      clientCity: clientCity ?? this.clientCity,
      clientCode: clientCode ?? this.clientCode,
      clientCountry: clientCountry ?? this.clientCountry,
      clientPhone: clientPhone ?? this.clientPhone,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }

  static String _buildPaymentLink({
    String? id,
    String? amount,
    String? description,
    String? crc,
    String? securityCode,
    String? md5Code,
    String? online,
    String? canal,
    String? group,
    String? direct,
    String? resultUrl,
    String? resultEmail,
    String? sellerDescription,
    String? additionalDescription,
    String? returnUrl = 'https://secure.tpay.com/mobile-sdk/success',
    String? returnErrorUrl = 'https://secure.tpay.com/mobile-sdk/error',
    String? language,
    String? clientEmail,
    String? clientName,
    String? clientAddress,
    String? clientCity,
    String? clientCode,
    String? clientCountry,
    String? clientPhone,
    String? acceptTerms,
  }) {
    final buffer = StringBuffer('https://secure.tpay.com/?id=')
      ..write(Uri.encodeComponent(id ?? ''))
      ..writeAndUrlEncode('amount', amount)
      ..writeAndUrlEncode('description', description)
      ..writeAndUrlEncode('crc', crc);

    if (md5Code?.isNotEmpty ?? false) {
      buffer.write('&md5sum=$md5Code');
    } else {
      buffer
        ..write('&md5sum=')
        ..write(
          md5.convert(utf8.encode('$id&$amount&$crc&$securityCode')).toString(),
        );
    }

    if (online?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('online', online);
    }

    if (canal?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('kanal', canal);
    }

    if (group?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('grupa', group);
    }

    if (resultUrl?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('result_url', returnUrl);
    }

    if (resultEmail?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('result_email', resultEmail);
    }

    if (sellerDescription?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('merchant_description', sellerDescription);
    }

    if (additionalDescription?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('custom_description', additionalDescription);
    }

    if (returnUrl?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('return_url', returnUrl);
    }

    if (returnErrorUrl?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('return_error_url', returnErrorUrl);
    }

    if (language?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('language', language);
    }

    if (clientEmail?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('email', clientEmail);
    }

    if (clientName?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('name', clientName);
    }

    if (clientAddress?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('address', clientAddress);
    }

    if (clientCity?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('city', clientCity);
    }

    if (clientCode?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('zip', clientCode);
    }

    if (clientCountry?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('country', clientCountry);
    }

    if (clientPhone?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('phone', clientPhone);
    }

    if (acceptTerms?.isNotEmpty ?? false) {
      buffer.writeAndUrlEncode('accept_tos', acceptTerms);
    }

    return buffer.toString();
  }
}

extension on StringBuffer {
  void writeAndUrlEncode(String field, String? value) {
    if (value?.isNotEmpty ?? false) {
      write('&$field=');
      write(Uri.encodeComponent(value!));
    }
  }
}
