import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

Map<String, String> mapData = {
  "firstName": "",
  "lastName": "",
  "phoneNo": "",
  "emailId": "",
  "address": "",
  "issue": "",
};

void saveFirstName(String fName) => mapData['firstName'] = fName;
void saveLastName(String lName) => mapData['lastName'] = lName;
void savePhoneNo(String phNo) => mapData['phoneNo'] = phNo;
void saveEmailId(String email) => mapData['emailId'] = email;
void saveAddress(String addrs) => mapData['address'] = addrs;
void saveIssue(String userIssue) => mapData['issue'] = userIssue;

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Support',
         
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'First Name',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const FirstNameField(getValue: saveFirstName),
                    ],
                  ),
                  const SizedBox(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Last Name',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const LastNameField(getValue: saveLastName),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const PhoneNumberField(getValue: savePhoneNo),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const EmailField(getValue: saveEmailId),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const AddressField(getValue: saveAddress),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explain your issue',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const IssueField(
                        getValue: saveIssue,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 58),
                child: SaveButton(
                  isLoading: false,
                  submit: () {},
                  title: "Save",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
