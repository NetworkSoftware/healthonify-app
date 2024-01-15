import 'package:flutter/material.dart';

class ChangeGoalCard extends StatelessWidget {
  final IconData icon;
  final Function onClick;
  const ChangeGoalCard({Key? key, required this.icon, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () => onClick(),
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFA2D3F4),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Change your goal',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF717579),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
