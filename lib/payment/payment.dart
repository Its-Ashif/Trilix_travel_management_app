import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

final _razorpay = Razorpay();

class PaymentGateway extends StatefulWidget {
  String placeName;
  int total;
  PaymentGateway({super.key, required this.placeName, required this.total});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': 'rzp_test_l8klnmbJhuFzRM',
      'amount': widget.total,
      'name': 'Trilix',
      'description': '${widget.placeName} Trip',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com',
      }
    };
    _razorpay.open(options);
    print("after Razorpay");
    return Container();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'Payment Success: ${response.paymentId} ${response.orderId} ${response.signature}');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Success"),
              content: SmallText(
                  text:
                      'Payment Success: ${response.paymentId} ${response.orderId} ${response.signature}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Error"),
              content: SmallText(
                  text:
                      'Payment Error: ${response.code} - ${response.message}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Error"),
              content:
                  SmallText(text: 'External Wallet: ${response.walletName}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
  }
}
