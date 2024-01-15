import 'package:flutter/material.dart';

class PlanNameTextField extends StatelessWidget {
  const PlanNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: const TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: 'Enter plan name',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class NoOfDays extends StatelessWidget {
  const NoOfDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: const TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: 'Total number of days (Optional)',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class GoalTextField extends StatelessWidget {
  const GoalTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: const TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: 'Enter your goal',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class LevelTextField extends StatelessWidget {
  const LevelTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: const TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: 'Assign workout level',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class DurationTextField extends StatelessWidget {
  const DurationTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: const TextField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: 'Duration of workout',
          hintStyle: TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
