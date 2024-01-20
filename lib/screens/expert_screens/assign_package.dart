import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/package_model/package_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_consultations_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../constants/api_url.dart';

class PackageListScreen extends StatefulWidget {
  final String flowName;
  final String expertId;
  final String userId;
  final String ticketNumber;

  const PackageListScreen(
      {super.key,
      required this.flowName,
      required this.expertId,
      required this.ticketNumber,
      required this.userId});

  @override
  _PackageListScreenState createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  List<PackagesModel> product = [];

  // ...

  Future<List<PackagesModel>> getAllChallenges() async {
    String url = '${ApiUrl.url}get/package?flow=${widget.flowName}';

    List<PackagesModel> packages = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 404) {
        // Handle 404 error here, for example:
        log("Resource not found: ${response.body}");
        throw const HttpException("Resource not found");
      } else if (response.statusCode >= 400) {
        log(response.body.toString());
        throw HttpException(jsonDecode(response.body.toString())["message"]);
      }

      // Log the response content for debugging
      log("Response Content: ${response.body}");

      // Check if the response content is not empty and does not start with "<"
      if (response.body.isNotEmpty && !response.body.startsWith("<")) {
        final responseBody = json.decode(response.body);

        if (responseBody["status"] == 1) {
          final responseData = responseBody["data"];

          for (var ele in responseData) {
            List<dynamic> needToDo =
                ele['needToDo'] != null ? ele['needToDo'] as List<dynamic> : [];
            packages.add(
              PackagesModel(
                name: ele['name'],
                packageId: ele['_id'],
                price: double.parse(ele['price'].toString()),
                expertiseId: ele["expertiseId"] == null
                    ? {}
                    : ele["expertiseId"] as Map<String, dynamic>,
                subExpertiseId: ele["subCategoryId"] == null
                    ? {}
                    : ele["subCategoryId"] as Map<String, dynamic>,
                // subCategoryId: ele['subCategoryId'],
                // needToDo: needToDo,
                // category: '',
                // subCategory: '',
              ),
            );
          }

          return packages;
        } else {
          throw HttpException(responseBody["message"]);
        }
      } else {
        // Handle non-JSON response here
        log("Non-JSON Response: ${response.body}");
        // You can add your error handling logic here
        throw const HttpException("Invalid JSON response");
      }
    } catch (e) {
      throw HttpException('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllChallenges().then((challenges) {
      setState(() {
        product = challenges;
      });
    }).catchError((error) {
      if (error is HttpException) {
        log('HttpException: ${error.runtimeType}');
        if (error.message != null) {
          log('Message: ${error.message}');
        } else {
          log('Message is null');
        }
      } else {
        log('Error: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package List"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: product.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow(title: 'Package Name', value: product[index].name),
                    infoRow(
                        title: 'Price', value: product[index].price.toString()),
                    infoRow(
                        title: 'Category',
                        value: product[index].expertiseId!['name']),
                    infoRow(
                        title: 'SubCategory',
                        value: product[index].subExpertiseId!['name']),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          assignPackage(product[index]);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: orange,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: const Text(
                              "Assign to Client",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget infoRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Future<void> assignPackage(PackagesModel package) async {
    var data = Provider.of<UserData>(context, listen: false).userData;

    Map<String, dynamic> payload = {
      "ticketNumber": widget.ticketNumber,
      "expertId": widget.expertId,
      "flow": widget.flowName,
      "userId": widget.userId,
      "packageId": package.packageId
    };

    await Provider.of<WmConsultationData>(context, listen: false)
        .assignPackage(payload)
        .then((value) {
      Navigator.pop(context, true);
    });
  }
}
