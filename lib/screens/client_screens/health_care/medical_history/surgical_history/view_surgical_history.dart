import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewSurgicalHistoryLogs extends StatefulWidget {
  final String? userId;

  const ViewSurgicalHistoryLogs({super.key, this.userId});

  @override
  State<ViewSurgicalHistoryLogs> createState() =>
      _ViewSurgicalHistoryLogsState();
}

class _ViewSurgicalHistoryLogsState extends State<ViewSurgicalHistoryLogs> {
  List<SurgicalHistoryModel> surgicalHistoryLogs = [];

  late String? userId;

  bool isLoading = true;

  Future<void> fetchSurgicalHistoryLogs() async {
    try {
      surgicalHistoryLogs =
          await Provider.of<MedicalHistoryProvider>(context, listen: false)
              .getSurgicalHistory(userId!);

      log('fetched allergic history logs');
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

  String? surgeryDate;

  @override
  void initState() {
    super.initState();
    userId = widget.userId ??
        Provider.of<UserData>(context, listen: false).userData.id;

    fetchSurgicalHistoryLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Logs'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : surgicalHistoryLogs.isEmpty
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
                        itemCount: surgicalHistoryLogs.length,
                        itemBuilder: (context, index) {
                          var tempDate = DateFormat('yyyy-MM-dd')
                              .parse(surgicalHistoryLogs[index].date!);

                          surgeryDate =
                              DateFormat('d MMM yyyy').format(tempDate);

                          return surgicalHistoryLogCard(index);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget surgicalHistoryLogCard(int listIndex) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(surgicalHistoryLogs[listIndex].name!,
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      surgicalHistoryLogs[listIndex].hospitalNameOrDoctorName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      surgeryDate!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              surgicalHistoryLogs[listIndex].comments == null
                  ? const SizedBox()
                  : Text(
                      surgicalHistoryLogs[listIndex].comments!,
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
