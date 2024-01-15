// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/tabs_app_bar.dart';
import 'package:healthonify_mobile/widgets/cards/tourism_card.dart';

class TourismScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 115,
                child: TabsAppBar(
                  tabAppBarTitle: 'Tourism',
                ),
              ),
              Container(
                height: 1.5,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFEFEFEF),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    AdventureButton(),
                    LeisureButton(),
                  ],
                ),
              ),
              SizedBox(
                height: 1500,
                child: Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return TourismCard();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
