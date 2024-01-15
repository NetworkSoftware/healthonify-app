import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/sharing&privacy/sharingandprivacy.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/sharing_privacy_settings/autoplay_settings.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/sharing_privacy_settings/email_settings.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/sharing_privacy_settings/facebook_settings.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/sharing_privacy_settings/newsfeed_sharing.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class SharingAndPrivacySettings extends StatelessWidget {
  const SharingAndPrivacySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    List sharingPrivacyOptions = [
      {
        'title': 'News Feed Sharing',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewsFeedSharing();
          }));
        },
      },
      {
        'title': 'Email Settings',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const EmailSettings();
          }));
        },
      },
      {
        'title': 'Facebook Settings',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const FacebookSettings();
          }));
        },
      },
      {
        'title': 'Autoplay Settings',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AutoplaySettings();
          }));
        },
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Sharing and Privacy Settings'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: Text(
              'Diary Sharing',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: StatefulBuilder(
                builder: (context, newState) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: diarySharingOptions
                        .map<DropdownMenuItem<String>>((value) {
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
                        selectedValue = newValue!;
                      });
                    },
                    value: selectedValue,
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
                      'Choose an option',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[700]!,
          ),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: sharingPrivacyOptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: sharingPrivacyOptions[index]['route'],
                title: Text(
                  sharingPrivacyOptions[index]['title'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[700]!,
              );
            },
          ),
        ],
      ),
    );
  }
}
