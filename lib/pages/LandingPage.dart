import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/learning_course.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:studyapp/model/app_state.dart';

class LandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      children: <Widget>[
        SafeArea(
      minimum: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
                Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Hello',

                      )
                    ] ,
                  )
                )
                ,
                Row(
                  children: <Widget>[
                    Text('Bucky Damilola',
                      style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold, fontSize: 26),
                    )
                  ]
                ),
                Card(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          // height: deviceHieght * 0.32,
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/getStarted.png'),
                            )
                            ),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 142,
                                    child: Text('What do you want to learn today?',
                                      style: TextStyle(fontFamily: 'Gilroy', 
                                      fontSize: 18,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  Container(
                                    child: RaisedButton(
                                    onPressed: (){
                                      // print('Hello');
                                      StoreProvider.of<AppState>(context).dispatch(TabIndex(1));
                                      // Navigator.pushReplacementNamed(context, '/learning');
                                    },
                                    color: Colors.deepOrangeAccent,
                                    textColor: Colors.white,
                                    child: Text('Get Started',
                                    ),  
                                  )
                                  )
                                ]
                              ),
                              
                            )
                          )
                        ),
                        
                      ]
                    )
                  ),
                ),
            ],)
            ),
            SizedBox(height: 8,),
            Container(
              child:Text('Currently Viewing Subjects',
                  style: TextStyle(color: Colors.grey[800], fontFamily: 'Gilroy'),
                ),
            ),
            SizedBox(height: 16,),
            Container(
              width: double.infinity,
              // height: 300.0,
              child: LearningCourse()
            ),
            SizedBox(height: 16,),
            Container(
              child:Text('Frequently Viewed Subjects',
                  style: TextStyle(color: Colors.grey[800], fontFamily: 'Gilroy'),
                ),
            ),
            SizedBox(height: 16,),
            Container(
              width: double.infinity,
              // height: 200.0,
              child: LearningCourse()
            ),
        ]
      )
    )
    ],
    );
  }
}