// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:healthonify_mobile/providers/user_data.dart';
// import 'package:omni_jitsi_meet/feature_flag/feature_flag.dart';
// import 'package:omni_jitsi_meet/jitsi_meet.dart';
//
// // import 'package:jitsi_meet/feature_flag/feature_flag.dart';
// // import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:provider/provider.dart';
//
// class VideoCall extends StatelessWidget {
//   final String? meetingId;
//   final Function onVideoCallEnds;
//
//   VideoCall({Key? key, required this.onVideoCallEnds, this.meetingId})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     log(meetingId!);
//     var data = Provider.of<UserData>(context).userData;
//     _joinMeeting(meetingId!, data.firstName!, context);
//     return const Scaffold();
//   }
//
//   _joinMeeting(String id, String name, BuildContext context) async {
//     log(id);
//     log("joined here");
//     try {
//       final featureFlags = {
//         FeatureFlagEnum.LOBBY_MODE_ENABLED: false,
//         FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//       };
//
//       FeatureFlag featureFlag = FeatureFlag();
//       featureFlag.lobbyModeEnabled = false;
//
//       // featureFlag.resolution = FeatureFlagVideoResolution
//       //     .MD_RESOLUTION; // Limit video resolution to 360p
//
//       var options = JitsiMeetingOptions(
//          // room: "vpaas-magic-cookie-e2ef29f92faf472fbbe631e444c33f87",
//           room: meetingId!,
//           // serverURL: "https://meet.jit.si/",
//           serverURL:
//               "https://8x8.vc",
//           subject: "Meeting with Expert",
//           userDisplayName: name,
//           token: "eyJraWQiOiJ2cGFhcy1tYWdpYy1jb29raWUtZTJlZjI5ZjkyZmFmNDcyZmJiZTYzMWU0NDRjMzNmODcvZWU0ZjkyLVNBTVBMRV9BUFAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJqaXRzaSIsImlzcyI6ImNoYXQiLCJpYXQiOjE2OTcxNzMxMTAsImV4cCI6MTY5NzE4MDMxMCwibmJmIjoxNjk3MTczMTA1LCJzdWIiOiJ2cGFhcy1tYWdpYy1jb29raWUtZTJlZjI5ZjkyZmFmNDcyZmJiZTYzMWU0NDRjMzNmODciLCJjb250ZXh0Ijp7ImZlYXR1cmVzIjp7ImxpdmVzdHJlYW1pbmciOnRydWUsIm91dGJvdW5kLWNhbGwiOnRydWUsInNpcC1vdXRib3VuZC1jYWxsIjpmYWxzZSwidHJhbnNjcmlwdGlvbiI6dHJ1ZSwicmVjb3JkaW5nIjp0cnVlfSwidXNlciI6eyJoaWRkZW4tZnJvbS1yZWNvcmRlciI6ZmFsc2UsIm1vZGVyYXRvciI6dHJ1ZSwibmFtZSI6InNlcnZlciIsImlkIjoiYXV0aDB8NjM2YTMwYzJjODlkMGJkMTFkMDZjMjhjIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJzZXJ2ZXJAaGVhbHRob25pZnkuY29tIn19LCJyb29tIjoiKiJ9.LZJVWpPtRUkjgfl7ABWAvWVdwRoIXzGFiNGlE03DxY7cD5_qjP-CWXjx-jvplD2MKWtRVE9mRv-_7iEz9kxsXI-TkXwKiwJXstSsk1G-rfBxZANRsctlSLJE7-r-L0wyDcgcN24HM5M4u-LKn_XpD8r0MABOKLfr2RCe-vv_1Lla-cOYJhOZayYGotpHASE6T0BYkg0X4h2y-qwDLT-E6gEXfSPNDj5DJnIoEUn8TTQRl5mPRw-KNro-oQ91sLXkE9_9iooqclAr_xDkD0314wWEkxw2cqhUK57NPkGoori9vC8Rs3gAcmulfr4IgwySI0nAMZQeG8U31b_V9HszPw",
//           userAvatarURL: "",
//           audioMuted: true,
//           featureFlags: featureFlags);
//
//       print("Options meet: $meetingId");
//       try {
//         var _ = await JitsiMeet.joinMeeting(
//           options,
//           listener: JitsiMeetingListener(
//             onConferenceTerminated: (url, error) {
//               Navigator.of(context).pop();
//               onVideoCallEnds();
//             },
//             // onConferenceJoined: (message) {
//             // try {
//             //   UpdateConsultationDetails.updateJitsiLink(
//             //     {
//             //       "set": {
//             //         "meetingLink": message["url"].toString(),
//             //         "status": "meetingLinkGenerated"
//             //       }
//             //     },
//             //     consultationId!,
//             //   );
//             //   log("Pushed meeting link");
//             // } on HttpException catch (e) {
//             //   log(e.toString());
//             //   Fluttertoast.showToast(msg: e.message);
//             // } catch (e) {
//             //   log("Error pushing meeting link " + e.toString());
//             //   Fluttertoast.showToast(msg: "Not able to connect to expert");
//             //   Navigator.of(context).pop();
//             // }
//             // log(message["url"].toString());
//             // },
//           ),
//         );
//       } catch (e) {
//         log(e.toString());
//       }
//     } catch (error) {
//       log("error: $error");
//     }
//   }
// }
