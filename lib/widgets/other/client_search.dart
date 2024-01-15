// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';

class ClientSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 56,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            filled: false,
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: whiteColor,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: grey,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'Search clients',
            hintStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          style: Theme.of(context).textTheme.bodySmall,
          onChanged: (value) {},
        ),
      ),
    );
  }
}
