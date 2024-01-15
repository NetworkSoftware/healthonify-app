import 'package:flutter/material.dart';

class DoctorsCard extends StatelessWidget {
  final String patientName;
  final String patientEmail;
  final String patientContact;
  final String patientEmail2;

  const DoctorsCard({
    Key? key,
    required this.patientName,
    required this.patientEmail,
    required this.patientContact,
    required this.patientEmail2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34),
      ),
      elevation: 4,
      shadowColor: const Color(0xFF000029),
      child: SizedBox(
        height: 236,
        width: 366,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFff7f3f),
                    radius: 51,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 48,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1577565177023-d0f29c354b69?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
                        radius: 45,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          patientName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          patientEmail,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFff7f3f),
                      radius: 17,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          Icons.phone,
                          color: Color(0xFFff7f3f),
                          size: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        patientContact,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFff7f3f),
                      radius: 17,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          Icons.email_outlined,
                          color: Color(0xFFff7f3f),
                          size: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        patientEmail2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
