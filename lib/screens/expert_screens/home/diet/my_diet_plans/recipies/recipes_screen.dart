import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/diet_plans/diet_plans_provider.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/recipies/edit_recipe.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/recipies/my_recipies.dart';
import 'package:healthonify_mobile/widgets/experts/home/diet/recipe_card.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  bool isLoading = true;
  List<RecipiesModel> allRecipies = [];

  Future<void> fetchRecipies() async {
    try {
      allRecipies = await Provider.of<DietPlansProvider>(context, listen: false)
          .getRecipies("get/recipes");
      log('fetched all recipies');
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

  @override
  void initState() {
    super.initState();
    fetchRecipies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        snap: false,
                        centerTitle: false,
                        title: Text(
                          'Recipes',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const MyRecipiesScreen();
                                }));
                              },
                              child: const Text('My Recipes'),
                            ),
                          ),
                        ],
                        iconTheme: Theme.of(context).iconTheme.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        bottom: AppBar(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          automaticallyImplyLeading: false,
                          title: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 5),
                              child: TextField(
                                cursorColor: whiteColor,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: whiteColor),
                                decoration: InputDecoration(
                                  fillColor: orange,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: 'Search for recipe',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: whiteColor),
                                  suffixIcon: const Icon(
                                    Icons.search,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Other Sliver Widgets
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: allRecipies.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return RecipeCard(
                                  recipiesModel: allRecipies[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  color: whiteColor,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const EditRecipe(
                              title: "Add Recipe",
                            ),
                          ),
                        )
                        .then((value) => fetchRecipies()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Text(
                          "Add Recipe",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
