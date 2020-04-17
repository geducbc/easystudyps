import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';

class AssessmentDetailPage extends StatefulWidget{
  @override
  _AssessmentDetailPageState createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mathematics Test'),
              backgroundColor: Colors.blueAccent,
            ),
            body: Stack(
              children: <Widget> [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[],
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: (){},
                      child: Text('START TEST',
                          style: TextStyle(
                            color: Colors.white),
                        ) ,
                      )
                    ) ,
                  )
              ]
            )
          );
        },
      );
  }
}