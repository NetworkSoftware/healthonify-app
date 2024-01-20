import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../models/user.dart';

class VideoCall1 extends StatefulWidget {
  final String? meetingId;
  final Function onVideoCallEnds;

  const VideoCall1({Key? key, required this.onVideoCallEnds, this.meetingId})
      : super(key: key);

  @override
  State<VideoCall1> createState() => _VideoCall1State();
}

class _VideoCall1State extends State<VideoCall1> {
  User? data;

  /// Meeting AppId and AppSign
  static const int appId = 1441473249;
  static const String appSign =
      "fd9fc0a015b641806af857e53b647b16b275e1470d56344c46d408a609bfbaef";
  @override
  void initState() {
    super.initState();
    log(widget.meetingId!);
    data = Provider.of<UserData>(context, listen: false).userData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        userID: data!.id!,
        userName: data!.firstName!,
        callID: widget.meetingId!,
        config: ZegoUIKitPrebuiltCallConfig(
            turnOnCameraWhenJoining: true, useSpeakerWhenJoining: true),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_sdk/zoom_platform_view.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
// import 'package:healthonify_mobile/providers/user_data.dart';
// import 'package:omni_jitsi_meet/feature_flag/feature_flag.dart';
// import 'package:omni_jitsi_meet/jitsi_meet.dart';
//
// // import 'package:jitsi_meet/feature_flag/feature_flag.dart';
// // import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:provider/provider.dart';
//
// class VideoCall1 extends StatelessWidget {
//   final String? meetingId;
//   final String? meetingPassword;
//   final Function onVideoCallEnds;
//
//   VideoCall1(
//       {Key? key,
//       required this.onVideoCallEnds,
//       this.meetingId,
//       this.meetingPassword})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     log(meetingId!);
//     var data = Provider.of<UserData>(context).userData;
//     // _joinMeeting(meetingId!, data.firstName!, context);
//     joinMeeting(context, data.firstName!);
//     return const Scaffold();
//   }
//
//   joinMeeting(BuildContext context, String userName) {
//     Timer? timer;
//     bool _isMeetingEnded(String status) {
//       var result = false;
//
//       if (Platform.isAndroid) {
//         result = status == "MEETING_STATUS_DISCONNECTING" ||
//             status == "MEETING_STATUS_FAILED";
//       } else {
//         result = status == "MEETING_STATUS_IDLE";
//       }
//
//       return result;
//     }
//
//     if (meetingId!.isNotEmpty) {
//       ZoomOptions zoomOptions = ZoomOptions(
//         domain: "zoom.us",
//         appKey: "wbH_kl3MTQXVxrUvfqwwA",
//         appSecret: "US2FkpGRH4hfgN3lMOdqfjZy1hbUlRil",
//       );
//       var meetingOptions = ZoomMeetingOptions(
//           userId: userName,
//           meetingId: "87850424611",
//           meetingPassword: "VLZ1mf",
//           disableDialIn: "true",
//           disableDrive: "true",
//           disableInvite: "true",
//           disableShare: "true",
//           disableTitlebar: "false",
//           viewOptions: "true",
//           noAudio: "false",
//           noDisconnectAudio: "false");
//
//       var zoom = ZoomView();
//       zoom.initZoom(zoomOptions).then((results) {
//         if (results[0] == 0) {
//           zoom.onMeetingStatus().listen((status) {
//             if (_isMeetingEnded(status[0])) {
//               timer!.cancel();
//             }
//           });
//           zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
//
//             timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//               zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
//                     status[1]);
//               });
//             });
//           });
//         }
//       }).catchError((error) {
//       });
//     } else {
//       if (meetingId!.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Enter a valid meeting id to continue."),
//         ));
//       }
//       // else if (meetingPassword!.isEmpty) {
//       //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       //     content: Text("Enter a meeting password to start."),
//       //   ));
//       // }
//     }
//   }
// }
