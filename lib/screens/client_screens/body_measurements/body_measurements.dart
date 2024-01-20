import 'dart:developer';
import 'package:healthonify_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/body_measurements_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/body_measurements_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/add_body_measurements.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  final bool isFromClient;
  final String? clientId;

  const BodyMeasurementsScreen(
      {Key? key, this.isFromClient = false, this.clientId})
      : super(key: key);

  @override
  State<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  bool isloading = false;
  late String? userId;
  DateTime selectedDateTime = DateTime.now();

  List<BodyMeasurements> bodyMeasurements = [];

  Future<void> fetchBodyMeasurements(String id, {String? date}) async {
    log(id);
    setState(() {
      isloading = true;
    });
    try {
      if (widget.isFromClient) {
        if (date == null) {
          bodyMeasurements = await Provider.of<BodyMeasurementsProvider>(
                  context,
                  listen: false)
              .getBodyMeasurements("userId=${widget.clientId}");
        } else {
          bodyMeasurements = await Provider.of<BodyMeasurementsProvider>(
                  context,
                  listen: false)
              .getBodyMeasurements("userId=${widget.clientId}&date=$date");
        }
      } else {
        if (date == null) {
          bodyMeasurements = await Provider.of<BodyMeasurementsProvider>(
                  context,
                  listen: false)
              .getBodyMeasurements("userId=$id");
        } else {
          bodyMeasurements = await Provider.of<BodyMeasurementsProvider>(
                  context,
                  listen: false)
              .getBodyMeasurements("userId=$id&date=$date");
        }
      }
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  bool status = false;
  String? measurementUnits;

  @override
  void initState() {
    super.initState();
    userId = widget.clientId ??
        Provider.of<UserData>(context, listen: false).userData.id;
    fetchBodyMeasurements(userId!);
    measurementUnits = bodyMeasurements.isEmpty
        ? 'cms'
        : bodyMeasurements[0].measurements!.measurementUnits;
  }

  String nullText = 'No data available';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Body Measurements',
        actionWIdget2: preferences.getString("role") == "ROLE_EXPERT"
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddBodyMeasurementsScreen();
                  })).then((value) {
                    fetchBodyMeasurements(userId!);
                    setState(() {});
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: whiteColor,
                ),
              ),
        widgetRight: IconButton(
          onPressed: () {
            datePicker();
          },
          icon: const Icon(
            Icons.calendar_month,
            color: whiteColor,
          ),
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : bodyMeasurements.isEmpty
              ? const Center(child: Text('No body measurements added'))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (preferences.getString("role") != "ROLE_EXPERT")
                        Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              if (!widget.isFromClient)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enable weight log reminders',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: whiteColor),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, state) =>
                                            FlutterSwitch(
                                          width: 38,
                                          height: 18,
                                          valueFontSize: 10,
                                          toggleSize: 12,
                                          inactiveColor: Colors.white,
                                          inactiveToggleColor: Colors.blue,
                                          activeColor: const Color(0xFFff7f3f),
                                          activeToggleColor: Colors.white,
                                          value: status,
                                          onToggle: (val) {
                                            state(() {
                                              status = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12, left: 10, right: 10),
                                child: Text(
                                  'You will be notified your chosen day & time every week',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: whiteColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 150,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    bodyMeasurements[0]
                                            .mediaLinks!
                                            .frontImage ??
                                        "https://imgs.search.brave.com/uYuhTPXAdtpgOIo-CEOEVxs1fvuQAjA8jFQjxBdihaQ/rs:fit:300:225:1/g:ce/aHR0cHM6Ly93d3cu/Z3JvdXBoZWFsdGgu/Y2Evd3AtY29udGVu/dC91cGxvYWRzLzIw/MTgvMDUvcGxhY2Vo/b2xkZXItaW1hZ2Ut/MzAweDIyNS5wbmc",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 150,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    bodyMeasurements[0].mediaLinks!.sideImage ??
                                        "https://imgs.search.brave.com/uYuhTPXAdtpgOIo-CEOEVxs1fvuQAjA8jFQjxBdihaQ/rs:fit:300:225:1/g:ce/aHR0cHM6Ly93d3cu/Z3JvdXBoZWFsdGgu/Y2Evd3AtY29udGVu/dC91cGxvYWRzLzIw/MTgvMDUvcGxhY2Vo/b2xkZXItaW1hZ2Ut/MzAweDIyNS5wbmc",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 150,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    bodyMeasurements[0].mediaLinks!.backImage ??
                                        "https://imgs.search.brave.com/uYuhTPXAdtpgOIo-CEOEVxs1fvuQAjA8jFQjxBdihaQ/rs:fit:300:225:1/g:ce/aHR0cHM6Ly93d3cu/Z3JvdXBoZWFsdGgu/Y2Evd3AtY29udGVu/dC91cGxvYWRzLzIw/MTgvMDUvcGxhY2Vo/b2xkZXItaW1hZ2Ut/MzAweDIyNS5wbmc",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      bodyMeasurements[0].note == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text('Note: ${bodyMeasurements[0].note}'),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            subCards(
                              'Body Fat',
                              bodyMeasurements[0].bodyFat == null
                                  ? nullText
                                  : '${bodyMeasurements[0].bodyFat!}%',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Muscle Mass',
                              bodyMeasurements[0].muscleMass == null
                                  ? nullText
                                  : '${bodyMeasurements[0].muscleMass!}%',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Weight',
                              bodyMeasurements[0].weightInKg == null
                                  ? nullText
                                  : '${bodyMeasurements[0].weightInKg!} kgs',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Height',
                              bodyMeasurements[0].totalheight == null
                                  ? nullText
                                  : '${bodyMeasurements[0].totalheight!} cms',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Visceral Fat',
                              bodyMeasurements[0].visceralFat == null
                                  ? nullText
                                  : '${bodyMeasurements[0].visceralFat!}%',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Sub Cutaneous',
                              bodyMeasurements[0].subCutaneous == null
                                  ? nullText
                                  : '${bodyMeasurements[0].subCutaneous!}%',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Blood Pressure',
                              bodyMeasurements[0].bloodPressure == null
                                  ? nullText
                                  : bodyMeasurements[0].bloodPressure!,
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'BMI',
                              bodyMeasurements[0].bmi == null
                                  ? nullText
                                  : bodyMeasurements[0].bmi.toString(),
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'BMR',
                              bodyMeasurements[0].bmr == null
                                  ? nullText
                                  : '${bodyMeasurements[0].bmr}',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Body Metabolic Age',
                              bodyMeasurements[0].bodyMetabolicAge == null
                                  ? nullText
                                  : '${bodyMeasurements[0].bodyMetabolicAge}',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Heart Rate',
                              bodyMeasurements[0].heartRate == null
                                  ? nullText
                                  : "${bodyMeasurements[0].heartRate}",
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    'Measurements',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            subCards(
                              'Bust',
                              bodyMeasurements[0].measurements!.bust == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.bust}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Waist',
                              bodyMeasurements[0].measurements!.waist == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.waist}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Hips',
                              bodyMeasurements[0].measurements!.hips == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.hips} inches',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Chest',
                              bodyMeasurements[0].measurements!.chest == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.chest} inches',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Midway',
                              bodyMeasurements[0].measurements!.midway == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.midway}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Thighs',
                              bodyMeasurements[0].measurements!.thighs == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.thighs}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Knees',
                              bodyMeasurements[0].measurements!.knees == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.knees}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Calves',
                              bodyMeasurements[0].measurements!.calves == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.calves}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Upper Arms',
                              bodyMeasurements[0].measurements!.upperArms ==
                                      null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.upperArms}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Fore Arms',
                              bodyMeasurements[0].measurements!.foreArms == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.foreArms}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Neck',
                              bodyMeasurements[0].measurements!.neck == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.neck}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Shoulder',
                              bodyMeasurements[0].measurements!.shoulder == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.shoulder}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Wrist',
                              bodyMeasurements[0].measurements!.wrist == null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.wrist}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Upper Abdomen',
                              bodyMeasurements[0].measurements!.upperAbdomen ==
                                      null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.upperAbdomen}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                            subCards(
                              'Lower Abdomen',
                              bodyMeasurements[0].measurements!.lowerAbdomen ==
                                      null
                                  ? nullText
                                  : '${bodyMeasurements[0].measurements!.lowerAbdomen}($measurementUnits)',
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
    );
  }

  void datePicker() {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: selectedDateTime,
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      DateTime selectedDate;
      setState(() {
        selectedDateTime = value;
        selectedDate = value;
        var formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
        fetchBodyMeasurements(userId!, date: formattedDate);
      });
    });
  }

  Widget subCards(
    String title,
    String subTitle,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
