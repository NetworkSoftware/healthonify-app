import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CreateDiet extends StatelessWidget {
  const CreateDiet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Create your diet',
      ),
      body: Column(
        children: [
          dietName(),
          durationField(),
          const RadioDietPlans(),
        ],
      ),
      persistentFooterButtons: [
        Container(
          decoration: BoxDecoration(
            gradient: orangeGradient,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MealPlansScreen();
              }));
            },
            child: Center(
              child: Text(
                'SUBMIT',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dietName() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Diet Plan Name',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget durationField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Duration in days',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field can\'t be empty';
          }
          return null;
        },
      ),
    );
  }
}

class RadioDietPlans extends StatefulWidget {
  const RadioDietPlans({Key? key}) : super(key: key);

  @override
  State<RadioDietPlans> createState() => _RadioDietPlansState();
}

enum SingingCharacter { first, second }

class _RadioDietPlansState extends State<RadioDietPlans> {
  SingingCharacter? _character = SingingCharacter.first;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<SingingCharacter>(
          title: Text(
            'Regular diet plan (Same diet plan as everyday)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: SingingCharacter.first,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        const SizedBox(height: 14),
        RadioListTile<SingingCharacter>(
          title: Text(
            'Weekly diet plan (Add different meals everday for the whole week)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: SingingCharacter.second,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ],
    );
  }
}
