import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/string_constant.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class FacebookSettings extends StatefulWidget {
  const FacebookSettings({Key? key}) : super(key: key);

  @override
  State<FacebookSettings> createState() => _FacebookSettingsState();
}

class _FacebookSettingsState extends State<FacebookSettings> {
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Facebook Settings'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListTile(
              title: Text(
                'Facebook friends can find me on $kAppName',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Switch(
                inactiveTrackColor: Colors.grey[600],
                value: isConnected,
                onChanged: (val) {
                  setState(() {
                    isConnected = !isConnected;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GradientButton(
              title: 'Connect to Facebook',
              func: () {},
              gradient: blueGradient,
            ),
          ),
        ],
      ),
    );
  }
}
