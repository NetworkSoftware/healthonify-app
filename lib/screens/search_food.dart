import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/create_diet.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/search_bar.dart';

class SearchFoodScreen extends StatelessWidget {
  final List recentMeals = [
    'Chicken Biryani',
    'Curd',
    'Milk',
    'Musk Melon Juice',
    'Upma',
    'Dal Chawal',
    'Milk',
    'Musk Melon Juice',
    'Upma',
    'Dal Chawal',
    'Milk',
    'Musk Melon Juice',
    'Upma',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
    'Dal Chawal',
  ];

  void getSearchValue(String value) => log(value);

  SearchFoodScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            CustomSearchBar(getValue: getSearchValue),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 14),
              child: Text(
                'Recently added',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: recentMeals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recentMeals[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                'Quantity :  100 gms, ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                'Calories : 25',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.add_rounded,
                        color: Color(0xFFff7f3f),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          // color: orange,
          decoration: BoxDecoration(
            gradient: orangeGradient,
            borderRadius: BorderRadius.circular(6),
          ),
          // color: orange,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateDiet();
              }));
            },
            child: Center(
              child: Text(
                'CREATE DIET',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
