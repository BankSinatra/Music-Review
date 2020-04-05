import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_review_project/HexToColor.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionTextWidget extends StatefulWidget {
  final List id;
  final String text;

  @override
  DescriptionTextWidget({this.text, Key key, this.id}) : super(key: key);
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
            .collection('music')
            .document("${widget.id}")
            .snapshots(),
      builder: (context, snapshot) {
                  if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
        return new Container(
          padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: secondHalf.isEmpty
              ? new Text(firstHalf)
              : new Column(
                  children: <Widget>[
                    new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf), style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: Colors.white),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300)),
                    new InkWell(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 334,
                            height: 52.69,
                            color: hexToColor(widget.id[2]),
                            child: Center(
                              child: new Text(
                                flag ? "Expand" : "Contract",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: Colors.white),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                    ),
                  ],
                ),
        );
      }
    );
  }
}
