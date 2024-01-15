import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class SignupFirstNameTextField extends StatelessWidget {
  final Function getValue;
  const SignupFirstNameTextField({Key? key, required this.getValue})
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
        textCapitalization: TextCapitalization.words,
        decoration:  InputDecoration(
         // border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your first name',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          getValue(value);
        },
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your first name';
          }
          return null;
        },
      ),
    );
  }
}

class SignupLastNameTextField extends StatelessWidget {
  final Function getValue;
  const SignupLastNameTextField({Key? key, required this.getValue})
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
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          //border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your last name',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          getValue(value);
        },
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        },
      ),
    );
  }
}

class SignupEmailTextField extends StatelessWidget {
  final Function getValue;
  const SignupEmailTextField({Key? key, required this.getValue})
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
        decoration:  InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your email',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          getValue(value);
        },
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email id';
          }
          if (!EmailValidator.validate(value)) {
            return 'Please provide a valid email id';
          }
          return null;
        },
      ),
    );
  }
}

class SignupMobileTextField extends StatelessWidget {
  final Function getValue;
  const SignupMobileTextField({Key? key, required this.getValue})
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your mobile number',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        onSaved: (value) {
          getValue(value);
        },
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

class SignupPasswordTextField extends StatefulWidget {
  final Function getValue;
  const SignupPasswordTextField({Key? key, required this.getValue})
      : super(key: key);

  @override
  State<SignupPasswordTextField> createState() =>
      _SignupPasswordTextFieldState();
}

class _SignupPasswordTextFieldState extends State<SignupPasswordTextField> {
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
          hintText: 'Enter password',
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
        obscureText: !_passVisible,
        onSaved: (value) {
          widget.getValue(value);
        },
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password';
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
