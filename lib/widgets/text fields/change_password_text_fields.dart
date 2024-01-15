// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class NewPasswordTextField extends StatefulWidget {
  final Function getValue;
  const NewPasswordTextField({Key? key, required this.getValue})
      : super(key: key);

  @override
  State<NewPasswordTextField> createState() => _NewPasswordTextFieldState();
}

class _NewPasswordTextFieldState extends State<NewPasswordTextField> {
  bool _passVisible = false;

  void toggle() {
    setState(() {
      _passVisible = !_passVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your old password',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
          suffixIcon: IconButton(
            onPressed: () {
              toggle();
            },
            icon: _passVisible
                ? Icon(Icons.visibility_outlined)
                : Icon(Icons.visibility_off_outlined),
          ),
        ),
        obscureText: !_passVisible,
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field can\'t be empty';
          }
          if (value.length < 8 || value.length > 15) {
            return 'Password should be 6 to 15 characters';
          }
          String pattern = r'(^[a-zA-Z0-9]+$)';
          RegExp regExp = RegExp(pattern);
          if (!regExp.hasMatch(value)) {
            return 'Password can only by alphabets and numbers';
          }
          return null;
        },
      ),
    );
  }
}

class ConfirmPasswordTextField extends StatefulWidget {
  final Function getValue;
  const ConfirmPasswordTextField({Key? key, required this.getValue})
      : super(key: key);

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  bool _passVisible = false;

  void toggle() {
    setState(() {
      _passVisible = !_passVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your new password',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
          suffixIcon: IconButton(
            color: orange,
            splashRadius: 10,
            onPressed: () {
              toggle();
            },
            icon: _passVisible
                ? Icon(Icons.visibility_outlined)
                : Icon(Icons.visibility_off_outlined),
          ),
        ),
        obscureText: !_passVisible,
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field can\'t be empty';
          }
          if (value.length < 6 || value.length > 15) {
            return 'Password should be 6 to 15 characters';
          }
          String pattern = r'(^[a-zA-Z0-9]+$)';
          RegExp regExp = RegExp(pattern);
          if (!regExp.hasMatch(value)) {
            return 'Password can only by alphabets and numbers';
          }
          return null;
        },
      ),
    );
  }
}
