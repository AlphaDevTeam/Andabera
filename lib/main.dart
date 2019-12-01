import 'dart:async';
import 'dart:io';

import 'package:andabera/alpha_pay_module.dart';
import 'package:andabera/auth.dart';
import 'package:andabera/card_details.dart';
import 'package:andabera/cardv1.dart';
import 'package:andabera/cardv2.dart';
import 'package:andabera/login_screen.dart';
import 'package:andabera/message_form.dart';
import 'package:andabera/profile.dart';
import 'package:andabera/video_page.dart';
import 'package:andabera/web_view_controller.dart';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:andabera/card.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterBase',
      routes: <String, WidgetBuilder> {
        '/homepage': (BuildContext context) =>  MessageHandler(),
        '/landingpage': (BuildContext context) => LoginPage()
      },
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {

  StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        authService.saveDeviceToken(_fcm);
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      authService.saveDeviceToken(_fcm);
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
         final newMessageSnackBar = SnackBar(
           content: Text("New Message " + message['notification']['title']),
           action: SnackBarAction(
             label: 'Go',
             onPressed: () => null,
           ),
         );

        Scaffold.of(context).showSnackBar(newMessageSnackBar);
//        showDialog(
//          context: context,
//          builder: (context) =>
//              AlertDialog(
//                content: ListTile(
//                  title: Text(message['notification']['title']),
//                  subtitle: Text(message['notification']['body']),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    color: Colors.amber,
//                    child: Text('Ok'),
//                    onPressed: () => Navigator.of(context).pop(),
//                  ),
//                ],
//              ),
//        );
      },
      /*
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },

       */
    );
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AlphaPay();
                      },
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateAlert();
                      },
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return VideoPage();
                      },
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return UserProfile();
                      },
                    )
                );
              },
            )
          ],
        ),
      ),
    );

    return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.deepOrange,
//          title: Text('FCM Push Notifications'),
//          actions: <Widget>[
//            PopupMenuButton(
//              icon: Icon(Icons.supervised_user_circle),
//              onSelected: (result) => authService.signOut(),
//              itemBuilder: (context) => [
//                PopupMenuItem(
//                  child: Text("Logout"),
//              )],
//            )
//          ],
//        ),
        bottomNavigationBar: makeBottom,
        body: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black, Colors.black,Colors.black]
                )
              ),
            child: StreamBuilder(
            stream: Firestore.instance.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return PlanetRow(cardDetails: new CardDetails(
                      snapshot.data.documents[index]['title'],
                      snapshot.data.documents[index]['description'],
                      snapshot.data.documents[index]['userUID'],
                      snapshot.data.documents[index]['createdDate'],
                      snapshot.data.documents[index]['imgURL'],
                      snapshot.data.documents[index]['createdUser'],
                      snapshot.data.documents[index]['chanel']
                      ),
                  );
//                  return InfoCard(
//                      imgURL: (snapshot.data.documents[index]['imgUrl'] != null) ? snapshot.data.documents[index]['imgUrl'] : "https://placeimg.com/640/480/any",
//                      mainTitle: snapshot.data.documents[index]['title'],
//                      subTitle: snapshot.data.documents[index]['description']);
                },
              );
            }
            )
        )
      )
    );

  }




  /// Subscribe the user to a topic
  _subscribeToTopic() async {
    // Subscribe the user to a topic
    _fcm.subscribeToTopic('puppies');
  }

}

