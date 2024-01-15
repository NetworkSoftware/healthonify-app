import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercises_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ExpertBodyPartsScreen extends StatelessWidget {
  const ExpertBodyPartsScreen({Key? key}) : super(key: key);

  Future<void> getBodyPartsData(BuildContext context) async {
    try {
      await Provider.of<HealthData>(context, listen: false).getBodyParts();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "BodyParts"),
      body: FutureBuilder(
        future: getBodyPartsData(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<HealthData>(
                builder: (context, value, child) => GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1 / 1.2,
                  ),
                  itemCount: value.bodyParts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ExpertExercisesScreen(
                                  bodyPartId: value.bodyParts[index].id!,
                                )));
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

                          CachedNetworkImage(
                            imageUrl:
                                value.bodyParts[index].bodyPartImage ?? "",
                            height: 80,
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/icons/neck.png",
                              height: 80,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            value.bodyParts[index].name!,
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Text("${bodyPartsList[index]["total"]} Exercises",
                          //     style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
