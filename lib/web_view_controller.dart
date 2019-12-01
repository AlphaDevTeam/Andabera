import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewContainer extends StatefulWidget {
  final url;
  WebViewContainer(this.url);
  @override
  createState() => _WebViewContainerState(this.url);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  _WebViewContainerState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
                    onPageFinished: (finished){
                      print("Finished : " + finished);
                    },

                )
            )
          ],
        ));
  }
  String _loadHTML() {
    return r'''
      <html>
        <body onload="document.alphaPay.submit();">
          <form id="alphaPay" method="post" action="https://sandbox.payhere.lk/pay/checkout">   
            <input type="hidden" name="merchant_id" value="1210687">    <!-- Replace your Merchant ID -->
            <input type="hidden" name="return_url" value="http://sample.com/return">
            <input type="hidden" name="cancel_url" value="http://sample.com/cancel">
            <input type="hidden" name="notify_url" value="http://sample.com/notify">  
            <br><br>Item Details<br>
            <input type="text" name="order_id" value="ItemNo12345">
            <input type="text" name="items" value="From App"><br>
            <input type="text" name="currency" value="LKR">
            <input type="text" name="amount" value="1000">  
            <br><br>Customer Details<br>
            <input type="text" name="first_name" value="Mihindu">
            <input type="text" name="last_name" value="Karunarathne"><br>
            <input type="text" name="email" value="mihindugajaba@gmail.com">
            <input type="text" name="phone" value="0771234567"><br>
            <input type="text" name="address" value="No.1, Galle Road">
            <input type="text" name="city" value="Colombo">
            <input type="hidden" name="country" value="Sri Lanka"><br><br> 
            <input type="submit" value="Buy Now">   
          </form> 
        </body>
      </html>
    ''';
  }
}