import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String imgUrl;

  const ProfileDetails({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.imgUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFff7f3f),
          radius: 68,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 64,
            child: imgUrl.isEmpty
                ? const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/icons/pfp_placeholder.jpg',
                    ),
                    radius: 60,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      imgUrl,
                    ),
                    radius: 60,
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            userName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            userEmail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
