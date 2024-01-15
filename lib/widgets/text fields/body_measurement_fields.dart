import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class BmMeasurementField extends StatelessWidget {
  final Function getMeasurement;
  final String label;
  final String validatorVal;
  const BmMeasurementField({
    required this.getMeasurement,
    required this.label,
    required this.validatorVal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.teal,
            ),
          ),
          fillColor: grey,
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onChanged: (value) {
          getMeasurement(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $validatorVal measurement';
          }
          if (value.length >= 3) {
            return 'Please provide a valid $validatorVal measurement';
          }
          return null;
        },
      ),
    );
  }
}
