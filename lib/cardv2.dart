
import 'package:andabera/card_details.dart';
import 'package:andabera/detailed_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class PlanetRow extends StatelessWidget {
  //final Stream<QuerySnapshot> queryStream;
  final CardDetails cardDetails;
  PlanetRow({Key key, this.cardDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            CardV2(cardDetails,context),
            planetThumbnail,
          ],
        )
    );
  }
}

final planetThumbnail = new Container(
  margin: new EdgeInsets.symmetric(
      vertical: 16.0
  ),
  alignment: FractionalOffset.centerLeft,
  child: Container(
    width: 92,
    height: 92,
    child: FlareActor(
        'assets/notification.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        snapToEnd: true,
        animation: "appear"),
//  child: new Image(
//    image: new AssetImage("assets/mars.png"),
//    height: 92.0,
//    width: 92.0,
//  ),
  )

  );

Container CardV2(CardDetails cardDetails, BuildContext context) => new Container(
  height: 150.0,
  margin: new EdgeInsets.only(left: 46.0),
  decoration: new BoxDecoration(
    color: Colors.blue,
    shape: BoxShape.rectangle,
    borderRadius: new BorderRadius.circular(8.0),
    boxShadow: <BoxShadow>[
      new BoxShadow(
        color: Colors.black12,
        blurRadius: 10.0,
        offset: new Offset(0.0, 10.0),
      ),
    ],
  ),
  child: makeListTile(cardDetails,context),
);

ListTile makeListTile(CardDetails cardDetails, BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 15.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.autorenew, color: Colors.white),
    ),
    title: Text(
      cardDetails.cardTitle.toUpperCase(),
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ,fontSize: 20),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Column(
      children: <Widget>[
        SizedBox(height: 15),

        Row(
          children: <Widget>[
            Icon(Icons.supervised_user_circle, color: Colors.amberAccent),
            SizedBox(width: 5),
            Text(cardDetails.createdUser, style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic))
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.access_alarms, color: Colors.greenAccent),
            SizedBox(width: 5),
            Text(cardDetails.createdDate.toString(), style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic))
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.chat, color: Colors.grey),
            SizedBox(width: 5),
            Text(cardDetails.relatedChanel.toUpperCase(), style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic)),
          ],
        ),
        SizedBox(height: 15),
      ],
    ),
    trailing:
    Icon(Icons.aspect_ratio, color: Colors.white, size: 30.0),
    onTap: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => DetailPage(cardDetails: cardDetails)));
    },
);
