import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/exercise_details.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class SearchExerciseScreen extends StatelessWidget {
  const SearchExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        appBarTitle: 'Search Exercises',
        widgetRight: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: whiteColor,
                size: 24,
              ),
              splashRadius: 20,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_rounded,
                color: whiteColor,
                size: 24,
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            searchBar(context),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return exerciseCard(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget exerciseCard(context) {
    String exerciseName = 'Bodyweight Crunch';
    String category = 'Abs';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ExerciseDetailScreen(
              title: exerciseName,
              category: category,
            );
          }));
        },
        title: Row(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: grey,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/icons/image_placeholder.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseName,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.add_circle_outline_rounded,
          color: whiteColor,
          size: 30,
        ),
      ),
    );
  }

  Widget searchBar(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF717579),
          ),
          fillColor: darkGrey,
          filled: true,
          hintText: 'Search for an exercise',
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
      ),
    );
  }
}
