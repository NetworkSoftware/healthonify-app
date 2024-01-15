import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/lab_cities.dart';
import 'package:healthonify_mobile/models/lab_models/lab_models.dart';
import 'package:healthonify_mobile/providers/labs_provider/get_cities.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/lab_tests.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class TestLabsScreen extends StatefulWidget {
  final String testName;
  const TestLabsScreen({super.key, required this.testName});

  @override
  State<TestLabsScreen> createState() => _TestLabsScreenState();
}

class _TestLabsScreenState extends State<TestLabsScreen> {
  bool isLoading = true;

  List<LabCity> labCities = [];

  Future<void> getCities() async {
    try {
      labCities = await Provider.of<GetCitiesProvider>(context, listen: false)
          .getLabCities();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting cities: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isSearching = false;
  List<LabsAroundyouModel> searchResults = [];

  Future<void> labsSearch(String cityId, String cityName) async {
    setState(() {
      isSearching = true;
    });
    try {
      searchResults = await Provider.of<LabsProvider>(context, listen: false)
          .searchLabs(cityId, cityName);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error searching cities: $e");
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  void searchLabs(String cityId, String testName) async {
    await labsSearch(cityId, testName);
  }

  LabCity? testCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.testName),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Select the city you would like to take the test in',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: labCities.map<DropdownMenuItem<LabCity>>((value) {
                      return DropdownMenuItem<LabCity>(
                        value: value,
                        child: Text(
                          value.name!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic newValue) {
                      setState(() {
                        testCity = newValue;
                        searchLabs(testCity!.id!, widget.testName);
                        // labsSearch(testCity!.id!, widget.testName);
                      });
                    },
                    value: testCity,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: orange,
                          width: 1.25,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 56,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    hint: Text(
                      'Select',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                searchResults.isNotEmpty
                    ? isSearching
                        ? const SizedBox(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            children: [
                              Text(
                                'Search Results',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 16),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  List<LabTestModel> labTests = [];

                                  if (searchResults[index].labTestCategoryId !=
                                          null ||
                                      searchResults[index]
                                          .labTestCategoryId!
                                          .isNotEmpty) {
                                    for (var ele in searchResults[index]
                                        .labTestCategoryId!) {
                                      labTests.add(
                                        LabTestModel(
                                          labTestCategoryId: ele.id,
                                          name: ele.name,
                                          price: ele.price,
                                        ),
                                      );
                                    }
                                  }

                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return LabTestsScreen(
                                              labTests: labTests,
                                              labName:
                                                  searchResults[index].name!,
                                              labTestId:
                                                  searchResults[index].id!,
                                            );
                                          }));
                                        },
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              searchResults[index].name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              searchResults[index].address!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          Icons.chevron_right_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(color: Colors.grey);
                                },
                              ),
                            ],
                          )
                    : const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text('No labs available'),
                        ),
                      ),
              ],
            ),
    );
  }
}
