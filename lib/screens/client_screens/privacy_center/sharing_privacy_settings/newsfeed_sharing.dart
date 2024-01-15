import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/sharing&privacy/sharingandprivacy.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class NewsFeedSharing extends StatelessWidget {
  const NewsFeedSharing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'News Feed Sharing'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Automatically update my news feed when:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return checkboxTile(
                  newsSharingOptions[index]['isChecked'],
                  newsSharingOptions[index]['title'],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[700]!,
                );
              },
              itemCount: newsSharingOptions.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget checkboxTile(bool isChecked, String? listTitle) {
    return StatefulBuilder(
      builder: (context, newState) => Theme(
        data: ThemeData(
          unselectedWidgetColor: orange,
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
          activeColor: orange,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
