import 'package:flutter/material.dart';

class ExFiltersDrawer extends StatelessWidget {
  final bool isConditions;

  const ExFiltersDrawer({Key? key, this.isConditions = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close_rounded,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "FILTERS",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(letterSpacing: 2),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (!isConditions)
          const DropdownContainer(
            title: "Body Parts",
            icon: Icons.boy,
          ),
        const SizedBox(
          height: 20,
        ),
        if (!isConditions)
          const DropdownContainer(
            title: "Positions",
            icon: Icons.line_axis,
          ),
        const SizedBox(
          height: 20,
        ),
        const DropdownContainer(
          title: "Excercise Type",
          icon: Icons.bolt,
        ),
        const SizedBox(
          height: 20,
        ),
        if (!isConditions)
          const DropdownContainer(
            title: "Equipment",
            icon: Icons.home_repair_service,
          ),
        const SizedBox(
          height: 20,
        ),
        if (isConditions)
          const DropdownContainer(
            title: "Level",
            icon: Icons.home_repair_service,
          ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10,
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Clear Filters"),
          ),
        ),
      ],
    );
  }
}

class DropdownContainer extends StatefulWidget {
  const DropdownContainer({Key? key, required this.title, required this.icon})
      : super(key: key);
  final String? title;
  final IconData? icon;

  @override
  State<DropdownContainer> createState() => _DropdownContainerState();
}

class _DropdownContainerState extends State<DropdownContainer> {
  bool _onClick = false;
  bool rememberMe = false;
  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;

        if (rememberMe) {
        } else {
        }
      });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      widget.icon!,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title!,
                          style: Theme.of(context).textTheme.labelLarge!,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            IconButton(
              splashRadius: 25,
              onPressed: () {
                setState(() {
                  _onClick = !_onClick;
                });
              },
              icon: Icon(
                _onClick ? Icons.arrow_drop_down_sharp : Icons.arrow_left,
                size: 30,
              ),
            ),
          ],
        ),
        if (!_onClick)
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              "2 Filters Selected",
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ),
        if (_onClick)
          Container(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              children: [
                CheckboxListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text("Neck"),
                    value: rememberMe,
                    onChanged: (value) {
                      _onRememberMeChanged(value!);
                    }),
                CheckboxListTile(
                    title: const Text("Mid Back"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    value: rememberMe,
                    onChanged: (value) {
                      _onRememberMeChanged(value!);
                    }),
                CheckboxListTile(
                    title: const Text("Low Back"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    value: rememberMe,
                    onChanged: (value) {
                      _onRememberMeChanged(value!);
                    })
              ],
            ),
          )
      ],
    );
  }
}
