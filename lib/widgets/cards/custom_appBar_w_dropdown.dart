import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/drop_down_button.dart';

class CustomAppBarwDropDown extends StatefulWidget
    implements PreferredSizeWidget {
  final String appBarTitle;

  const CustomAppBarwDropDown({Key? key, required this.appBarTitle})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  State<CustomAppBarwDropDown> createState() => _CustomAppBarwDropDownState();
}

class _CustomAppBarwDropDownState extends State<CustomAppBarwDropDown> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.appBarTitle,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.chevron_left_rounded,
          color: Theme.of(context).colorScheme.onBackground,
          size: 40,
        ),
      ),
      actions: const [
        CustomDropDownButton(),
      ],
      shadowColor: Colors.transparent,
    );
  }
}
