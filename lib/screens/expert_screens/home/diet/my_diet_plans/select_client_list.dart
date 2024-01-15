import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/experts/home/diet/diet_client_checkbox_card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SelectClientList extends StatelessWidget {
  SelectClientList({Key? key}) : super(key: key);

  final Map<String, String> pData = {
    'expertId': '',
    "flow": 'consultation',
    "type": "physio"
  };
  bool _noContent = false;
  TimeOfDay? _selectedTime;

  Future<void> getPatientData(BuildContext context) async {
    String userid = Provider.of<UserData>(context, listen: false).userData.id!;
    pData['expertId'] = userid;
    // log(pData.toString());
    try {
      await Provider.of<PatientsData>(context, listen: false)
          .fetchPatientData(pData);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error fetching patient data $e");
      Fluttertoast.showToast(msg: "Error : $e");
      _noContent = true;
    }
  }

  Widget appBarBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
      child: TextButton.icon(
        icon: const Icon(Icons.add),
        label: const Text("Assign"),
        onPressed: () {
          addClientDietMealTime(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(
              'Select Client',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [
              appBarBtn(context),
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            bottom: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: TextField(
                    cursorColor: whiteColor,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: whiteColor),
                    decoration: InputDecoration(
                      fillColor: orange,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search client',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: whiteColor),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder(
                  future: getPatientData(context),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _noContent
                              ? const Center(
                                  child: Text("No patients available"),
                                )
                              : Consumer<PatientsData>(
                                  builder: (context, data, child) =>
                                      ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: data.patientData.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: DietClientCheckbox(
                                          clientId:
                                              data.patientData[index].clientId!,
                                          imageUrl: data.patientData[index]
                                                  .imageUrl ??
                                              "",
                                          patientName:
                                              '${data.patientData[index].firstName!} ${data.patientData[index].lastName!}',
                                          patientEmail:
                                              data.patientData[index].email!,
                                          patientContact:
                                              data.patientData[index].mobileNo!,
                                          location: "" ', ' "" ', ' "",
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addClientDietMealTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Enter Diet Plan Start Date (Optional) ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 28,
                      ),
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: StatefulBuilder(
                  builder: (context, newState) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime == null
                            ? TimeOfDay.now().format(context)
                            : _selectedTime!.format(context),
                        // style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        //       color: Colors.black,
                        //     ),
                      ),
                      TextButton(
                        onPressed: () {
                          _timePicker(context, newState);
                        },
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => showAddClientDialog(context),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Dialog showAddClientDialog(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Successful",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Diet Plan assigned succesfully!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "OK",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _timePicker(context, StateSetter thisState) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      thisState(() {
        _selectedTime = value;
      });
    });
  }
}
