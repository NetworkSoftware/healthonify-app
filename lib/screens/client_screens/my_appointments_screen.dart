import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class MyAppoinmentsScreen extends StatefulWidget {
  const MyAppoinmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppoinmentsScreen> createState() => _MyAppoinmentsScreenState();
}

class _MyAppoinmentsScreenState extends State<MyAppoinmentsScreen> {
  DateTime currentDate = DateTime(2019, 2, 3);
  // DateTime _currentDate2 = DateTime(2019, 2, 3);
  // DateTime _targetDateTime = DateTime(2019, 2, 3);
  // String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Your Appointments',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CalendarCarousel(
                onDayPressed: (DateTime date, List events) {
                  setState(() => currentDate = date);
                },
                todayButtonColor: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointments',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFFff7f3f),
                    ),
                    label: Text(
                      'Request',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'No Appointments found',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
