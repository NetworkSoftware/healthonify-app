import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewSocialHabits extends StatefulWidget {
  final String? userID;
  const ViewSocialHabits({super.key, this.userID});

  @override
  State<ViewSocialHabits> createState() => _ViewSocialHabitsState();
}

class _ViewSocialHabitsState extends State<ViewSocialHabits> {
  List<SocialHabitsModel> socialHabits = [];

  late String? userId;

  bool isLoading = true;

  Future<void> fetchsocialHabits() async {
    try {
      socialHabits =
          await Provider.of<MedicalHistoryProvider>(context, listen: false)
              .getSocialHabits(userId!);

      log('fetched social habits');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching social habits');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userID ??
        Provider.of<UserData>(context, listen: false).userData.id;

    fetchsocialHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Logs'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : socialHabits.isEmpty
          ? const Center(
        child: Text('No Logs Available'),
      )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: socialHabits.length,
                    itemBuilder: (context, index) {
                      return socialHabitsCard(index);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget socialHabitsCard(int listIndex) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(socialHabits[listIndex].socialHabit!,
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      socialHabits[listIndex].frequency!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      socialHabits[listIndex].havingFrom!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              socialHabits[listIndex].comments == null
                  ? const SizedBox()
                  : Text(
                      socialHabits[listIndex].comments!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey[400]),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
