// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/doctors_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class DoctorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Doctors',
         
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: DoctorsCard(
              patientName: 'Doctor Name',
              patientEmail: 'email@email.com',
              patientContact: '+91-9876543210',
              patientEmail2: 'email@email.com',
            ),
          );
        },
      ),
    );
  }
}
