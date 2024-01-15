import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/allergic_history/allergic_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/allergic_history/view_allergic_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/family_history/family_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/major_illness/major_illness.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/major_illness/view_major_illness.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/social_habits/social_habits.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/social_habits/view_social_habits.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/surgical_history/surgical_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/family_history/view_family_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_history/surgical_history/view_surgical_history.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String? userId;

  const MedicalHistoryScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Medical History'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Text(
          //     'My Medical History',
          //     style: Theme.of(context).textTheme.labelLarge,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Allergic History',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllergicHistoryScreen(
                          userId: widget.userId,
                        );
                      }));
                    },
                    child: Text(
                      'Add New',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewAllergicHistoryLogs(userId: widget.userId);
                  }));
                },
                child: Text(
                  'View logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: orange),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Family History',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FamilyHistoryScreen(
                          userID: widget.userId,
                        );
                      }));
                    },
                    child: Text(
                      'Add New',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewFamilyHistoryLogs(
                      userID: widget.userId,
                    );
                  }));
                },
                child: Text(
                  'View logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: orange),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Major Illness History',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MajorIllnessScreen(
                          userID: widget.userId,
                        );
                      }));
                    },
                    child: Text(
                      'Add New',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewMajorIllnessLogs(
                      userID: widget.userId,
                    );
                  }));
                },
                child: Text(
                  'View logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: orange),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Social Habits',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SocialHabitsScreen(userID: widget.userId);
                      }));
                    },
                    child: Text(
                      'Add New',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewSocialHabits(
                      userID: widget.userId,
                    );
                  }));
                },
                child: Text(
                  'View logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: orange),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Surgical History',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SurgicalHistoryScreen(
                          userId: widget.userId,
                        );
                      }));
                    },
                    child: Text(
                      'Add New',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ) : const SizedBox(),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewSurgicalHistoryLogs(
                      userId: widget.userId,
                    );
                  }));
                },
                child: Text(
                  'View logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: orange),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
