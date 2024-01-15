import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final Widget? widgetRight;
  final Widget? actionWIdget2;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.appBarTitle,
    this.widgetRight = const Text(''),
    this.actionWIdget2 = const Text(''),
    this.leading,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // elevation: 5,
      backgroundColor: orange,
      title: Text(
        appBarTitle,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: whiteColor),
      ),
      actions: [
        widgetRight!,
        actionWIdget2!,
      ],
      leading: leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context,true);
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              //color: Theme.of(context).colorScheme.onBackground,
              color: whiteColor,
              size: 40,
            ),
            splashRadius: 20,
          ),
      // backgroundColor: Color(0xFFF6F6F6),
      // backgroundColor: whiteColor,
      shadowColor: Colors.transparent,
    );
  }
}

class CustomEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarTitle;
  final Function onSubmit;
  final bool isLoading;

  const CustomEditAppBar(
      {Key? key,
      required this.appBarTitle,
      required this.onSubmit,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        appBarTitle!,
        style: Theme.of(context).textTheme.headlineMedium,
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
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: isLoading ? null : () => onSubmit(),
            style: ElevatedButton.styleFrom(
              backgroundColor: whiteColor,
            ),
            child: Text(
              'Done',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: orange,
                  ),
            ),
          ),
        ),
        // TextButton(
        //   onPressed: isLoading ? null : () => onSubmit(),
        //   child: Text(
        //     "Done",
        //     style: Theme.of(context).textTheme.labelMedium!.copyWith(
        //           color: Theme.of(context) == MyTheme.lightTheme
        //               ? whiteColor
        //               : orange,
        //         ),
        //   ),
        // ),
      ],
      // backgroundColor: Color(0xFFF6F6F6),
      shadowColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class CustomAddPackageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? appBarTitle;
  final Function onSubmit;

  const CustomAddPackageAppBar({
    Key? key,
    required this.appBarTitle,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        appBarTitle!,
        style: Theme.of(context).textTheme.headlineMedium,
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
      actions: [
        TextButton(
          onPressed: () => onSubmit(),
          child: const Text("Add new package"),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class FlexibleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget listItems;
  const FlexibleAppBar({
    required this.title,
    required this.listItems,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: SliverAppBar(
        pinned: true,
        floating: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Theme.of(context).colorScheme.onBackground,
            size: 36,
          ),
          splashRadius: 20,
        ),
        title: Text(
          title!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Theme.of(context).canvasColor,
            child: listItems,
          ),
        ),
      ),
    );
  }
}
