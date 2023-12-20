import 'package:flutter/material.dart';
import 'package:tpay_flutter2/src/constants.dart';
import 'package:tpay_flutter2/src/result.dart';
import 'package:tpay_flutter2/src/tpay_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Tpay screen used for payments.
class TpayScreen extends StatefulWidget {
  /// Creates Tpay screen used for payments.
  const TpayScreen({
    Key? key,
    this.successUrl = 'about:blank?status=success',
    this.errorUrl = 'about:blank?status=error',
    required this.payment,
    this.title,
  }) : super(key: key);

  /// Url used to determine when to pop if payment succeed.
  final String successUrl;

  /// Url used to determine when to pop if payment failed.
  final String errorUrl;

  /// Payment to be made.
  final TpayPayment payment;

  /// Payment screen title widget.
  final Widget? title;

  @override
  State<TpayScreen> createState() => _TpayScreenState();
}

class _TpayScreenState extends State<TpayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closeAndReturn(result: TpayResult.backButtonPressed);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.title,
        ),
        body: WebView(
          initialUrl: widget.payment.paymentLink,
          onPageStarted: (url) {
            if (url.toLowerCase() == Constants.tpayBaseUrl.toLowerCase()) {
              _closeAndReturn();
            } else if (url.contains('error.php')) {
              _closeAndReturn(result: TpayResult.sessionClosed);
            }
          },
          onPageFinished: (url) {
            if (url.toLowerCase() == Constants.tpayBaseUrl.toLowerCase()) {
              _closeAndReturn();
            } else if (url.contains('error.php')) {
              _closeAndReturn(result: TpayResult.sessionClosed);
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            if (request.url.toLowerCase() ==
                Constants.tpayBaseUrl.toLowerCase()) {
              _closeAndReturn();
            } else if (request.url.contains('error.php')) {
              _closeAndReturn(result: TpayResult.sessionClosed);
            }

            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  void _closeAndReturn({TpayResult? result}) {
    final tpayResult = result ?? TpayResult.error;

    Navigator.of(context).pop(tpayResult);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
