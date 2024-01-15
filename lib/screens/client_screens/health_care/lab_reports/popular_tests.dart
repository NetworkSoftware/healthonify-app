import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/popular_tests_model.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/test_labs.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class PopularTestsScreen extends StatefulWidget {
  const PopularTestsScreen({super.key});

  @override
  State<PopularTestsScreen> createState() => _PopularTestsScreenState();
}

class _PopularTestsScreenState extends State<PopularTestsScreen> {
  bool isLoading = true;

  List<PopularTestsModel> popularTests = [];

  Future<void> getTests() async {
    try {
      popularTests = await Provider.of<LabsProvider>(context, listen: false)
          .getPopularTests();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting popular tests: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Popular Tests'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: popularTests.length,
                    itemBuilder: (context, index) {
                      var testName = popularTests[index].name;
                      var price = popularTests[index].price;
                      return StatefulBuilder(
                        builder: (context, newState) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TestLabsScreen(testName: testName!);
                              }));
                            },
                            title: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    testName!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Rs. $price",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 30,
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.grey,
                        endIndent: 10,
                        indent: 10,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
