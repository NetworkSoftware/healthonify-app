import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewAllergicHistoryLogs extends StatefulWidget {
  final String? userId;

  const ViewAllergicHistoryLogs({super.key, this.userId});

  @override
  State<ViewAllergicHistoryLogs> createState() =>
      _ViewAllergicHistoryLogsState();
}

class _ViewAllergicHistoryLogsState extends State<ViewAllergicHistoryLogs> {
  List<AllergicHistoryModel> allergicHistoryLogs = [];

  late String? userId;

  bool isLoading = true;

  Future<void> fetchallergicHistoryLogs() async {
    try {
      allergicHistoryLogs =
          await Provider.of<MedicalHistoryProvider>(context, listen: false)
              .getAllergicHistory(userId!);

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

  @override
  void initState() {
    super.initState();
    userId = widget.userId ?? Provider.of<UserData>(context, listen: false).userData.id;

    fetchallergicHistoryLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Logs'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allergicHistoryLogs.isEmpty
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
                        itemCount: allergicHistoryLogs.length,
                        itemBuilder: (context, index) {
                          return allergicHistoryLogCard(index);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget allergicHistoryLogCard(int listIndex) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(allergicHistoryLogs[listIndex].name!,
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      allergicHistoryLogs[listIndex].type!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      allergicHistoryLogs[listIndex].sinceFrom ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                allergicHistoryLogs[listIndex].description!,
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
