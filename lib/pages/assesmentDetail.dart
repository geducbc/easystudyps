import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/model/test.dart';
import 'package:studyapp/redux/actions.dart';

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
          Test _test = state.testSelected;
          return Scaffold(
            appBar: AppBar(
              title: Text(_test.quizName),
              backgroundColor: Colors.blueAccent,
            ),
            body: Stack(
              children: <Widget> [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView(
                        physics: ScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                        children: <Widget>[
                          Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Total Number of questions')
                              ),
                              Container(
                                child: Text(_test.numberOfQuestions,style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              )
                            ],)
                            )
                            ,),
                            Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Total Number of Marks Obtainable',style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              ),
                              Container(
                                child: Text(_test.totalValidMarks)
                              )
                            ],)
                            )
                            ,),
                            Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Is Timed?')
                              ),
                              Container(
                                child: Text(_test.isTimed ? 'True' : 'False',style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              )
                            ],)
                            )
                            ,),
                            _test.isTimed ? Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Number of Minutes to Complete')
                              ),
                              Container(
                                child: Text(_test.numberOfMinutesToComplete,
                                style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              )
                            ],)
                            )
                            ,) : Container(),
                            Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Valid Until',style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              ),
                              Container(
                                child: Text(_test.validUntil,
                                  style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                                
                              )
                            ],)
                            )
                            ,),
                            Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text('Submission Status')
                              ),
                              Container(
                                child: Text('Pending',
                                  style: TextStyle(fontWeight: 
                                  FontWeight.bold, fontFamily: 'Gilroy'),
                                )
                              )
                            ],)
                            )
                            ,)
                        ]
                      )
                    ],
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: (){
                        StoreProvider.of<AppState>(context).dispatch(OnTestSelected(_test));
                        Navigator.of(context).pushNamed('/quiz');
                      },
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