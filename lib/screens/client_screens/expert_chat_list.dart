import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ExpertsChatList extends StatefulWidget {
  const ExpertsChatList({Key? key}) : super(key: key);

  @override
  State<ExpertsChatList> createState() => _ExpertsChatListState();
}

class _ExpertsChatListState extends State<ExpertsChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Chats'),
      body: ZIMKitConversationListView(
        onPressed: (context,conversation,defaultAction){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ZIMKitMessageListPage(
              conversationID: conversation.id,
              conversationType: conversation.type,
            );
          }));
        },
      ),
    );
  }
}
