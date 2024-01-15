import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

class GetClients {
  Future<bool> getPatientData(
      BuildContext context, Map<String, String> pData) async {
    String userid = Provider.of<UserData>(context, listen: false).userData.id!;
    pData['expertId'] = userid;
    // log(pData.toString());

    // log(pData.toString());
    try {
      await Provider.of<PatientsData>(context, listen: false)
          .fetchPatientData(pData);
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return true;
    } catch (e) {
      log("Error fetching patient data $e");
      // Fluttertoast.showToast(msg: "Error : " + e.toString());
      return true;

    }
  }
}
