import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopList extends StatelessWidget {
  final String? image;
  const ShopList({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List shopItems = [
      'Whey Protein',
      'Energy Drink',
      'Milkshakes',
      'Fruit Juices',
      'Dry Fruit Shakes',
    ];
    List shopImages = [
      'assets/images/shop/shop1.jpg',
      'assets/images/shop/shop2.webp',
      'assets/images/shop/shop3.jpg',
      'assets/images/shop/shop4.jpg',
      'assets/images/shop/shop5.jpg',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Shop',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: shopImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://healthonify.com/Shop"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              shopImages[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
