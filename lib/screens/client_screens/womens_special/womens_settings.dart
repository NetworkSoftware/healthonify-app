import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/womens_special/cycle_length.dart';
import 'package:healthonify_mobile/screens/client_screens/womens_special/ovulation_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/womens_special/women_profile.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class WomensSettings extends StatelessWidget {
  const WomensSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Women Care'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            settingsCard('Cycle and Period Length', 'assets/icons/flow.png',
                () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CycleLengthScreen();
              }));
            }),
            const SizedBox(height: 10),
            settingsCard(
              'Ovulation and Fertility',
              'assets/icons/ovulation.png',
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OvulationScreen();
                }));
              },
            ),
            const SizedBox(height: 10),
            settingsCard(
              'Profile',
              'assets/icons/profile.png',
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WomensProfile();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsCard(
    String title,
    String icon,
    Function navTo,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: InkWell(
          onTap: () {
            navTo();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 36,
                  width: 36,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
