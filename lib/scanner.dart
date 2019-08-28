import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_qr_scanner/text_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  final Widget child;
  Scanner({this.child});
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  bool _isFlash = false, _isFoundQRcode = false;
  AnimationController animationController;
  QRViewController controller;
  Animation<double> verticalPosition;
  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );

    animationController.addListener(() {
      this.setState(() {});
    });
    animationController.forward();
    verticalPosition = Tween<double>(begin: 5.0, end: 240.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear))
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          animationController.reverse();
        } else if (state == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_isFoundQRcode
        ? Scaffold(
            body: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              QRView(
                key: qrKey,
                onQRViewCreated: (r) => _onQRViewCreated(r, context),
              ),
              Center(
                heightFactor: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.fromBorderSide(
                                BorderSide(width: 1.4, color: Colors.white70))),
                      ),
                    ),
                    Positioned(
                      top: verticalPosition.value,
                      child: Container(
                        width: 240,
                        height: 3.0,
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3.0,
                                  color: Colors.redAccent,
                                  spreadRadius: 3.0)
                            ]),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton.icon(
                      color: Colors.transparent,
                      icon: !_isFlash
                          ? Icon(
                              Icons.flash_off,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.flash_on,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        if (!_isFlash)
                          setState(() {
                            _isFlash = true;
                            controller.toggleFlash();
                          });
                        else
                          setState(() {
                            _isFlash = false;
                            controller.toggleFlash();
                          });
                      },
                      label: Text(''),
                    )
                  ],
                ),
              )
            ],
          ))
        : TextScreen(
            qrText,
            onClose: () {
              setState(() {
                _isFoundQRcode = false;
                qrText = '';
              });
            },
          );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        _isFoundQRcode = true;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController?.dispose();
    super.dispose();
  }
}

enum ScannerState { ScannerScree, TextScreen, WebView }
