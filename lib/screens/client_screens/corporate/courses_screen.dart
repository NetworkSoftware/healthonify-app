import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/corporate/detail_course.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Courses'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Mind',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 154,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
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
                                return const DetailedCourseScreen(
                                  appBarTitle: 'Mind',
                                );
                              }));
                            },
                            child: Image.network(
                              "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Daily Activity",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Body',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 154,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
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
                                return const DetailedCourseScreen(
                                  appBarTitle: 'Body',
                                );
                              }));
                            },
                            child: Image.network(
                              "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Daily Activity",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Soul',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 154,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
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
                                return const DetailedCourseScreen(
                                  appBarTitle: 'Soul',
                                );
                              }));
                            },
                            child: Image.network(
                              "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Daily Activity",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Heart',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 154,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
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
                                return const DetailedCourseScreen(
                                  appBarTitle: 'Heart',
                                );
                              }));
                            },
                            child: Image.network(
                              "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Daily Activity",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Others',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 154,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
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
                                return const DetailedCourseScreen(
                                  appBarTitle: 'Others',
                                );
                              }));
                            },
                            child: Image.network(
                              "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                              height: 110,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Daily Activity",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
