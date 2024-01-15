// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/blogs_provider/blogs_provider.dart';
import 'package:healthonify_mobile/providers/diet_plans/diet_plans_provider.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blog_details_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/corporate/corporate_assets.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_categories.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_category_scroller.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/scrollers/featured_classes.dart';
import 'package:provider/provider.dart';

class CorporateScreen extends StatefulWidget {
  const CorporateScreen({Key? key}) : super(key: key);

  @override
  State<CorporateScreen> createState() => _CorporateScreenState();
}

class _CorporateScreenState extends State<CorporateScreen> {
  bool isLoading = true;
  List<BlogsModel> blogs = [];

  Future<void> fetchAllBlogs() async {
    try {
      blogs = await Provider.of<BlogsProvider>(context, listen: false)
          .getAllBlogs();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching blogs');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  List<LiveWellCategories> liveWellCategories = [];
  List<LiveWellCategories> liveWellSubCategories = [];

  Future<void> getCategories() async {
    try {
      liveWellCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories("master=1");
      log('fetched live well categories');

      liveWellSubCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories(
                  "parentCategoryId=${liveWellCategories[0].parentCategoryId}");
      log('fetched live well sub categories');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting live well categories: $e");
      Fluttertoast.showToast(msg: "Unable to fetch live well categories");
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
    getCategories();
    fetchAllBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            const FlexibleAppBar(
              title: 'Corporate',
              listItems: CorporateTopList(),
            ),
          ];
        },
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : corporateContent(context),
      ),
    );
  }

  Widget corporateContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCarouselSlider(
            imageUrls: [
              {
                'image': 'assets/images/corporate/corporate1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/corporate/corporate2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/corporate/corporate3.jpg',
                'route': () {},
              },
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Card(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: Text(
          //             'Leaderboard',
          //             style: Theme.of(context).textTheme.labelMedium,
          //           ),
          //         ),
          //         ListTile(
          //           dense: true,
          //           title: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 'Challenge 1',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //               Text(
          //                 '#10',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //             ],
          //           ),
          //           trailing: TextButton(
          //             onPressed: () {},
          //             child: const Text('view'),
          //           ),
          //         ),
          //         ListTile(
          //           dense: true,
          //           title: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 'Challenge 2',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //               Text(
          //                 '#12',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //             ],
          //           ),
          //           trailing: TextButton(
          //             onPressed: () {},
          //             child: const Text('view'),
          //           ),
          //         ),
          //         ListTile(
          //           dense: true,
          //           title: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 'Challenge 3',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //               Text(
          //                 '#18',
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //             ],
          //           ),
          //           trailing: TextButton(
          //             onPressed: () {},
          //             child: const Text('view'),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Hscroller(
          //   cardTitle: 'Courses',
          //   imgUrl:
          //       'https://imgs.search.brave.com/SohjOoWNBsS04AcxMJEzgyr32CTtPe0oMksXPTMYv5Q/rs:fit:1200:1200:1/g:ce/aHR0cDovL3RoZXdv/d3N0eWxlLmNvbS93/cC1jb250ZW50L3Vw/bG9hZHMvMjAxNS8w/MS9uYXR1cmUtaW1h/Z2VzLXdhbGxwYXBl/ci5qcGc',
          //   scrollerTitle: 'Free Courses',
          //   onTouch: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return const CoursesScreen();
          //     }));
          //   },
          // ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ChallengesScroller(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Fitness',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              mainAxisExtent: 96,
              childAspectRatio: 1 / 0.55,
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: fitnessTools.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      fitnessTools[index]['route'](context);
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(fitnessTools[index]['icon']),
                    ),
                  ),
                  Text(
                    fitnessTools[index]['title'],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Nutrition',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              mainAxisExtent: 96,
              childAspectRatio: 1 / 0.55,
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: nutritionTools.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      nutritionTools[index]['route'](context);
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(nutritionTools[index]['icon']),
                    ),
                  ),
                  Text(
                    nutritionTools[index]['title'],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
            child: Text(
              'Health',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 110,
            child: Center(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: healthItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            healthItems[index]['route'](context);
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            foregroundImage: AssetImage(
                              healthItems[index]['icon'],
                            ),
                          ),
                        ),
                        Text(
                          healthItems[index]['title'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
          //   child: Text(
          //     'Experience MiBoSo (Mind, Body, Soul)',
          //     style: Theme.of(context).textTheme.headlineSmall,
          //   ),
          // ),
          // SizedBox(
          //   height: 150,
          //   child: Center(
          //     child: ListView.builder(
          //       physics: const BouncingScrollPhysics(),
          //       scrollDirection: Axis.horizontal,
          //       shrinkWrap: true,
          //       itemCount: miboso.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.all(8),
          //           child: Column(
          //             children: [
          //               ClipRRect(
          //                 borderRadius: BorderRadius.circular(10),
          //                 child: InkWell(
          //                   onTap: () {
          //                     miboso[index]['route'](context);
          //                   },
          //                   child: Image.network(
          //                     "https://imgs.search.brave.com/_rX7W4bPtOALvvPL8_x8CFqMH8QZ5U1E482Aq7wiGvY/rs:fit:1200:1125:1/g:ce/aHR0cHM6Ly93d3cu/cGNjbGVhbi5pby93/cC1jb250ZW50L2dh/bGxlcnkvYXVyb3Jh/LWhkLXdhbGxwYXBl/cnMvNzUwMjM3Lmpw/Zw",
          //                     height: 110,
          //                     width: 150,
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //               ),
          //               Text(
          //                 miboso[index]['title'],
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Text(
              "Recipes",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 154,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: allRecipies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {},
                          child: Image.network(
                            allRecipies[index].mediaLink!,
                            height: 110,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        allRecipies[index].name!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Hscroller(
          //   cardTitle: 'Recipe',
          //   imgUrl:
          //       'https://imgs.search.brave.com/W-ZpHrKTffHWFBsrYkYhu52R9LFrratP74z7vwF0p5M/rs:fit:1200:811:1/g:ce/aHR0cHM6Ly9pbWcu/ZW1lZGloZWFsdGgu/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDIxLzAyL2Zvb2Qt/YmxvZy1mZWF0Lmpw/Zw',
          //   scrollerTitle: 'Recipes',
          //   onTouch: () {},
          // ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: liveWellCategories.length,
            itemBuilder: (context, verticalIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          liveWellCategories[verticalIndex].name!,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            log(liveWellCategories[verticalIndex]
                                .parentCategoryId!);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SubCategoriesScreen(
                                screenTitle:
                                    liveWellCategories[verticalIndex].name!,
                                parentCategoryId:
                                    liveWellCategories[verticalIndex]
                                        .parentCategoryId!,
                              );
                            }));
                          },
                          child: const Text('show all'),
                        ),
                      ],
                    ),
                  ),
                  SubCategoryScroller(
                    parentCategoryId:
                        liveWellCategories[verticalIndex].parentCategoryId!,
                  ),
                ],
              );
            },
          ),
          // Hscroller(
          //   cardTitle: 'Live',
          //   imgUrl:
          //       'https://imgs.search.brave.com/-rD4LgPgh4EWPmEOOWcTsZASPrvVBvjudSZtvu9tph8/rs:fit:1000:667:1/g:ce/aHR0cDovL3d3dy5z/aWNrY2hpcnBzZS5j/b20vd3AtY29udGVu/dC91cGxvYWRzLzIw/MTUvMDIvQW1hemlu/Zy1Gb3Jlc3QtQmFW/QVJJQS5qcGc',
          //   scrollerTitle: 'Live Courses',
          //   onTouch: () {},
          // ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Consult Experts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              mainAxisExtent: 96,
              childAspectRatio: 1 / 0.55,
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: consultExperts.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      consultExperts[index]['route'](context);
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(consultExperts[index]['icon']),
                    ),
                  ),
                  Text(
                    consultExperts[index]['title'],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          Hscroller(
            cardTitle: 'Adventures',
            imgUrl:
                'https://images.unsplash.com/photo-1600914831426-e5d1ea237920?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTB8fGZlYXR1cmVkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
            scrollerTitle: 'Adventures',
            onTouch: () {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                child: Text(
                  "Blogs",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlogsScreen(allBlogs: blogs);
                  }));
                },
                child: const Text('view all'),
              ),
            ],
          ),
          SizedBox(
            height: 154,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlogDetailsScreen(blogData: blogs[index]);
                            }));
                          },
                          child: Image.network(
                            blogs[index].mediaLink!,
                            height: 110,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        blogs[index].blogTitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Hscroller(
          //   cardTitle: 'Blogs',
          //   imgUrl:
          //       'https://images.unsplash.com/photo-1600914831426-e5d1ea237920?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTB8fGZlYXR1cmVkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
          //   scrollerTitle: 'Blogs',
          //   onTouch: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return BlogsScreen(allBlogs: blogs);
          //     }));
          //   },
          // ),
        ],
      ),
    );
  }
}
