import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/physio/expert_view_physio_consultations.dart';

class PatientsCard extends StatelessWidget {
  final String patientName;
  final String patientEmail;
  final String patientContact;
  final String location;
  final String imageUrl;
  final String clientId;

  const PatientsCard({
    Key? key,
    required this.patientName,
    required this.patientEmail,
    required this.patientContact,
    required this.location,
    required this.imageUrl,
    required this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34),
      ),
      shadowColor: const Color(0xFF000029),
      child: SizedBox(
        child: InkWell(
          borderRadius: BorderRadius.circular(34),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExpertViewPhysioConsultations(
                clientID: clientId,
              ),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFff7f3f),
                      radius: 51,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 48,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: imageUrl.isEmpty
                              ? const AssetImage(
                                  "assets/icons/user.png",
                                ) as ImageProvider
                              : NetworkImage(
                                  imageUrl,
                                ),
                          radius: 45,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFff7f3f),
                        radius: 17,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.pin_drop_outlined,
                            color: Color(0xFFff7f3f),
                            size: 22,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          location,
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
      ),
    );
  }
}
