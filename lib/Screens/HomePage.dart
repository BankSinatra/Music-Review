import 'dart:ui';
import 'package:music_review_project/Screens/ReviewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_review_project/HexToColor.dart';

final bgcolour = const Color(0xFF131313);
final fgcolour = const Color(0xFF445469);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolour,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Text("Home"),
        actions: <Widget>[
          Padding(padding: EdgeInsets.all(10), child: Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('music').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            return GridView.builder(
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.655172413),
              //cacheExtent: 1000.0,
              itemBuilder: (BuildContext context, int index) {
                var url = snapshot.data.documents[index]['Cover Art'];
                return GestureDetector(
                  child: Container(
                    width: 190.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: hexToColor(
                          snapshot.data.documents[index]['Palette'][0]),
                      elevation: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 12),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(21.0),
                              child: Image.network(url,
                                  height: 180.0, width: 180)),
                          SizedBox(height: 10),
                          Text(
                              snapshot.data.documents[index]['Artist']
                                  .join(', '),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300)),
                          SizedBox(height: 10),
                          Text(snapshot.data.documents[index]['Title'],
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    var text = snapshot.data.documents[index]['id'];
                    print("Tapped ${snapshot.data.documents[index]['id']}");
                    var reviewPageRoute = new MaterialPageRoute(
                      builder: (BuildContext context) => new ReviewPage(
                        id: text,
                      ),
                    );
                    Navigator.of(context).push(reviewPageRoute);
                  },
                );
              },
            );
          }),
    );
  }
}
