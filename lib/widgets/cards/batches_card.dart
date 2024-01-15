import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/batches/join_batches.dart';

class BatchesCard extends StatelessWidget {
  const BatchesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Batches',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const JoinBatchScreen();
                      }));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.orange,
                    ),
                    label: Text(
                      'View Batch',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'You are yet to join a batch',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
