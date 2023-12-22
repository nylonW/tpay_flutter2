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
    this.exitAlertTitle = 'Exit payment screen?',
    this.exitAlertContent =
        'Are you sure you want to exit payment screen? If you already made a payment, it will be processed.',
    this.positiveAlertButtonLabel = 'Yes',
    this.negativeAlertButtonLabel = 'No',
  });

  /// Url used to determine when to pop if payment succeed.
  final String successUrl;

  /// Url used to determine when to pop if payment failed.
  final String errorUrl;

  /// Payment to be made.
  final TpayPayment payment;

  /// Payment screen title widget.
  final Widget? title;

  /// Exit alert title text.
  /// Defaults to 'Exit payment screen?'.
  final String exitAlertTitle;

  /// Exit alert content text.
  /// Defaults to 'Are you sure you want to exit payment screen?'.
  final String exitAlertContent;

  /// Exit alert positive button text.
  /// Defaults to 'Yes'.
  final String positiveAlertButtonLabel;

  /// Exit alert negative button text.
  /// Defaults to 'No'.
  final String negativeAlertButtonLabel;

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
          onProgress: (progress) {
            print(progress);
          },
          onPageStarted: (url) {
            print(url);
            if (url.toLowerCase() == Constants.tpayBaseUrl.toLowerCase()) {
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

  Future<void> _showCloseDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(widget.exitAlertTitle),
          content: Text(widget.exitAlertContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(widget.positiveAlertButtonLabel),
            ),
            TextButton(
              onPressed: () =>
                  _closeAndReturn(result: TpayResult.backButtonPressed),
              child: Text(widget.negativeAlertButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showCloseDialog(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.title,
        ),
        body: WebViewWidget(controller: controller),
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
