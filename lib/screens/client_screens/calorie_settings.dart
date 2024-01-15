import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CalorieSettings extends StatelessWidget {
  const CalorieSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Settings'),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            checkboxTile(false, 'Last 7 days'),
            checkboxTile(false, 'Monday'),
            checkboxTile(false, 'Tuesday'),
            checkboxTile(false, 'Wednesday'),
            checkboxTile(false, 'Thursday'),
            checkboxTile(false, 'Friday'),
            checkboxTile(false, 'Saturday'),
            checkboxTile(false, 'Sunday'),
          ],
        ),
      ),
    );
  }

  Widget checkboxTile(bool isChecked, String? listTitle) {
    return StatefulBuilder(
      builder: (context, newState) => Theme(
        data: ThemeData(
          unselectedWidgetColor: whiteColor,
        ),
        child: CheckboxListTile(
          value: isChecked,
          title: Text(
            listTitle!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChanged: (isTapped) {
            newState(
              () {
                isChecked = !isChecked;
              },
            );
          },
          activeColor: const Color(0xFFff7f3f),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
