import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_consultations_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ConsultationComment extends StatefulWidget {
  ConsultationComment(
      {Key? key,
      required this.ticketNumber,
      required this.flow,
      required this.comment})
      : super(key: key);

  String ticketNumber;
  String flow;
  List<dynamic> comment;

  @override
  State<ConsultationComment> createState() => _ConsultationCommentState();
}

class _ConsultationCommentState extends State<ConsultationComment> {
  final TextEditingController _commentController = TextEditingController();
  bool isChecked1 = false;

  @override
  void initState() {
    super.initState();
  }

  Widget checkboxTiles(context, bool check, Function ontap, String title) {
    return ListTile(
      leading: Checkbox(
        activeColor: orange,
        side: const BorderSide(
          color: orange,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        value: check,
        onChanged: (val) {
          ontap();
        },
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Comment',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
              ),
              height: 50,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _commentController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write Comments....',
                  hintStyle: TextStyle(
                    color: Color(0xFF959EAD),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'OpenSans',
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            //const SizedBox(height: 20),
            checkboxTiles(
              context,
              isChecked1,
              () {
                setState(() {
                  isChecked1 = !isChecked1;
                });
              },
              'Close Consultation',
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: postComment,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: orange),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comments',
                style: TextStyle(
                    color: orange, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            widget.comment.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Text(widget.comment[index]["message"]),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 5),
                        itemCount: widget.comment.length),
                  )
                : const Text(
                    "No Comment added yet",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: orange),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> postComment() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    var data = Provider.of<UserData>(context, listen: false).userData;
    Map<String, dynamic> payload = {
      "ticketNumber": widget.ticketNumber,
      "comment": _commentController.text,
      "flow": widget.flow,
      "closeConsultation": isChecked1,
      "userEmail": data.email
    };

    await Provider.of<WmConsultationData>(context, listen: false)
        .postComment(payload)
        .then((value) {
      Navigator.pop(context, true);
    });
  }

  /// Validating fields
  bool _validate() {
    if (_commentController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter comment");
      return false;
    }

    return true;
  }
}
