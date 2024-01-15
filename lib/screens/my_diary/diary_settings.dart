import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/sharing&privacy/sharingandprivacy.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/my_goals/my_goals.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/reminders_screen.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/fitness_form_fields.dart';

class DiarySettingsScreen extends StatefulWidget {
  const DiarySettingsScreen({Key? key}) : super(key: key);

  @override
  State<DiarySettingsScreen> createState() => _DiarySettingsScreenState();
}

class _DiarySettingsScreenState extends State<DiarySettingsScreen>
    with TickerProviderStateMixin {
  String? selectedValue;
  String? selectedValue2;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Diary Settings',
        bottomWidget: ColoredBox(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          child: customTabBar(
            context,
            tabController,
          ),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              page1(),
              page2(),
            ],
          ),
        ),
      ),
    );
  }

  Widget page1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CheckListTile2(checkTitle: 'Show diary food insights'),
        const CheckListTile2(checkTitle: 'Always show water in diary'),
        ListTile(
          title: Text(
            'Diary Sharing',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: StatefulBuilder(
              builder: (context, newState) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: diarySharingOptions
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    newState(() {
                      selectedValue = newValue!;
                    });
                  },
                  value: selectedValue,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Choose an option',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey[700]),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Search settings',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        ListTile(
          title: Text(
            'Default Search Tabs',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: StatefulBuilder(
              builder: (context, newState) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items:
                      searchTabOptions.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    newState(() {
                      selectedValue2 = newValue!;
                    });
                  },
                  value: selectedValue2,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Choose an option',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
        const CheckListTile2(checkTitle: 'Show all foods in lists'),
        Divider(color: Colors.grey[700]),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Goals',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MyGoalsScreen();
            }));
          },
          title: Text(
            'Edit Goals',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Divider(color: Colors.grey[700]),
      ],
    );
  }

  Widget page2() {
    return const RemindersScreen();
    // return const MealReminders(hideAppbar: true);
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Diary'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Reminders'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: orange,
        indicatorWeight: 2.5,
      );
}
