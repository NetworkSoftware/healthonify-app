import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FitnessCenterNearmeButton extends StatelessWidget {
  const FitnessCenterNearmeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Card(
          child: InkWell(
            onTap: () async {
              await launchUrl(
                Uri.parse(
                  'https://healthonify.com/fitness',
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Fitness Centers Near me',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.asset(
                      'assets/icons/near-me.png',
                      height: 22,
                      width: 22,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 32,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
