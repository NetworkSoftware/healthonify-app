import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/learn_more.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/privacy_policy.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/terms_of_service.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class PersonalisationScreen extends StatefulWidget {
  const PersonalisationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalisationScreen> createState() => _PersonalisationScreenState();
}

class _PersonalisationScreenState extends State<PersonalisationScreen> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Personalisation'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Your consent allows Healthonify to provide you personalized experiences, you may opt in to any of the features below and edit your choices at any time. Providing your consent lets us deliver unique offers and incentives.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 10),
            checkboxTiles(
              context,
              isChecked1,
              () {
                setState(() {
                  isChecked1 = !isChecked1;
                });
              },
              'Relevant & Useful Advertising',
              'Personalise my advertising experience and show me advertising that may be relevant, useful and interesting to me.',
            ),
            checkboxTiles(
              context,
              isChecked2,
              () {
                setState(() {
                  isChecked2 = !isChecked2;
                });
              },
              'Precise Location-Based Content',
              'Use my precise location to present me offers, deals or features related to products and services located nearby that may be interesting to me.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: darkGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PrivacyPolicyScreen();
                    }));
                  },
                  child: const Text('Privacy Policy'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'and',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const TermsOfServiceScreen();
                    }));
                  },
                  child: const Text('Terms'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: GradientButton(
                title: 'Accept All',
                func: () {
                  setState(() {
                    isChecked1 = true;
                    isChecked2 = true;
                  });
                },
                gradient: orangeGradient,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Remind me later'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget checkboxTiles(
      context, bool check, Function ontap, String title, String descp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Checkbox(
          activeColor: orange,
          side: const BorderSide(
            color: orange,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          value: check,
          onChanged: (val) {
            ontap();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              descp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LearnMoreScreen();
                }));
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}
