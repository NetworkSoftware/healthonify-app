
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class NextWorkout extends StatelessWidget {
  const NextWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
         
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Next Exercise',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '0:46',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1559166631-ef208440c75a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                    height: 86,
                    width: 86,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'Spot Marching',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '10 reps, 1 set',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * 0.75,
            color: const Color(0xFF707070).withOpacity(0.15),
          ),
          const SizedBox(height: 42),
          Text(
            'Take some rest',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            '10',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 138),
                    FloatingActionButton(
                      heroTag: 'stop-btn',
                      onPressed: () {},
                      backgroundColor: const Color(0xFFFBFBFB),
                      mini: true,
                      child: const Icon(
                        Icons.stop,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton(
                      heroTag: 'play-btn',
                      onPressed: () {},
                      backgroundColor: const Color(0xFFE9BE0C),
                      child: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton(
                      heroTag: 'next-btn',
                      onPressed: () {},
                      backgroundColor: const Color(0xFFFBFBFB),
                      mini: true,
                      child: const Icon(
                        Icons.skip_next,
                        color: Color(0xFFE9BE0C),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'NEXT',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
