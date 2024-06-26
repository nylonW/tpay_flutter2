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
    this.successUrl = 'https://secure.tpay.com/mobile-sdk/success',
    this.errorUrl = 'https://secure.tpay.com/mobile-sdk/error',
    required this.payment,
    this.title,
    this.exitAlertTitle = 'Do you want to cancel payment?',
    this.exitAlertContent =
        'Payment is in progress. Are you sure you want to cancel payment?',
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
  BuildContext? dialogContext;

  final ignoreUrls = [
    // 'https://secure.tpay.com/Confirmation/Realize/transaction',
    'https://secure.tpay.com/Transaction/Bank/return'
  ];

  Future<void> _handleBackNavigation() async {
    final currentUrl = await controller.currentUrl();

    final ignore = ignoreUrls.any(
      (url) => currentUrl?.toLowerCase().startsWith(url.toLowerCase()) ?? false,
    );

    if (ignore) {
      // Do nothing if realizing
    } else if (currentUrl == widget.successUrl) {
      _closeAndReturn(result: TpayResult.success);
    } else if (currentUrl == widget.errorUrl) {
      _closeAndReturn();
    } else {
      final dialogResult = await _showCloseDialog();

      if (dialogResult ?? false) {
        _closeAndReturn(result: TpayResult.backButtonPressed);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..addJavaScriptChannel(
        'Tpay',
        onMessageReceived: (message) {
          print('onMessageReceived: ${message.message}');
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
            print('onPageStarted: $url');
            if (url.toLowerCase() == Constants.tpayBaseUrl.toLowerCase()) {
              _closeAndReturn();
            } else if (url.contains('error.php')) {
              _closeAndReturn(result: TpayResult.sessionClosed);
            }
          },
          onPageFinished: (url) {
            print('onPageFinished: $url');
            print('widget.successUrl: ${widget.successUrl}');
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        await _handleBackNavigation();
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
    final tpayResult = result ?? TpayResult.error;

    Navigator.of(context).pop(tpayResult);
  }

  Future<bool?> _showCloseDialog() async {
    final dialogResults = showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;

        return AlertDialog(
          title: Text(widget.exitAlertTitle),
          content: Text(widget.exitAlertContent),
          actions: [
            TextButton(
              onPressed: () {
                dialogContext = null;
                Navigator.of(context)
                    .pop(true); // Return true to indicate a desire to exit
              },
              child: Text(widget.positiveAlertButtonLabel),
            ),
            TextButton(
              onPressed: () {
                dialogContext = null;
                Navigator.of(context)
                    .pop(false); // Return false to stay on the screen
              },
              child: Text(widget.negativeAlertButtonLabel),
            ),
          ],
        );
      },
    );

    dialogContext = null;

    return dialogResults;
  }
}
