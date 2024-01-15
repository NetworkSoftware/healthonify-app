import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_packages_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/physio/packages_card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PackagesByHealth extends StatelessWidget {
  final Map<String, String> data;
  PackagesByHealth({
    Key? key,
    required this.data,
  }) : super(key: key);

  bool noContent = false;

  Future<void> getFunc(BuildContext context) async {
    try {
      await Provider.of<PhysioPackagesData>(context, listen: false)
          .getPackageByCondition(data);
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      noContent = true;
    } catch (e) {
      log("Error get sessions $e");
      Fluttertoast.showToast(msg: "Not able to fetch packages");
      noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Packages',
         
      ),
      body: FutureBuilder(
        future: getFunc(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : noContent
                ? const Center(
                    child: Text("No Packages available"),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Consumer<PhysioPackagesData>(
                          builder: (context, value, child) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.packagesHealthData.length,
                            itemBuilder: (context, index) {
                              return PackagesCard(
                                data: value.packagesHealthData[index],
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
