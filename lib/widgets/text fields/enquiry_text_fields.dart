import 'package:flutter/material.dart';

class EnquiryName extends StatelessWidget {
  final Function getValue;
  const EnquiryName({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Your name',
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
    );
  }
}

class EnquiryEmail extends StatelessWidget {
  final Function getValue;
  const EnquiryEmail({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Your email',
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
    );
  }
}

class EnquiryContact extends StatelessWidget {
  final Function getValue;
  const EnquiryContact({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Your phone number',
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
            return 'Please enter your contact number';
          }
          return null;
        },
      ),
    );
  }
}

class EnquiryMessage extends StatelessWidget {
  final Function getValue;
  const EnquiryMessage({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Please state your enquiry',
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
            return 'Please enter your enquiry';
          }
          return null;
        },
      ),
    );
  }
}

class EnquiryFor extends StatelessWidget {
  final Function getValue;
  const EnquiryFor({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Enquiry for ...',
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
            return 'Please enter the enquiry target';
          }
          return null;
        },
      ),
    );
  }
}

class EnquiryCategory extends StatelessWidget {
  final Function getValue;
  const EnquiryCategory({required this.getValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Category of enquiry',
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
            return 'Please enter the enquiry category';
          }
          return null;
        },
      ),
    );
  }
}
