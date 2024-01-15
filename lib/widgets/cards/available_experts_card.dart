import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/expert.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class AvailableExpertsCard extends StatelessWidget {
  final Expert expertData;
  final String expertiseId;
  const AvailableExpertsCard(
      {Key? key,
      required this.expertData,
      required this.expertiseId,
      required this.func})
      : super(key: key);
  final Function func;

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    double netAmount = double.parse(expertData.consultaionCharge!);
    double amount = netAmount * 100;

    Map<String, dynamic> data = {
      "expertId": expertData.id!,
      "expertiseId": expertiseId,
      "userId": userData.id!,
      "startDate": "",
      "startTime": "",
      "grossAmount": null,
      "discount": null,
      "gstAmount": null,
      "netAmount": netAmount,
      "amount": amount,
      "slotNumber": 1
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        backgroundImage: expertData.imageUrl!.isEmpty
                            ? const AssetImage(
                                "assets/icons/user.png",
                              ) as ImageProvider
                            : NetworkImage(
                                expertData.imageUrl!,
                              ),
                        radius: 46,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Text(
                        "${expertData.firstName} ${expertData.lastName}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 72,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "\u{20B9}${expertData.consultaionCharge!}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          'Cost',
                                          // "Level",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '5',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          'Goal',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '8',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          'Subscription',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Spacer(),
                  SelectButton(
                    func: func,
                    data: data,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
