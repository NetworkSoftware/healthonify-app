import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/diet_plans/diet_plans_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/experts/home/diet/recipe_card.dart';
import 'package:provider/provider.dart';

class MyRecipiesScreen extends StatefulWidget {
  const MyRecipiesScreen({super.key});

  @override
  State<MyRecipiesScreen> createState() => _MyRecipiesScreenState();
}

class _MyRecipiesScreenState extends State<MyRecipiesScreen> {
  bool isLoading = true;
  List<RecipiesModel> myRecipies = [];

  Future<void> fetchRecipies() async {
    try {
      myRecipies = await Provider.of<DietPlansProvider>(context, listen: false)
          .getRecipies("get/recipes?userId=$userId");
      log('fetched my recipies');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching recipies');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    fetchRecipies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Recipies'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: myRecipies.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return RecipeCard(
                    recipiesModel: myRecipies[index],
                  );
                },
              ),
            ),
    );
  }
}
