import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MyTherapiesScreen extends StatelessWidget {
  const MyTherapiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List therapies = [
      'Obesity',
      'Lumbar Spine',
      'Neck Spine',
      'Round Back',
      'Flat Back',
      "Senior's Zone",
      'Upper Limb Diseases',
      'Lower Limb Diseases',
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: const CustomAppBar(
        appBarTitle: 'My Therapies',
         
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: UnlockTherapies(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: therapies.length,
                itemBuilder: (context, index) {
                  return TherapiesButtons(
                    therapy: therapies[index],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
