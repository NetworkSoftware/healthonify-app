import 'package:flutter/material.dart';

class BmiAgeCard extends StatefulWidget {
  final Function? getAge;
  const BmiAgeCard({Key? key, required this.getAge}) : super(key: key);

  @override
  State<BmiAgeCard> createState() => _BmiAgeCardState();
}

class _BmiAgeCardState extends State<BmiAgeCard> {
  TextEditingController ageController = TextEditingController(text: "18");
  int _age = 18;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 184,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Age',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextFormField(
              controller: ageController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Theme.of(context).canvasColor,
                filled: true,
              ),
              style: Theme.of(context).textTheme.titleMedium,
              onChanged: (value) {
                if (value.isEmpty) {
                  widget.getAge!("0.0");
                  _age = int.parse("0");
                  return;
                }

                widget.getAge!(value);
                _age = int.parse(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (_age <= 0) {
                      return;
                    }
                    setState(() {
                      _age--;
                    });
                    widget.getAge!(_age.toString());
                    ageController.value = TextEditingValue(text: "$_age");
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.remove_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    setState(() {
                      _age++;
                    });
                    widget.getAge!(_age.toString());
                    ageController.value = TextEditingValue(text: "$_age");
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.add_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
