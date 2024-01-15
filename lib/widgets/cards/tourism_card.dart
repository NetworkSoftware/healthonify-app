import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';

class TourismCard extends StatelessWidget {
  const TourismCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          elevation: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    'https://renokadventures.com/wp-content/uploads/2016/09/28464279894_7b42c0574c_z-1.jpg',
                    height: 164,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Manali Trek',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Text(
                        'Flat ₹500 off',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 5,
                ),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Icon(
                      Icons.star,
                      color:  Color(0xFFFFB755),
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color:  Color(0xFFFFB755),
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFB755),
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFB755),
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFB755),
                      size: 16,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Color(0xFFFFB755),
                      size: 13,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        '6 days',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      '₹12,499',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2.5,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '₹11,999',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    const Spacer(),
                    const ViewMoreButton(),
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
