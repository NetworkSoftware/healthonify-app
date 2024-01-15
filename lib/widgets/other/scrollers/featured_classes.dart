import 'package:flutter/material.dart';

class Hscroller extends StatelessWidget {
  final String imgUrl;
  final String cardTitle;
  final String scrollerTitle;
  final Function onTouch;
  const Hscroller({
    required this.cardTitle,
    required this.imgUrl,
    required this.scrollerTitle,
    required this.onTouch,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Text(
            scrollerTitle,
            style: Theme.of(context).textTheme.headlineSmall,
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
                          onTouch();
                        },
                        child: Image.network(
                          imgUrl,
                          height: 110,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      cardTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
