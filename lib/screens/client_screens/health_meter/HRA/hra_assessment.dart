import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/HRA/hra_questionnaire.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class HraAssessment extends StatefulWidget {
  const HraAssessment({Key? key}) : super(key: key);

  @override
  State<HraAssessment> createState() => _HraAssessmentState();
}

class _HraAssessmentState extends State<HraAssessment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Health Risk Assessment'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Take the HRA',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Health Risk Assessment (HRA) is a questionnaire to evaluate your health risks and quality of life. At the end of this assessment you will be given a HRA score indicating your health status.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: "Let's Start",
                    func: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HraQuestionnaire();
                      })).then((value) {
                        setState(() {});
                      });
                    },
                    gradient: orangeGradient,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
