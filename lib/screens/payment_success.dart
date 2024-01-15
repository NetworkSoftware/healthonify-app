import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen(
      {Key? key, required this.onSubmit, required this.title})
      : super(key: key);

  final Function onSubmit;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Image.asset(
            'assets/icons/payment_success.gif',
            height: 230,
          ),
          const Spacer(),
          Center(
            child: Text(
              'Your payment was successful!',
              style: TextStyle(
                fontSize: 22,
                color: Colors.green[400]!,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 60),
            child: TextButton(
              onPressed: () => onSubmit(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: Colors.green[400]!,
                  width: 2,
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[400]!,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
