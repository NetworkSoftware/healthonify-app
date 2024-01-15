import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class ExpertHomeCards extends StatelessWidget {
  final String cardTitle;
  final String cardSubTitle;
  final String imagePath;
  final Function onPress;

  const ExpertHomeCards({
    Key? key,
    required this.cardTitle,
    required this.cardSubTitle,
    required this.imagePath,
    required this.onPress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xFF001d74),
              Color(0xFFf06900),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1],
          )),
          child: InkWell(
            onTap: () => onPress(context),
            borderRadius: BorderRadius.circular(13),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 10),
                  Image.asset(
                    imagePath,
                    width: 46,
                  ),
                  // const SizedBox(height: 6),
                  Text(
                    cardTitle,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: whiteColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 8),
                  //   child: Text(
                  //     cardSubTitle,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodySmall!
                  //         .copyWith(color: whiteColor),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
