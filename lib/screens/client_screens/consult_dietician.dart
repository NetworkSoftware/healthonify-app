import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/personal_trainer_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class ConsultDieticianExpert extends StatefulWidget {
  const ConsultDieticianExpert({Key? key}) : super(key: key);

  @override
  State<ConsultDieticianExpert> createState() => _ConsultDieticianExpertState();
}

class _ConsultDieticianExpertState extends State<ConsultDieticianExpert> {
  @override
  Widget build(BuildContext context) {
    String? dropdownValue;
    List dropDownOptions = [
      'Male',
      'Female',
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Consult Certified Diet Experts'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Avail Free Consultation',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Text(
                'Name',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'Name', false),
              Text(
                'Age',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'Age', true),
              Text(
                'Gender',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              StatefulBuilder(
                builder: (context, newState) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items:
                        dropDownOptions.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      newState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    value: dropdownValue,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 56,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    hint: Text(
                      'Gender',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Text(
                'Current Weight',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'Weight', false),
              Text(
                'Height',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'Height', false),
              Text(
                'Any medical condition?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'If yes, please specify.', false),
              Text(
                'Contact Number',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              textFields(context, 'Contact Number', true),
              Text(
                'Preferred time for a call',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'From',
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: const Color(0xFF717579),
                        ),
                    suffixIcon: TextButton(
                      onPressed: () {
                        timePicker(context);
                      },
                      child: const Text('PICK'),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  cursorColor: whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GradientButton(
                  title: 'SUBMIT',
                  func: () {},
                  gradient: orangeGradient,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Nutritionist Panel',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 90,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 0.55,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // log('Yeah bruv you tapped me');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const PersonalTrainer();
                          }));
                        },
                        child: CircleAvatar(
                          radius: 32,
                          child: Image.asset('assets/icons/expert_pfp.png'),
                        ),
                      ),
                      Text(
                        'Trainer Name',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void timePicker(context) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // startTime = value;
        // endTime = value;
      });
    });
  }

  Widget textFields(context, String hintText, bool isAge) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: isAge ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
      ),
    );
  }
}
