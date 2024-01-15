import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewMajorIllnessLogs extends StatefulWidget {
  final String? userID;
  const ViewMajorIllnessLogs({super.key, this.userID});

  @override
  State<ViewMajorIllnessLogs> createState() => _ViewMajorIllnessLogsState();
}

class _ViewMajorIllnessLogsState extends State<ViewMajorIllnessLogs> {
  List<MajorIllnessModel> majorIllnessLogs = [];

  late String? userId;

  bool isLoading = true;

  Future<void> fetchFamilyHistoryLogs() async {
    try {
      majorIllnessLogs =
          await Provider.of<MedicalHistoryProvider>(context, listen: false)
              .getMajorIllnessHistory(userId!);

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
          : majorIllnessLogs.isEmpty
          ? const Center(
        child: Text('No Logs Available'),
      )
          :SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: majorIllnessLogs.length,
                    itemBuilder: (context, index) {
                      // return const Card(
                      //   child: Text('data'),
                      // );
                      return majorIllnessLogCard(index);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget majorIllnessLogCard(int listIndex) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(majorIllnessLogs[listIndex].condition!,
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      majorIllnessLogs[listIndex].condition!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      majorIllnessLogs[listIndex].sinceWhen!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    Text(
                      'on medication :',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      majorIllnessLogs[listIndex].onMedication == true
                          ? 'Yes'
                          : 'No',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              majorIllnessLogs[listIndex].comments == null
                  ? const SizedBox()
                  : Text(
                      majorIllnessLogs[listIndex].comments!,
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
