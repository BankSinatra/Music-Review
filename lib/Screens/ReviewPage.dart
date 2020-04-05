import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_review_project/HexToColor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_review_project/DescriptionTextWidget.dart';

class ReviewPage extends StatefulWidget {
  final String id;
  @override
  ReviewPage({Key key, this.id}) : super(key: key);
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('music')
            .document("${widget.id}")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          var palette = userDocument['Palette'];
          return new Scaffold(
              backgroundColor: hexToColor(userDocument['Palette'][0]),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        });
                  },
                ),
                title: Text(userDocument['Format']),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10), child: Icon(Icons.more_vert))
                ],
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 350,
                        height: 350,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              LinearProgressIndicator(),
                          imageUrl: userDocument['Cover Art'],
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 348,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(userDocument['Artist'][0],
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: Colors.white),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300)),
                            Text(
                              '${userDocument['Rating'].toString()}/ 10',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                          width: 348,
                          child: Text(
                            userDocument['Title'],
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(color: Colors.white),
                                fontSize: 36),
                          )),
                      SizedBox(height: 10,),
                      //Review text
                      Container(
                        width: 348,
                        color: hexToColor(userDocument['Palette'][1]),
                        child: DescriptionTextWidget(
                            text: userDocument['Review Text'], id: palette),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          //Best Track
                          width: 348,
                          color: hexToColor(userDocument['Palette'][1]),
                          child:
                              Center(child: Text("Best Track: '${userDocument['Best Track']}'",
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                textStyle: TextStyle(color: Colors.white),
                                fontSize: 24
                              ),)),
                        ),
                      ),
                      SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          //Worst Track
                          width: 348,
                          color: hexToColor(userDocument['Palette'][1]),
                          child:
                              Center(child: Text("Best Track: '${userDocument['Worst Track']}'",
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                textStyle: TextStyle(color: Colors.white),
                                fontSize: 24
                              ),)),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
