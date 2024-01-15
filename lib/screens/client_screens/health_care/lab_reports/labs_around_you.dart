import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/lab_models.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/lab_tests.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LabsAroundYouScreen extends StatefulWidget {
  const LabsAroundYouScreen({super.key});

  @override
  State<LabsAroundYouScreen> createState() => _LabsAroundYouScreenState();
}

class _LabsAroundYouScreenState extends State<LabsAroundYouScreen> {
  late double latitude;
  late double longitude;

  bool isLoading = true;
  String noLabs = '';

  List<LabsModel> labsAroundMe = [];

  Future<void> getLabsAroundMe() async {
    //! temporary location !//
    double long = 17.47246428264744;
    double lat = 78.38621445916762;
    //
    try {
      labsAroundMe = await Provider.of<LabsProvider>(context, listen: false)
          .getLabsAroundYou(longitude, latitude);
    } on HttpException catch (e) {
      setState(() {
        noLabs = 'No Labs around you';
      });
      log('Http Exception: $e');
    } catch (e) {
      log('Error fetching labs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    log("location :LONG- ${locationData.longitude} LAT- ${locationData.latitude} ");
    latitude = locationData.latitude!;
    longitude = locationData.longitude!;

    getLabsAroundMe();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Labs around you'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : noLabs.isNotEmpty
              ? Center(child: Text(noLabs))
              : Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: labsAroundMe.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LabTestsScreen(
                                    labTests:
                                        labsAroundMe[index].labTestCategories!,
                                    labName: labsAroundMe[index].labName!,
                                    labTestId: labsAroundMe[index].id!,
                                  );
                                }));
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    labsAroundMe[index].labName!,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    labsAroundMe[index].address!,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: 30,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
