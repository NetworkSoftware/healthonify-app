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
// class ExpertVideoCall extends StatelessWidget {
//   final String? meetingId;
//   final Function onVideoCallEnds;
//
//   ExpertVideoCall({Key? key, required this.onVideoCallEnds, this.meetingId})
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
//
//       // featureFlag.resolution = FeatureFlagVideoResolution
//       //     .MD_RESOLUTION; // Limit video resolution to 360p
//
//       var options = JitsiMeetingOptions(
//           room: meetingId!,
//           serverURL: "https://meet.jit.si/",
//           subject: "Meeting with Expert",
//           userDisplayName: name,
//           token: "eyJhbGciOiJSUzI1NiIsImtpZCI6ImYyZTgyNzMyYjk3MWExMzVjZjE0MTZlOGI0NmRhZTA0ZDgwODk0ZTciLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiUHVuZWV0IE5haWsiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSmhPRGVaZFVrcHhHTThZX0ZPXzlEZUtaeGJ0NUNxeGJXcElzcjZIS3BNYzdNPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL21lZXQtaml0LXNpLTY2Y2JkIiwiYXVkIjoibWVldC1qaXQtc2ktNjZjYmQiLCJhdXRoX3RpbWUiOjE2OTcwODg5MDcsInVzZXJfaWQiOiJjSjd3NGZHV2FRVlVya1ZnSTV2MnA0Z1BWRXEyIiwic3ViIjoiY0o3dzRmR1dhUVZVcmtWZ0k1djJwNGdQVkVxMiIsImlhdCI6MTY5NzA4ODkwNywiZXhwIjoxNjk3MDkyNTA3LCJlbWFpbCI6InB1bmVldG45MUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJnb29nbGUuY29tIjpbIjEwODE3MzM0NDk4NjAyMTA1NjAxNSJdLCJlbWFpbCI6WyJwdW5lZXRuOTFAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoiZ29vZ2xlLmNvbSJ9fQ.e9H861E7pXunA2X-jbsJUrldblqFd81KhOE75x7Pwtr99rvdP2z0leNCCq7ypN9JNLlFuxtbgWq295i3oFFVvIvpsGJvml7tzXBViNukHLww42hOlAQYOIKy4t1aXDm51WKbMBEbCkRqq6TFxLtToh2dUDvdF13HICwsBPKm-Cp2J-zSFrJpnLrmXYaMUxvpVDC5_jEK9a5jKbT4TI6dWB9u2sfFChjy-AuDf_q6TwaZqOTQGjVsDiRwKKMCF1NR5ygzo53HP55kQ-u_c2mGMsP-sjKyKq56p5Kvz2Ao3YJFjYiXXnXEBXsiMK9fbnRYmwVAV5VRDssVeEtV--5JDA",
//           userAvatarURL:
//           "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80"
//           // or .png
//           ,
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
