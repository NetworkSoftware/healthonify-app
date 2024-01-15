// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class FirstNameField extends StatefulWidget {
  final Function getValue;
  const FirstNameField({required this.getValue});

  @override
  State<FirstNameField> createState() => _FirstNameFieldState();
}

class _FirstNameFieldState extends State<FirstNameField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'First Name',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
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

class LastNameField extends StatefulWidget {
  final Function getValue;
  const LastNameField({required this.getValue});

  @override
  State<LastNameField> createState() => _LastNameFieldState();
}

class _LastNameFieldState extends State<LastNameField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Last Name',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
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

class PhoneNumberField extends StatefulWidget {
  final Function getValue;
  const PhoneNumberField({required this.getValue});

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your phone number',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your phone number';
          } else if (value.length != 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
      ),
    );
  }
}

class EmailField extends StatefulWidget {
  final Function getValue;
  const EmailField({required this.getValue});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enter your email address',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an email';
          } else if (EmailValidator.validate(value)) {
            return 'Please provide a valid email';
          }
          return null;
        },
      ),
    );
  }
}

class AddressField extends StatefulWidget {
  final Function getValue;
  const AddressField({required this.getValue});

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'This is the address',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your address';
          }
          return null;
        },
      ),
    );
  }
}

class IssueField extends StatefulWidget {
  final Function getValue;
  const IssueField({Key? key, required this.getValue}) : super(key: key);

  @override
  State<IssueField> createState() => _IssueFieldState();
}

class _IssueFieldState extends State<IssueField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: const Color(0xFFC3CAD9),
              ),
            ),
            hintText: 'Describe your issue',
            hintStyle: TextStyle(
              color: Color(0xFF959EAD),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSans',
            ),
          ),
          minLines: 7,
          maxLines: 9,
          onSaved: (value) {
            widget.getValue(value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please explain your issue';
            }
            return null;
          }),
    );
  }
}
