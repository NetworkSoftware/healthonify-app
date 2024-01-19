import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts_data.dart';
import 'package:healthonify_mobile/widgets/cards/available_experts_card.dart';
import 'package:healthonify_mobile/widgets/physio/physio_bottomsheet_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class ExpertsList extends StatelessWidget {
  static const routeName = "/expert-list";

  const ExpertsList({Key? key}) : super(key: key);

  Future<void> getExpertise(BuildContext context, String? id) async {
    try {
      await Provider.of<ExpertsData>(context, listen: false)
          .fetchExpertsData(id!);
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch experts $e");
      // Fluttertoast.showToast(msg: "Unable to fetch experts");
    }
  }

  void submit(BuildContext context) {
    Navigator.of(context).pushNamed(ExpertsList.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var expertiseData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF6F6F6),
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              size: 32,
              color: Colors.grey,
            ),
          ),
          title: Text(
            'Available Experts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: FutureBuilder(
          future: getExpertise(context, expertiseData["id"]),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<ExpertsData>(
                  builder: ((context, data, child) => data.expertData.isEmpty
                      ? const Center(
                          child: Text("No Experts Available"),
                        )
                      : ListView.builder(
                          itemCount: data.expertData.length,
                          itemBuilder: ((context, index) =>
                              AvailableExpertsCard(
                                expertData: data.expertData[index],
                                expertiseId: expertiseData["id"]!,
                                func: showbtmSheet,
                              )),
                        ))),
        ));
  }

  void showbtmSheet(BuildContext context, Map<String, dynamic> data) {
    // log(data.toString());

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: PhysioBottomSheetDateAndTimePicker(data: data),
      ),
    );
  }
}
