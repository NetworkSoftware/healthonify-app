import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/body_parts/expert_body_parts_screen.dart';

class ExTemplateScreen extends StatelessWidget {
  const ExTemplateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: Text(
                    'Exercise Templates',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color),
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
                            hintText: 'Search for your templates',
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
                    const Text("Code commented hep plans will come here check code"),

                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: 10,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemBuilder: (_, index) => const HEPlistDetailsCard())
                  ]),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 60,
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.secondary,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExpertBodyPartsScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create new workout',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      // persistentFooterButtons: [
      //   Container(
      //     height: 50,
      //     color: Colors.red,
      //   )
      // ],
    );
  }
}
