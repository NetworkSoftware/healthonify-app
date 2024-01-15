import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class DoctorsPrescriptionScreen extends StatelessWidget {
  const DoctorsPrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Doctor's Prescription"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Latest Prescription',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            clickableCard(context, 'prescription.pdf', () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Other Uploads',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text('09/07/2022'),
                      ),
                      Expanded(
                        flex: 2,
                        child: clickableCard(
                          context,
                          'other_prscrp.pdf',
                          () {},
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clickableCard(context, String cardName, Function onTapped) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        child: InkWell(
          onTap: () {
            onTapped();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(cardName),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
