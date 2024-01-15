import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewFamilyHistoryLogs extends StatefulWidget {
  final String? userID;
  const ViewFamilyHistoryLogs({super.key, this.userID});

  @override
  State<ViewFamilyHistoryLogs> createState() => _ViewFamilyHistoryLogsState();
}

class _ViewFamilyHistoryLogsState extends State<ViewFamilyHistoryLogs> {
  List<FamilyHistoryModel> familyHistoryLogs = [];

  late String? userId;

  bool isLoading = true;

  Future<void> fetchFamilyHistoryLogs() async {
    try {
      familyHistoryLogs =
          await Provider.of<MedicalHistoryProvider>(context, listen: false)
              .getFamilyHistory(userId!);

      log('fetched family history logs');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
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

    fetchFamilyHistoryLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Logs'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : familyHistoryLogs.isEmpty
          ? const Center(
        child: Text('No Logs Available'),
      )
          :  SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: familyHistoryLogs.length,
                    itemBuilder: (context, index) {
                      return familyHistoryLogCard(index);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget familyHistoryLogCard(int listIndex) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(familyHistoryLogs[listIndex].condition!,
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      familyHistoryLogs[listIndex].relation!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      familyHistoryLogs[listIndex].sinceWhen!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              familyHistoryLogs[listIndex].comments == null
                  ? const SizedBox()
                  : Text(
                      familyHistoryLogs[listIndex].comments!,
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
