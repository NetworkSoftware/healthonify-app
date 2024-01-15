import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/search_food.dart';

class MealDetailsCard extends StatelessWidget {
  final String meal;
  final int calories;
  final String mealName;

  const MealDetailsCard({Key? key, 
    required this.meal,
    required this.calories,
    required this.mealName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 124,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchFoodScreen();
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/icons/add.png',
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '$calories / 427 Cal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      mealName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '$calories Cal',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
