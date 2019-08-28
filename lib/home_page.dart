import 'package:flutter/material.dart';
import 'package:flutter_qr_scanner/scanner.dart';
class HomePage extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
             RaisedButton.icon(
            color: Colors.red,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>Scanner()
              ));
            },
            icon: Icon(Icons.select_all),
            label: Text("Scan"),
          ),
          ],
        ),
      )
    );
  }
} 