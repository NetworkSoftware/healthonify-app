import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final Function getValue;
  const NameTextField({Key? key, required this.getValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFff7f3f),
              ),
            ),
            hintText: 'Enter your name',
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  final Function getValue;
  const EmailTextField({Key? key, required this.getValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFff7f3f),
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class ContactField extends StatelessWidget {
  final Function getValue;
  const ContactField({Key? key, required this.getValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFff7f3f),
              ),
            ),
            hintText: 'Enter your contact number',
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final Function getValue;
  const MessageField({Key? key, required this.getValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          maxLines: 5,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFff7f3f),
              ),
            ),
            hintText: 'Describe your enquiry',
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ),
    );
  }
}
