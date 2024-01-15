import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_packages_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/physio/packages_card.dart';
import 'package:provider/provider.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({
    Key? key,
  }) : super(key: key);

  Future<void> getFunc(BuildContext context) async {
    try {
      await Provider.of<PhysioPackagesData>(context, listen: false).fetchPacakges();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get packages $e");
      Fluttertoast.showToast(msg: "Unable to get your packages");
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
                          builder: (context, value, child) =>
                              value.packagesData.isEmpty
                                  ? const Center(
                                      child: Text("No packages available"),
                                    )
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: value.packagesData.length,
                                      itemBuilder: (context, index) {
                                        return PackagesCard(
                                          data: value.packagesData[index],
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
