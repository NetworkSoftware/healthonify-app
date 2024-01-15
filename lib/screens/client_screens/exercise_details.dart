import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  const ExerciseDetailScreen({
    required this.title,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? dropDownValue1;
    String? dropDownValue2;
    List dropDownOptions1 = [
      'Warm up',
      'Round 1',
      'Round 2',
      'Round 3',
      'Round 4',
      'Round 5',
      'Round 6',
      'Round 7',
      'Round 8',
      'Round 9',
      'Round 10',
      'Round 11',
      'Round 12',
      'Round 13',
      'Round 14',
      'Round 15',
    ];
    List dropDownOptions2 = [
      'Weight and Reps',
      'Time and Distance',
      'Only Reps',
      'Only Time',
      'Exercise Name and Reps',
      'Exercise Name and Time',
      'Exercise Name, Reps and Time',
      'No set applicable',
      'Distance, Speed and Sets',
      'Time, Speed and Sets',
      'Distance, Time, Speed and Sets',
    ];
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: title),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                category,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            textFields(context, 'Sequence of exercise'),
            StatefulBuilder(
              builder: (context, newState) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField(
                  isDense: true,
                  items:
                      dropDownOptions1.map<DropdownMenuItem<String>>((value) {
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
                      dropDownValue1 = newValue!;
                    });
                  },
                  value: dropDownValue1,
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
                    'Select a group (optional)',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            StatefulBuilder(
              builder: (context, newState) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField(
                  isDense: true,
                  items:
                      dropDownOptions2.map<DropdownMenuItem<String>>((value) {
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
                      dropDownValue2 = newValue!;
                    });
                  },
                  value: dropDownValue2,
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
                    'Select Set Type',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
            statsCard(context),
            textFields(context, 'Add note'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            const snackBar = SnackBar(
              content: Text('A new exercise has been added!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Text(
            'SUBMIT',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  Widget statsCard(context) {
    String? dropdownValue;
    List dropDownOptions = [
      'kgs',
      'lbs',
    ];
    return StatefulBuilder(
      builder: (context, thisState) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          // key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: grey,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(10),
                  //   topRight: Radius.circular(10),
                  // ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('Set'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('Weight'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text('unit'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('Reps'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('+/-'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(10),
                  //   bottomRight: Radius.circular(10),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        List itemNo = [
                          '1.',
                          '2.',
                          '3.',
                        ];
                        return Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(itemNo[index]),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 36,
                                        maxWidth: 52,
                                      ),
                                      hintText: '0',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF959EAD),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownButtonFormField(
                                      isDense: true,
                                      items: dropDownOptions
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        thisState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      value: dropdownValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.25,
                                          ),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxHeight: 36,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      hint: Text(
                                        'kgs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 36,
                                        maxWidth: 52,
                                      ),
                                      hintText: '0',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF959EAD),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // log('tapped');
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 26,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Add set'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFields(context, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: darkGrey,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
      ),
    );
  }
}
