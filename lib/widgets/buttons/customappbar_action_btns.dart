import 'package:flutter/material.dart';

class CustomAppBarTextBtn extends StatelessWidget {
  final String? title;
  final Function? onClick;
  const CustomAppBarTextBtn(
      {Key? key, required this.title, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10),
      child: TextButton(
        child: Text(
          title!,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        onPressed: () {
          onClick!();
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => const EditRecipe()));
        },
      ),
    );
  }
}

class CustomAppBarTextBtnWithIcon extends StatelessWidget {
  final String? title;
  final Function? onClick;
  const CustomAppBarTextBtnWithIcon(
      {Key? key, required this.title, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10),
      child: TextButton(
        child: Text(title!),
        onPressed: () {
          onClick!();
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => const EditRecipe()));
        },
      ),
    );
  }
}
