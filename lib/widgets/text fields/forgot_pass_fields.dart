import 'dart:async';
import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

import 'package:healthonify_mobile/providers/forgot_psswd.dart';
import 'package:provider/provider.dart';

class ForgotPassEmail extends StatelessWidget {
  final Function getEmail;
  const ForgotPassEmail({Key? key, required this.getEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      height: 50,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5),
            //   borderSide: const BorderSide(
            //     color: Color(0xFFff7f3f),
            //   ),
            // ),
            hintText: 'Enter your email id',
            hintStyle: TextStyle(
              color: Color(0xFF959EAD),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSans',
            ),
          ),
          onSaved: (value) {
            getEmail(value);
          },
          style: Theme.of(context).textTheme.bodyMedium,
          validator: (value) {
            // String pattern = r'(^[0-9]{10}$)';
            // RegExp regExp = RegExp(pattern);

            if (value!.isEmpty) {
              return 'Please enter your email id';
            }
            if (!EmailValidator.validate(value)) {
              return 'Please provide a valid email id';
            }
            return null;
          }),
    );
  }
}

class ForgotPassMobileNo extends StatelessWidget {
  final Function getValue;
  const ForgotPassMobileNo({Key? key, required this.getValue})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      height: 50,
      child: TextFormField(
        decoration: const InputDecoration(
          border: InputBorder.none,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(5),
          //   borderSide: const BorderSide(
          //     color: Color(0xFFC3CAD9),
          //   ),
          // ),
          hintText: 'Enter your mobile number',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          getValue(value);
        },
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your mobile number';
          }
          String pattern = r'(^[0-9]{10}$)';
          RegExp regExp = RegExp(pattern);
          if (!regExp.hasMatch(value)) {
            return 'Please provide a valid phone number';
          }
          return null;
        },
      ),
    );
  }
}

class SendOtpButton extends StatelessWidget {
  final Function submit;
  final bool isLoading;
  const SendOtpButton({required this.submit, required this.isLoading, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ElevatedButton(
            onPressed: () {
              submit(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Send OTP',
              ),
            ),
          );
  }
}

// class UpdatePasswordOtp extends StatefulWidget {
//   final Function getValue;
//   final String mobileNo;
//   final Function timerFunc;
//   const UpdatePasswordOtp({
//     Key? key,
//     required this.getValue,
//     required this.mobileNo,
//     required this.timerFunc,
//   }) : super(key: key);

//   @override
//   State<UpdatePasswordOtp> createState() => _UpdatePasswordOtpState();
// }

// class _UpdatePasswordOtpState extends State<UpdatePasswordOtp> {
//   bool isEnabled = true;

//   void onSendOtp() async {
//     try {
//       await Provider.of<ForgotPasswordProvider>(context, listen: false)
//           .forgotPassword(widget.mobileNo);
//     } catch (e) {
//       log(e.toString());
//       Fluttertoast.showToast(msg: 'Error sending OTP');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.85,
//       child: TextFormField(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(
//               color: Color(0xFFC3CAD9),
//             ),
//           ),
//           suffixIcon: TextButton(
//             onPressed: isEnabled
//                 ? () {
//                     widget.timerFunc();
//                     onSendOtp();
//                     isEnabled = false;
//                   }
//                 : null,
//             child: Text(
//               "Send OTP",
// //               style: isEnabled ? Theme.of(context)
//                               .textTheme
//                               .labelSmall!
//                               .copyWith(
//                                 color: Theme.of(context).colorScheme.secondary
//                               ), : Theme.of(context).textTheme.bodySmall,
//             ),
//             style: TextButton.styleFrom(),
//           ),
//           hintText: 'Enter the 4 digit OTP',
//           hintStyle: const TextStyle(
//             color: Color(0xFF959EAD),
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//         onSaved: (value) {
//           widget.getValue(value);
//         },
//         keyboardType: TextInputType.phone,
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'Please enter the OTP';
//           }
//           String pattern = r'(^[0-9]{4}$)';
//           RegExp regExp = RegExp(pattern);
//           if (!regExp.hasMatch(value)) {
//             return 'Please provide a valid OTP';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }

class UpdatePassOtpField extends StatefulWidget {
  final Function getValue;
  final String mobileNo;
  const UpdatePassOtpField({
    Key? key,
    required this.getValue,
    required this.mobileNo,
  }) : super(key: key);

  @override
  State<UpdatePassOtpField> createState() => _UpdatePassOtpFieldState();
}

class _UpdatePassOtpFieldState extends State<UpdatePassOtpField> {
  bool isEnabled = true;
  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 30;
            isEnabled = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void onSendOtp() async {
    try {
      await Provider.of<ForgotPasswordProvider>(context, listen: false)
          .forgotPassword(widget.mobileNo);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Error sending OTP');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Color(0xFFC3CAD9),
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: isEnabled
                      ? () {
                          startTimer();
                          onSendOtp();
                          isEnabled = false;
                        }
                      : null,
                  child: Text(
                    "Send OTP",
                    style: isEnabled
                        ? Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: orange,
                            )
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              hintText: 'Enter the 4 digit OTP',
              hintStyle: const TextStyle(
                color: Color(0xFF959EAD),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
              ),
            ),
            onSaved: (value) {
              widget.getValue(value);
            },
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the OTP';
              }
              String pattern = r'(^[0-9]{4}$)';
              RegExp regExp = RegExp(pattern);
              if (!regExp.hasMatch(value)) {
                return 'Please provide a valid OTP';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          if (!isEnabled) Text('Resend OTP in $_start seconds'),
        ],
      ),
    );
  }
}
