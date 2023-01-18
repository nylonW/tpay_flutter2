import 'package:flutter/material.dart';
import 'package:tpay_flutter2/src/constants.dart';
import 'package:tpay_flutter2/src/result.dart';
import 'package:tpay_flutter2/src/tpay_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Tpay screen used for payments.
class TpayScreen extends StatefulWidget {
  /// Creates Tpay screen used for payments.
  const TpayScreen({
    super.key,
    this.successUrl = 'about:blank?status=success',
    this.errorUrl = 'about:blank?status=error',
    required this.payment,
    this.title,
  });

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
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..addJavaScriptChannel(
        'Tpay',
        onMessageReceived: (message) {
          if (message.message == 'onPaymentSuccess') {
            _closeAndReturn(result: TpayResult.success);
          } else if (message.message == 'onPaymentFail') {
            _closeAndReturn();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            if (url.toLowerCase() ==
                Constants.TPAY_MAIN_PAGE_URL.toLowerCase()) {
              _closeAndReturn();
            } else if (url.contains('error.php')) {
              _closeAndReturn(result: TpayResult.sessionClosed);
            }
          },
          onPageFinished: (url) {
            if (url.toLowerCase().startsWith(widget.successUrl.toLowerCase())) {
              _closeAndReturn(result: TpayResult.success);
            } else if (url
                .toLowerCase()
                .startsWith(widget.errorUrl.toLowerCase())) {
              _closeAndReturn();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.payment.paymentLink ?? ''));
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
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  void _closeAndReturn({TpayResult? result}) {
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
