import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AddFriendsScreen extends StatelessWidget {
  const AddFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Friends'),
      body: Column(
        children: [
          const SizedBox(height: 20),
          tiles(
            context,
            const Icon(
              Icons.contacts_outlined,
              color: orange,
              size: 30,
            ),
            'Contacts',
            'Find friends from my phone contacts',
            () {},
          ),
          const SizedBox(height: 10),
          tiles(
            context,
            const Icon(
              Icons.alternate_email_rounded,
              color: orange,
              size: 30,
            ),
            'Email',
            'Invite friends using their email address or Healthonify username',
            () {},
          ),
        ],
      ),
    );
  }

  Widget tiles(context, Icon icon, String title, String descp, Function ontap) {
    return ListTile(
      onTap: () {
        ontap();
      },
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            descp,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
