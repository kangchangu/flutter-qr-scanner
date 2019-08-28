import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextScreen extends StatefulWidget {
  final VoidCallback onClose;
  String text;
  TextScreen(String text, {this.onClose}) : super() {
    this.text = text;
  }

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  bool isContainHttp = false;
  @override
  void initState() {
    if (widget.text.contains('http') || widget.text.contains('https'))
      setState(() {
        isContainHttp = true;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isContainHttp)
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: WebView(
            widget.text,
            aspectRatio: MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height,
          ),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            widget.onClose();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: 70,
              width: 70,
              child: Center(child: Text('T', style: TextStyle(fontSize: 40))),
            ),
            SizedBox(
              height: 20,
            ),
            Container(color: Colors.grey, child: Text(widget.text))
          ],
        ),
      ),
    );
  }
}
