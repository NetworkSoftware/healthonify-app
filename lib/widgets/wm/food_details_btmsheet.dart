import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';

class FoodDetailsBtmSheet extends StatefulWidget {
  final Dishes foodData;
  const FoodDetailsBtmSheet({Key? key, required this.foodData})
      : super(key: key);

  @override
  State<FoodDetailsBtmSheet> createState() => _FoodDetailsBtmSheetState();
}

class _FoodDetailsBtmSheetState extends State<FoodDetailsBtmSheet> {
  double totalCalories = 0.0;
  double? foodCalorieValue = 0.0;
  String? unit, foodQuantity;

  double quantity = 0;

  void calculateCalories(double quantity) {
    double temp = foodCalorieValue! * quantity;

    totalCalories = temp;

    setState(() {});
  }

  Future<void> onSubmit() async {
    if (quantity == 0) {
      Fluttertoast.showToast(msg: "Please enter some quantity");
      return;
    }
    CreateDietDish dish = CreateDietDish(
      dishId: widget.foodData.id,
      unit: widget.foodData.perUnit!.quantity,
      quantity: quantity,
      nutrition: widget.foodData.nutrition,
      alternateFood: [],
      name: widget.foodData.name,
      perUnit: widget.foodData.perUnit,
    );

    Navigator.of(context).pop();
    Navigator.of(context).pop(dish);
  }

  @override
  void initState() {
    super.initState();
    foodCalorieValue = widget.foodData.perUnit!.calories;
    unit =
        "${widget.foodData.perUnit!.quantity!} (${widget.foodData.perUnit!.weight!})";
    foodQuantity = " ${widget.foodData.perUnit!.weight}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: FractionallySizedBox(
        heightFactor: 0.95,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        widget.foodData.name ?? "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 28,
                        ),
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Type : ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant_menu_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Calories: $foodCalorieValue kcal  /  Quantity: $foodQuantity",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
                const Divider(),
                Image.asset(
                  "assets/images/dish.png",
                  height: 70,
                ),
                // no more medialink
                // CachedNetworkImage(
                //   imageUrl: widget.foodData.mediaLink!,
                //   memCacheHeight: 250,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                //   errorWidget: (context, url, error) => const SizedBox(
                //     height: 10,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter food consumption quantity',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              // initialValue: "1",
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC3CAD9),
                                  ),
                                ),
                                hintText: 'Enter your quantity',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF959EAD),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  value = "0";
                                  quantity = 0;
                                }
                                if (value.length > 5) {
                                  Fluttertoast.showToast(
                                    msg: 'Quantity can contain only 2 decimals',
                                  );
                                  return;
                                }
                                log(value);
                                quantity = double.parse(value);
                                calculateCalories(double.parse(value));
                              },
                              onSaved: (value) {},
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 5),
                            child: Text(
                              unit ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (totalCalories != 0.0) Text("$totalCalories Kcal"),
                    ],
                  ),
                ),
                const Divider(),
                Text(
                  'Nutritional Information',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 10),

                nutrientInfo(Colors.red, "Proteins",
                    widget.foodData.nutritionInGm!.proteins! ?? 0.0),
                nutrientInfo(Colors.red, "Carbs",
                    widget.foodData.nutritionInGm!.carbs! ?? 0.0),
                nutrientInfo(Colors.red, "Fats",
                    widget.foodData.nutritionInGm!.fats! ?? 0.0),
                nutrientInfo(Colors.red, "Fiber",
                    double.parse(widget.foodData.nutritionInGm!.fiber!.toString()) ?? 0),

                // nutrientInfo(Colors.red, "Proteins",
                //     widget.foodData.nutrition![0].proteins!.quantity ?? 0.0),
                // nutrientInfo(Colors.red, "Carbs",
                //     widget.foodData.nutrition![0].carbs!.quantity ?? 0.0),
                // nutrientInfo(Colors.red, "Fats",
                //     widget.foodData.nutrition![0].fats!.quantity ?? 0.0),
                // nutrientInfo(Colors.red, "Fiber",
                //     widget.foodData.nutrition![0].fiber!.quantity ?? 0.0),

                // ListView.builder(
                //   physics: const NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: widget.foodData.nutrition!.length,
                //   itemBuilder: (context, index) => nutrientInfo(
                //       ,
                //       widget.foodData.nutrition![index].name ?? "",
                //       widget.foodData.nutrition![index].quantity ?? 0.0),
                // ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nutrientInfo(
    Color nutrientColor,
    String nutrientName,
    double nutrientQty,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: nutrientColor,
            radius: 6,
          ),
          const SizedBox(width: 10),
          Text(nutrientName),
          const Spacer(),
          Text('$nutrientQty gms'),
        ],
      ),
    );
  }
}

class DropDownFld extends StatefulWidget {
  const DropDownFld({Key? key}) : super(key: key);

  @override
  State<DropDownFld> createState() => _DropDownFldState();
}

class _DropDownFldState extends State<DropDownFld> {
  String? dropdownValue;
  List<String> dropDownOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'General',
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: dropDownOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      value: dropdownValue,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.25,
          ),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
      ),
      isExpanded: true,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      hint: const Text('Fitness Level'),
      onSaved: (value) {},
    );
  }
}
