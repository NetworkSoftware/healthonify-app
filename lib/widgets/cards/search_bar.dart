import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function? getValue;
  const CustomSearchBar({Key? key, this.getValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        textInputAction: TextInputAction.search,
        onChanged: (String v) => getValue!(v),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black87,
            ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF717579),
          ),
          constraints: const BoxConstraints(
            maxHeight: 56,
          ),
          fillColor: const Color(0xFFE3E3E3),
          filled: true,
          hintText: 'Search for food',
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFF717579),
            fontFamily: 'OpenSans',
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E3),
            ),
          ),
        ),
      ),
    );
  }
}
