import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/sharing&privacy/sharingandprivacy.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';

class EmailSettings extends StatelessWidget {
  const EmailSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User data = Provider.of<UserData>(context).userData;
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Email Settings'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                data.email!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.blue[400]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'A confirmation mail was sent to the address above. Please check your inbox.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GradientButton(
                    title: 'Resend confirmation',
                    func: () {},
                    gradient: blueGradient,
                  ),
                  GradientButton(
                    title: 'Update Email',
                    func: () {},
                    gradient: blueGradient,
                  ),
                ],
              ),
            ),
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return checkboxTile(
                  emailOptions1[index]['isChecked'],
                  emailOptions1[index]['title'],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[700]!,
                );
              },
              itemCount: emailOptions1.length,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Send me an email when:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return checkboxTile(
                  emailOptions2[index]['isChecked'],
                  emailOptions2[index]['title'],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[700]!,
                );
              },
              itemCount: emailOptions2.length,
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
