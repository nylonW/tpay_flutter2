import 'dart:convert';
import 'package:crypto/crypto.dart';

class TpayPayment {
  /// TODO: Add documentation
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
    this.returnUrl = 'about:blank?status=success',
    this.returnErrorUrl = 'about:blank?status=error',
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
        assert(md5Code != null || securityCode != null,
            'You must provide either md5Code or securityCode');

  /// TODO: Add documentation
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
    String? returnUrl = 'about:blank?status=success',
    String? returnErrorUrl = 'about:blank?status=error',
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
    var buffer = StringBuffer('https://secure.tpay.com/?id=')
      ..write(id)
      ..write('&kwota=$amount')
      ..write('&opis=$description')
      ..write('&crc=$crc');

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
      buffer.write('&online=$online');
    }

    if (canal?.isNotEmpty ?? false) {
      buffer.write('&kanal=$canal');
    }

    if (group?.isNotEmpty ?? false) {
      buffer.write('&grupa=$group');
    }

    if (resultUrl?.isNotEmpty ?? false) {
      buffer.write('&wyn_url=$resultUrl');
    }

    if (resultEmail?.isNotEmpty ?? false) {
      buffer.write('&wyn_email=$resultEmail');
    }

    if (sellerDescription?.isNotEmpty ?? false) {
      buffer.write('&opis_sprzed=$sellerDescription');
    }

    if (additionalDescription?.isNotEmpty ?? false) {
      buffer.write('&opis_dodatkowy=$additionalDescription');
    }

    if (returnUrl?.isNotEmpty ?? false) {
      buffer.write('&pow_url=$returnUrl');
    }

    if (returnErrorUrl?.isNotEmpty ?? false) {
      buffer.write('&pow_url_blad=$returnErrorUrl');
    }

    if (language?.isNotEmpty ?? false) {
      buffer.write('&jezyk=$language');
    }

    if (clientEmail?.isNotEmpty ?? false) {
      buffer.write('&email=$clientEmail');
    }

    if (clientName?.isNotEmpty ?? false) {
      buffer.write('&nazwisko=$clientName');
    }

    if (clientAddress?.isNotEmpty ?? false) {
      buffer.write('&adres=$clientAddress');
    }

    if (clientCity?.isNotEmpty ?? false) {
      buffer.write('&miasto=$clientCity');
    }

    if (clientCode?.isNotEmpty ?? false) {
      buffer.write('&kod=$clientCode');
    }

    if (clientCountry?.isNotEmpty ?? false) {
      buffer.write('&kraj=$clientCountry');
    }

    if (clientPhone?.isNotEmpty ?? false) {
      buffer.write('&telefon=$clientPhone');
    }

    if (acceptTerms?.isNotEmpty ?? false) {
      buffer.write('&akceptuje_regulamin=$acceptTerms');
    }

    return buffer.toString();
  }
}
