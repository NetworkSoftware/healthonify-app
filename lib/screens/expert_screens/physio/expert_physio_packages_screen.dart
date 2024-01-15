import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_packages_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/bottomsheets/get_expertise_btmsheet.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/expert_physio_packages_card.dart';
import 'package:provider/provider.dart';

class ExpertPhysioPackagesScreen extends StatelessWidget {
  final String userIdToAssign;
  final String consultationId;
  const ExpertPhysioPackagesScreen({
    required this.userIdToAssign,
    required this.consultationId,
    Key? key,
  }) : super(key: key);

  Future<void> getFunc(BuildContext context, String expertId) async {
    try {
      await Provider.of<PhysioPackagesData>(context, listen: false)
          .fetchPacakges(data: "?expertId=$expertId");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get sessions $e");
      Fluttertoast.showToast(msg: "Unable to get your packages");
    }
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    return Scaffold(
      appBar: CustomAddPackageAppBar(
        appBarTitle: 'Packages',
        onSubmit: () {
          ExpertiseBottomSheet.showExpertiseBottomSheet(
            context,
            userData.id,
          );
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (ctx) => const CreatePackage(),
          //   ),
          // );
        },
      ),
      body: FutureBuilder(
        future: getFunc(context, userData.id!),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Consumer<PhysioPackagesData>(
                          builder: (context, value, child) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.packagesData.length,
                            itemBuilder: (context, index) {
                              return ExpertPhysioPackagesCard(
                                consultationId: consultationId,
                                data: value.packagesData[index],
                                expertData: userData,
                                userIdToAssign: userIdToAssign,
                              );
                            },
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
