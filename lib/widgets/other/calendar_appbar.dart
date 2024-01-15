import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalendarAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(148.0);

  @override
  State<CalendarAppBar> createState() => _CalendarAppBarState();
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 148.0,
      elevation: 2,
      title: const Column(
        children: [
          CustomAppBar(
            appBarTitle: 'Workout',
          ),
          SizedBox(height: 8.0),
          HorizCalendar(),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}

class HorizCalendar extends StatefulWidget {
  final Function? function;
  const HorizCalendar({this.function, Key? key}) : super(key: key);

  @override
  State<HorizCalendar> createState() => _HorizCalendarState();
}

class _HorizCalendarState extends State<HorizCalendar> {
  int monthDuration = 30;
  int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime minimumDate;

  late String cDate;
  late String lastDate;

  List dietMonth = [];

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    cDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    lastDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(Duration(days: monthDuration)));

    DateTime currentDate = DateFormat('dd/MM/yyyy').parse(cDate);
    DateTime lastMonthDate = DateFormat('dd/MM/yyyy').parse(lastDate);

    dietMonth.add(currentDate);
    while (lastMonthDate.isBefore(currentDate)) {
      currentDate = currentDate.subtract(const Duration(days: 1));
      dietMonth.add(currentDate);
    }

    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemCount: dietMonth.length,
        itemBuilder: (context, index) {
          final dayName = DateFormat('E').format(dietMonth[index]);
          final dates = DateFormat('d').format(dietMonth[index]);
          return weekDay(index, dayName, dates, dietMonth[index]);
        },
      ),
    );
  }

  Widget weekDay(
      int listIndex, String dayName, String dates, DateTime datetime) {
    return Padding(
      padding: EdgeInsets.only(right: listIndex == 0 ? 16.0 : 0.0, left: 24.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = listIndex;
          });
          String clickDate = DateFormat('yyyy/MM/dd').format(datetime);
          widget.function!(clickDate);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedIndex == listIndex ? orange : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                dayName.substring(0, 1),
                style: TextStyle(
                  fontSize: 20,
                  color: selectedIndex == listIndex ? whiteColor : orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dates,
              style: const TextStyle(
                fontSize: 14,
                color: orange,
                // color: selectedIndex == listIndex
                //     ? MediaQuery.of(context).platformBrightness ==
                //             Brightness.dark
                //         ? orange
                //         : orange
                //     : orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 2.5,
              width: 28.0,
              color: selectedIndex == listIndex ? orange : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
