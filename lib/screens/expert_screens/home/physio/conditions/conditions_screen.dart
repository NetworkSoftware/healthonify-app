import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercises_screen.dart';

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(
              'Conditions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            bottom: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: TextField(
                    cursorColor: whiteColor,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: whiteColor),
                    decoration: InputDecoration(
                      fillColor: orange,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search for conditions',
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
            delegate: SliverChildListDelegate([
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => _condCard(context)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _condCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    const ExpertExercisesScreen(isConditions: true),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "ACL Sprain-Grade 1",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
