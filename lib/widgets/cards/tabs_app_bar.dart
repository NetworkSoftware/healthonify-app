import 'package:flutter/material.dart';

class TabsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tabAppBarTitle;

  const TabsAppBar({Key? key, required this.tabAppBarTitle}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(115.0);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          title: Text(
            tabAppBarTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.grey,
              size: 40,
            ),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          bottom: TabBar(
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Domestic',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'International',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Wellness',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            indicatorColor: const Color(0xFFff7f3f),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.5,
          ),
        ),
      ],
    );
  }
}
