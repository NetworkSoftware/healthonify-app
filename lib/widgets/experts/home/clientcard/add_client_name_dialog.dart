import 'dart:developer';

import 'package:flutter/material.dart';

class AddClientNameDialog extends StatelessWidget {
  final Function onConnectClick;
  const AddClientNameDialog({Key? key, required this.onConnectClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
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
              "Enter your client's Name",
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
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please input your name";
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
                  onConnectClick();
                },
                child: const Text("Connect"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
