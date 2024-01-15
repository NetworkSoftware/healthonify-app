import 'dart:developer';
import 'package:flutter/material.dart';

class AddClientDialog extends StatelessWidget {
  final Function onNextClick;
  const AddClientDialog({Key? key, required this.onNextClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: SizedBox(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 40,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          SizedBox(
            width: 170,
            child: Text(
              "Enter your client's mobile number",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "+91",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    hintText: "Mobile Number",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please input a mobile number";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    log(value.toString());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("OR"),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {}, child: const Text("Pick from Contacts")),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onNextClick();
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
