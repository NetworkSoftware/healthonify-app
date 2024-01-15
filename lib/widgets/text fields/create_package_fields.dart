import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ExpertPackageTextField extends StatelessWidget {
  final String title, hint;
  final Function getFunc;
  final TextInputType textInputType;
  const ExpertPackageTextField(
      {Key? key,
      required this.getFunc,
      required this.title,
      required this.hint,
      this.textInputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            child: TextFormField(
              keyboardType: textInputType,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Color(0xFFC3CAD9),
                  ),
                ),
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getFunc(value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a package name';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PriceField extends StatelessWidget {
  final Function getPrice;
  const PriceField({Key? key, required this.getPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Package price'),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            child: TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Color(0xFFC3CAD9),
                  ),
                ),
                hintText: 'Enter the package price',
                hintStyle: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getPrice(value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your a price for the package';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PackageDuration extends StatefulWidget {
  final Function getDuration;
  const PackageDuration({Key? key, required this.getDuration})
      : super(key: key);

  @override
  State<PackageDuration> createState() => _PackageDurationState();
}

class _PackageDurationState extends State<PackageDuration> {
  int _currentValue = 4;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: NumberPicker(
        minValue: 1,
        maxValue: 100,
        value: _currentValue,
        onChanged: (value) => setState(() => _currentValue = value),
      ),
    );
  }
}

class SessionField extends StatefulWidget {
  final Function getSessions;
  const SessionField({Key? key, required this.getSessions}) : super(key: key);

  @override
  State<SessionField> createState() => _SessionFieldState();
}

class _SessionFieldState extends State<SessionField> {
  int _currentValue = 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: NumberPicker(
        minValue: 1,
        maxValue: 100,
        value: _currentValue,
        onChanged: (value) => setState(() => _currentValue = value),
      ),
    );
  }
}

class DescField extends StatelessWidget {
  final Function getDesc;
  const DescField({Key? key, required this.getDesc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Package description'),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Color(0xFFC3CAD9),
                  ),
                ),
                hintText: 'Enter a package description',
                hintStyle: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getDesc(value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BenefitsField extends StatelessWidget {
  final Function getBenefits;
  const BenefitsField({Key? key, required this.getBenefits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Package benefits'),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Color(0xFFC3CAD9),
                  ),
                ),
                hintText: 'Enter package benefits',
                hintStyle: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getBenefits(value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the package benefits';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
