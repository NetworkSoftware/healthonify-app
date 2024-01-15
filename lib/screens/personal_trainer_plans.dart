import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/personal_trainer_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class PersonalTrainerPlans extends StatelessWidget {
  const PersonalTrainerPlans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Personalised Plans'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Browse Trainer and Buy Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    showPopup(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Click to filter trainer based on services',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF717579),
                  ),
                  fillColor: Theme.of(context).canvasColor,
                  filled: true,
                  hintText: 'Search trainer',
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF717579),
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                cursorColor: whiteColor,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 86,
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
                          log('Yeah bruv you tapped me');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const PersonalTrainer();
                          }));
                        },
                        child: CircleAvatar(
                          radius: 32,
                          // backgroundColor: Colors.blue,
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
            ),
          ],
        ),
      ),
    );
  }

  void showPopup(context) {
    List services = [
      'All',
      'Weight Training',
      'EMS',
      'Special Offers',
      'Yoga & GX',
      'Gym Membership',
      'Massage',
      'Nutrition',
    ];
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Select a Service',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.background,
                            // color: Colors.grey[800],
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      services[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
