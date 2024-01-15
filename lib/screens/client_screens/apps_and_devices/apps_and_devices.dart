import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MyAppsAndDevices extends StatelessWidget {
  const MyAppsAndDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Apps and Devices'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Connected Apps and Devices',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ListTile(
            tileColor: darkGrey,
            leading: Image.asset(
              'assets/icons/googleFit_icon.png',
              height: 50,
              width: 50,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Google Fit',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect Google Fit to Healthonify to track your nutrition data and activity data.',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                  side: const BorderSide(
                    color: orange,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('Connect'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
