import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/string_constant.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AutoplaySettings extends StatefulWidget {
  const AutoplaySettings({Key? key}) : super(key: key);

  @override
  State<AutoplaySettings> createState() => _AutoplaySettingsState();
}

class _AutoplaySettingsState extends State<AutoplaySettings> {
  bool isAutoPlay = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Auto-Play Settings'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListTile(
              title: Text(
                'Autoplay $kAppName Blog Videos',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Switch(
                inactiveTrackColor: Colors.grey[600],
                value: isAutoPlay,
                onChanged: (val) {
                  setState(() {
                    isAutoPlay = !isAutoPlay;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
