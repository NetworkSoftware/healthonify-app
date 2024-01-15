// import 'dart:developer';
//
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:healthonify_mobile/screens/video_call.dart';
// import 'package:sendbird_sdk/sendbird_sdk.dart';
//
// class ExpertChatScreen extends StatefulWidget {
//   static const routeName = "/chat-screen";
//   final String userID;
//   final String otherUserId;
//   final String consultationId;
//
//   const ExpertChatScreen({
//     Key? key,
//     required this.userID,
//     required this.otherUserId,
//     required this.consultationId,
//   }) : super(key: key);
//
//   @override
//   State<ExpertChatScreen> createState() => _ExpertChatScreenState();
// }
//
// class _ExpertChatScreenState extends State<ExpertChatScreen>
//     with ChannelEventHandler {
//   String? appID = "D8FAAD78-0DEA-4246-AC05-5F25D0E11926";
//   ScrollController? _scrollController;
//
//   var _isLoading = false;
//
//   List<BaseMessage> _messages = [];
//   GroupChannel? _channel;
//
//   @override
//   void initState() {
//     super.initState();
//     load();
//     SendbirdSdk().addChannelEventHandler("dashChat", this);
//     _scrollController = ScrollController();
//     _scrollController!.addListener(() {
//       log(_scrollController!.position.pixels.toString());
//       if (_scrollController!.position.pixels ==
//           _scrollController!.position.maxScrollExtent - 10) {
//         log("hey");
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     SendbirdSdk().removeChannelEventHandler("dashChat");
//   }
//
//   @override
//   void onMessageReceived(BaseChannel channel, BaseMessage message) {
//     super.onMessageReceived(channel, message);
//     setState(() {
//       _messages.add(message);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // data.User userData = Provider.of<UserData>(context).userData;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chat with expert"),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : DashChat(
//               currentUser: asDashChatUser(SendbirdSdk().currentUser),
//               onSend: (ChatMessage newMessage) {
//                 final sendMessage =
//                     _channel!.sendUserMessageWithText(newMessage.text);
//                 setState(() {
//                   _messages.add(sendMessage);
//                 });
//               },
//               messages: asDashChatMessages(_messages),
//             ),
//     );
//   }
//
//   ChatUser asDashChatUser(User? user) {
//     if (user == null) {
//       return ChatUser(
//         id: '',
//         firstName: '',
//         // lastName: '',
//         profileImage: '',
//       );
//     }
//     return ChatUser(
//       id: user.userId,
//       // ignore: prefer_if_null_operators, unnecessary_null_comparison
//       firstName: user.nickname != null ? user.nickname : "",
//       profileImage: user.profileUrl != null
//           ? "https://yt3.ggpht.com/ytc/AKedOLSlIHgNQfhLWcv2RqNrIWRFP2NvCxgHizqiBqr-Acg=s900-c-k-c0x00ffffff-no-rj"
//           : "",
//     );
//   }
//
//   List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
//     return [
//       for (BaseMessage sbm in messages)
//         ChatMessage(
//             text: sbm.message,
//             user: asDashChatUser(sbm.sender),
//             createdAt: DateTime.now())
//     ];
//   }
//
//   void load() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       //init sendbird
//       final sendBird = SendbirdSdk(appId: appID);
//       final _ = await sendBird.connect(widget.userID);
//
//       //get prev channel
//       final query = GroupChannelListQuery()
//             ..limit = 1
//             ..userIdsExactlyIn = [widget.otherUserId]
//           //
//           ;
//
//       List<GroupChannel> channels = await query.loadNext();
//
//       if (channels.isEmpty) {
//         //create new channel
//         _channel = await GroupChannel.createChannel(
//           GroupChannelParams()..userIds = [widget.otherUserId, widget.userID],
//         );
//       } else {
//         _channel = channels[0];
//       }
//
//       log(_channel!.channelUrl.toString());
//
//       log((DateTime.now().millisecondsSinceEpoch).toString());
//
//       List<BaseMessage> messages = await _channel!.getMessagesByTimestamp(
//           DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
//
//       //  set the data
//
//       setState(() {
//         _messages = messages;
//
//         for (var element in _messages) {
//           log(element.message);
//         }
//       });
//     } catch (e) {
//       log(e.toString());
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }
