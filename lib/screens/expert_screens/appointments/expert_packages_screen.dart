import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/physio/expert_purchased_physio_packages.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/wm/expert_wm_purchased_packages.dart';
import 'package:provider/provider.dart';

class ExpertPackagesScreen extends StatelessWidget {
  final String? clientId;

  const ExpertPackagesScreen({Key? key, required this.clientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? topLevlExpertise =
        Provider.of<UserData>(context).userData.topLevelExpName;
    log(topLevlExpertise!);
    if (topLevlExpertise == "Dietitian") {
      return ExpertWmPurchasedPackages(
        clientID: clientId!,
      );
    } else {
      return ExpertPhysioPurchasedPackages(
        clientID: clientId!,
      );
    }
  }
}
