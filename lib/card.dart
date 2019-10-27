import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// This is the stateless widget that the main application instantiates.
class InfoCard extends StatelessWidget {
  final String imgURL;
  final String mainTitle;
  final String subTitle;
  InfoCard({Key key, this.imgURL, this.mainTitle, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(

        color: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(
              imgURL,
              fit: BoxFit.contain,
              colorBlendMode: BlendMode.clear,
            ),
             ListTile(
              leading: Icon(
                  Icons.info_outline,
                color: Colors.black45,
              ),
              title: Text(mainTitle),
              subtitle: Text(subTitle),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */
                        _openMap();
                        print("Clicked :" + mainTitle);

                      },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */
                      _sendMail();
                      print("Clicked :" + subTitle);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_openMap() async {
  const url = 'https://www.google.com/maps/search/?api=1&query=Mahanama+Collage+Colombo+03';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_sendMail() async {
  // Android and iOS
  const uri = 'mailto:test@example.org?subject=Greetings&body=Hello%20World';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

_callMe() async {
  // Android
  const uri = 'tel:+1 222 060 888';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'tel:001-22-060-888';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}

_textMe() async {
  // Android
  const uri = 'sms:+39 349 060 888';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'sms:0039-222-060-888';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}