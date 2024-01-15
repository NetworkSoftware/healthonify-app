import "package:flutter/material.dart";
import "package:healthonify_mobile/widgets/cards/custom_appbar.dart";

class AppointmentPrescriptionScreen extends StatefulWidget {
  const AppointmentPrescriptionScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentPrescriptionScreen> createState() => _AppointmentPrescriptionScreenState();
}

class _AppointmentPrescriptionScreenState extends State<AppointmentPrescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Prescription"),
      body: Container(),
    );
  }
}
