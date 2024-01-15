import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/health_care/expert_view_hc_consultations.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/physio/expert_view_physio_consultations.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/wm/expert_view_wm_consultations.dart';
import 'package:provider/provider.dart';

class ExpertConsultationScreen extends StatelessWidget {
  final String? clientId;

  const ExpertConsultationScreen({Key? key, required this.clientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? topLevlExpertise =
        Provider.of<UserData>(context).userData.topLevelExpName;
    log(topLevlExpertise!);
    if (topLevlExpertise == "Dietitian") {
      return ExpertViewWmConsultations(clientId: clientId);
    } else if (topLevlExpertise == "Health Care") {
      return ExpertViewHcConsultations(clientId: clientId);
    } else {
      return ExpertViewPhysioConsultations(
        clientID: clientId,
      );
    }
  }
}
