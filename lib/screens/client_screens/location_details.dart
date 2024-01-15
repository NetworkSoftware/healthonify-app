import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/other/5_stars.dart';
import 'package:healthonify_mobile/widgets/other/old_new_price.dart';
import 'package:healthonify_mobile/widgets/other/package_gallery.dart';

class LocationDetailsScreen extends StatelessWidget {
  const LocationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://renokadventures.com/wp-content/uploads/2016/09/28464279894_7b42c0574c_z-1.jpg',
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.68),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Manali Trek',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const BuyNowButton1(),
                  ],
                ),
              ),
            ),
            FiveStars(),
           const OldNewPrice(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Package Gallery',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            PackageGallery(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Plan',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Transfer from Delhi in AC Volvo bus.\n\n All meals (Healthy and Organic).\n\n Bonfire and DJ on daily basis (except on date of travelling).\n\n Night Trekking with trained guide.\n\n Manali market and Snow point visit.(local manali tour or solang valley ).\n\n (Rohtang extra Charge ) \n\n 2 nights in base Camp Bamboo Huts and 2 Nights.\n\n Jungle camping.\n\n Adventure Sports.\n\n White water rafting (9 to 11 KM)\n\n Paragliding. \n\n Zip line and Tracking. \n\n Camping and Bonfire.\n\n Trekking Total plan will be of 6 Nights (2 nights travelling)\n\n',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Manali is a hill station in the Kullu district of Himachal Pradesh. It is situated at an altitude of 2,050 m in the mighty Himalayas. It is the gateway to skiing in the Solang Valley and trekking in Parvati Valley. With mountain adventures beckoning from all directions, it offers to the tourists a wide range of watersports including rafting, rappelling, river crossing, etc.\n\n This adventure gives you a piece of what all Manali has to offer. It includes a wide array of activities like rock-climbing, fishing, trekking, river crossing, Paragliding, Camping etc. All of this neatly gift-wrapped in the form of the delicious camp food and the fun campfire.\n\n That’s right! For this adventure, you will be staying in a jungle camp for two night under the black sky and the stars, sleeping in the sleeping bags. Rest assured, the tents, sleeping bags, linen, pillows, etc. provided with us follow rigorous hygiene standards and will not disappoint.\n\n',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: BuyNowButton2(),
            ),
          ],
        ),
      ),
    );
  }
}
