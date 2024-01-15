import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/expert_screens/select_client.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/drop_downs/add_appoinment_dropdowns.dart';
import 'package:healthonify_mobile/widgets/text%20fields/appointment_start_end_fields.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Add Appointment',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AddAppointmentDropDown(
                dropDownHint: 'Select Purpose',
                // ignore: prefer_const_literals_to_create_immutables
                dropDownList: [
                  'Select purpose 1',
                  'Select purpose 2',
                  'Select purpose 3',
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 26),
              child: AddAppointmentDropDown(
                dropDownHint: 'Open',
                // ignore: prefer_const_literals_to_create_immutables
                dropDownList: [
                  'Open',
                  'Close',
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'To Do Task (Optional)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AddAppointmentDropDown(
                dropDownHint: 'To Do Task (Optional)',
                // ignore: prefer_const_literals_to_create_immutables
                dropDownList: [
                  'Option 1',
                  'Option 2',
                  'Option 3',
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Appointment Date',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AddAppointmentDropDown(
                dropDownHint: 'Appointment Date',
                // ignore: prefer_const_literals_to_create_immutables
                dropDownList: [
                  'Today',
                  'Tomorrow',
                  'This week',
                  'Next week',
                  'This month',
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Timings',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StartTime(),
                    Text(
                      'to',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    EndTime(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.92,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFAAAAAA),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SelectClientScreen();
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person_add_alt,
                          color: Color(0xFFff7f3f),
                          size: 32,
                        ),
                        label: Text(
                          'Add Client',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubmitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
