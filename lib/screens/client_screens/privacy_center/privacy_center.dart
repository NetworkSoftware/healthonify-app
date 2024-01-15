import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/contact_support.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/personalisation_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/privacy_policy.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/sharing_privacy_settings/sharing_privacy.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/terms_of_service.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List privacyOptions = [
      {
        'title': 'Terms of Service',
        'route': () {
         // launchUrl(Uri.parse("https://healthonify.com/Terms-condition"));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const TermsOfServiceScreen();
          }));
        },
      },
      {
        'title': 'Privacy Policy',
        'route': () {
         // launchUrl(Uri.parse("https://healthonify.com/Privacy-policy"));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const PrivacyPolicyScreen();
          }));
        },
      },
      {
        'title': 'Personalisation',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const PersonalisationScreen();
          }));
        },
      },
      {
        'title': 'Sharing and Privacy Settings',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SharingAndPrivacySettings();
          }));
        },
      },
      {
        'title': 'Contact Support',
        'route': () {
          launchUrl(Uri.parse("mailto:<support@healthonify.com>"));
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return const ContactSupportScreen();
          // }));
        },
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Privacy Center'),
      body: Column(
        children: [
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: privacyOptions[index]['route'],
                title: Text(
                  privacyOptions[index]['title'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(color: Colors.grey[700]);
            },
            itemCount: privacyOptions.length,
          ),
        ],
      ),
    );
  }
}
