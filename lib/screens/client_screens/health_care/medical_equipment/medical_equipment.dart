import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalEquipmentScreen extends StatelessWidget {
  const MedicalEquipmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Rent/Buy Medical Equipment'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Rent',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Category 1',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse("https://healthonify.com/Shop"));
                              // showRentalDetails(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://imgs.search.brave.com/dyEMJDDApKaNRov07XC-wKFkOf3sCkoOlIfdsV6VjIs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly92ZWdh/c3ZhbGxleXZlaW4u/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDE4LzExL21lZGlj/YWxfZXF1aXBtZW50/LmpwZw',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Item ${index + 1}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View more'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Buy',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Category 1',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse("https://healthonify.com/Shop"));
                              // showRentalDetails(context);
                            },
                            child: SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://imgs.search.brave.com/dyEMJDDApKaNRov07XC-wKFkOf3sCkoOlIfdsV6VjIs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly92ZWdh/c3ZhbGxleXZlaW4u/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDE4LzExL21lZGlj/YWxfZXF1aXBtZW50/LmpwZw',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Item ${index + 1}',
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
                'Category 2',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse("https://healthonify.com/Shop"));
                              // showRentalDetails(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://imgs.search.brave.com/dyEMJDDApKaNRov07XC-wKFkOf3sCkoOlIfdsV6VjIs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly92ZWdh/c3ZhbGxleXZlaW4u/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDE4LzExL21lZGlj/YWxfZXF1aXBtZW50/LmpwZw',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Item ${index + 1}',
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
                'Category 3',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              //showRentalDetails(context);
launchUrl(Uri.parse("https://healthonify.com/Shop"));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://imgs.search.brave.com/dyEMJDDApKaNRov07XC-wKFkOf3sCkoOlIfdsV6VjIs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly92ZWdh/c3ZhbGxleXZlaW4u/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDE4LzExL21lZGlj/YWxfZXF1aXBtZW50/LmpwZw',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Item ${index + 1}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View more'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void showRentalDetails(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                'https://imgs.search.brave.com/dyEMJDDApKaNRov07XC-wKFkOf3sCkoOlIfdsV6VjIs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly92ZWdh/c3ZhbGxleXZlaW4u/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDE4LzExL21lZGlj/YWxfZXF1aXBtZW50/LmpwZw',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. A diam maecenas sed enim. Posuere ac ut consequat semper.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Rent',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '30 days',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Rs.2,500',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy'),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '60 days',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Rs.5,000',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy'),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '90 days',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Rs.10,000',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
