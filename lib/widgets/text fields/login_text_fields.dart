import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class LoginEmailTextField extends StatelessWidget {
  final Function getEmail;

  const LoginEmailTextField({Key? key, required this.getEmail})
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
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Phone number or Email',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        onSaved: (value) {
          getEmail(value);
        },
        validator: (value) {
          String pattern = r'(^[0-9]{10}$)';
          RegExp regExp = RegExp(pattern);
          // print(regExp.hasMatch(value!));

          if (value!.isEmpty) {
            return 'Please enter your phone number or email id';
          }
          if (!EmailValidator.validate(value)) {
            if (!regExp.hasMatch(value)) {
              return 'Please provide a valid phone number or email';
            } else {
              return null;
            }
          }

          return null;
        },
      ),
    );
  }
}

class LoginPasswordTextField extends StatefulWidget {
  final Function getPassword;

  const LoginPasswordTextField({Key? key, required this.getPassword})
      : super(key: key);

  @override
  State<LoginPasswordTextField> createState() => _LoginPasswordTextFieldState();
}

class _LoginPasswordTextFieldState extends State<LoginPasswordTextField> {
  bool _passVisible = false;

  void toggle() {
    setState(() {
      _passVisible = !_passVisible;
    });
  }

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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
          suffixIcon: IconButton(
            color: orange,
            onPressed: () {
              toggle();
            },
            icon: _passVisible
                ? const Icon(Icons.visibility_outlined)
                : const Icon(Icons.visibility_off_outlined),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        obscureText: !_passVisible,
        onSaved: (value) {
          widget.getPassword(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
