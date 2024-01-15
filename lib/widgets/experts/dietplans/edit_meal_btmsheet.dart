import 'package:flutter/material.dart';

class EditMealBtmSheet extends StatelessWidget {
  const EditMealBtmSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Food name',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
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
                ],
              ),
              Text(
                'Category : vegetables',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Food sub-type :  raw',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
                    '32 kCal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Divider(),
              Text(
                'Enter food consumption quantity',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFC3CAD9),
                          ),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 38,
                          maxWidth: 100,
                        ),
                        hintText: 'Quantity',
                        hintStyle: const TextStyle(
                          color: Color(0xFF959EAD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        return null;
                      },
                    ),
                    Text(
                      'grams',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'Nutritional Information',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              nutrientInfo(Colors.red, 'Protiens', 1.8),
              nutrientInfo(Colors.green, 'Carbs', 7.0),
              nutrientInfo(Colors.blue, 'Fats', 2.4),
              nutrientInfo(Colors.yellow, 'Fibers', 0.5),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ),
            ],
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
