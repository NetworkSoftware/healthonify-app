import 'package:flutter/material.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final Widget? widgetRight;
  final Widget? actionWIdget2;
  final Widget? bottomWidget;

  const TabAppBar({
    Key? key,
    required this.appBarTitle,
    this.widgetRight = const Text(''),
    this.actionWIdget2 = const Text(''),
    this.bottomWidget = const Text(''),
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(96);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // elevation: 5,
      title: Text(
        appBarTitle,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions: [
        widgetRight!,
        actionWIdget2!,
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 40,
        ),
        splashRadius: 20,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: ColoredBox(
          color: Colors.grey[200]!,
          child: bottomWidget!,
        ),
      ),
      // backgroundColor: whiteColor,
      shadowColor: Colors.transparent,
    );
  }
}
