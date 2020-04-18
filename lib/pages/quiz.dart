import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/model/options.dart';
import 'package:studyapp/model/question.dart';
import 'package:studyapp/model/response.dart';
import 'package:studyapp/model/test.dart';
import 'package:studyapp/util/colors.dart';

import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

class Quiz extends StatefulWidget{
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz>{
  double progress = 20.0;
  double currentQuestionNumber = 0;
  List<Response> responses = [];
  List<Response> userResponse = [];
  Options selectedOption;
  int answeredQuestionNumber;
  bool onTapOption = false;
  double calculateProgress(currentQuestionNumber, Test _test){
    return ((currentQuestionNumber + 1) /double.parse(_test.numberOfQuestions) * 100);
  }
  String getCurrentQuestion(Test _test, double questionNumber){
    int questionNumberToInt = questionNumber.toInt();
    String question = _test.questions[questionNumberToInt].question;
    return question;
  }
  Border decorateBorder(Options option){
    bool answerIsCorrect = false;
    userResponse.forEach((Response element) {
      if(element.selectedOption.trim().toLowerCase() 
        == option.option.trim().toLowerCase() && element.questionNumber == answeredQuestionNumber
         && onTapOption == true){
        answerIsCorrect = true;
      }
    });

    if(answerIsCorrect){
      return Border.all(width: 4.0, color: Colors.green);
    }
    
    return Border.all(width: 4.0, color: Colors.white);
  }
  handleFormSubmit(BuildContext context){
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Submit Assessment'),
          content: Container(
            child: Text('You are about to submit your assesment. Continue?'),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(onPressed: (){
              Navigator.pop(context);
            },
             child: Text('Cancel'))
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child:RaisedButton(onPressed: (){
                Navigator.pop(context);
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return Dialog(
                //         child: Container(
                //           padding: EdgeInsets.symmetric(vertical:16.0, horizontal: 16.0),
                //           child: new Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             new CircularProgressIndicator(),
                //             Container(padding: EdgeInsets.symmetric(horizontal:16.0),
                //               child: new Text("Loading"),
                //             )
                //           ],
                //         ),),
                //       );
                //       });
                // print('resoinse: '+ json.encode(responses));
              }, color: Colors.blue, 
                  child: Text('Yes, Submit', style: TextStyle(color: Colors.white)),)
            )
          ],
        );
      }
    );
  }
  List<Widget> displayAnswers(Test _test, double questionNumber){
    int questionNumberToInt = questionNumber.toInt();
    return _test.questions[questionNumberToInt].options.map((Options option){
        return Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
            border: decorateBorder(option),
            borderRadius: BorderRadius.all(Radius.circular(4.0))
          ),
              child: Card(
          
          child: ListTile(
            onTap: () {
              var doc = responses.firstWhere((Response element) => element.question.question.toLowerCase().trim()
                   == _test.questions[questionNumberToInt].question.trim().toLowerCase(), orElse: () => null);

              if(doc != null){
                // add new chioce to the response if the response is empty;
                int index = responses.indexOf(doc);
                 responses.removeAt(index);
                responses.add(Response(question: _test.questions[questionNumberToInt]  ,
                correctOption: _test.questions[questionNumberToInt].correctOption,
                  selectedOption: option.option, questionNumber: questionNumberToInt));
                  setState(() {
                    userResponse = responses;
                    selectedOption = option;
                    onTapOption = true;
                    answeredQuestionNumber = questionNumber.toInt();
                  });
                
              }else{
                // remove the choice from the responses if it already existing
                 print('here for the first time');

                 responses.add(Response(question: _test.questions[questionNumberToInt]  ,
                correctOption: _test.questions[questionNumberToInt].correctOption,
                  selectedOption: option.option, questionNumber: questionNumberToInt));
                  setState(() {
                    userResponse = responses;
                    selectedOption = option;
                    onTapOption = true;
                    answeredQuestionNumber = questionNumber.toInt();
                  });
              }
            },
            title: Row(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(option.option, 
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Container(
                child: Text(option.answer)
              )
            ],),
          ),) ,
            ),
          );
    }).toList();
  } 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, AppState>(
       converter: (store) => store.state,
       builder: (BuildContext context, state){
         Test _test = state.testSelected;
         return Scaffold(
          //  appBar: AppBar(
          //    title: Text('Quiz')
          //  ),
           backgroundColor: Colors.indigo,
           body: SafeArea(
             child: Container(
                child: Stack(
                  children: <Widget> [
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                ListView(
                                          physics: ScrollPhysics(), // to disable GridView's scrolling
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          children: <Widget>[
                                            Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                    Container(
                                                      child: FlatButton(
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        }, 
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Icon(Icons.arrow_back_ios, 
                                                              color: Colors.white,)
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left:8.0),
                                                              child: Text('Exit Quiz',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: 'Gilroy',
                                                                  fontSize: 16.0
                                                                ),
                                                              )
                                                            )
                                                          ]
                                                        )
                                                        )
                                                    )
                                                ]
                                              )
                                            ,Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(margin: EdgeInsets.symmetric(horizontal:6.0),
                                                child: Text("${(currentQuestionNumber.toInt() + 1).toString()}",
                                                  style: TextStyle(color: Colors.white, fontSize: 16, 
                                                fontFamily: 'Gilroy', fontWeight: FontWeight.bold)
                                                )
                                                ),
                                                Text('/', style: TextStyle(color: Colors.white, fontSize: 16, 
                                                fontFamily: 'Gilroy', fontWeight: FontWeight.bold),),
                                                Container(margin: EdgeInsets.symmetric(horizontal:6.0),
                                                    child: Text(_test.numberOfQuestions,
                                                      style: TextStyle(color: Colors.white, fontSize: 16, 
                                                    fontFamily: 'Gilroy', fontWeight: FontWeight.bold)
                                                    )
                                                )
                                              ],
                                            )
                                            ,Container(
                                                      //  child: Text('50%')
                                                      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                                      width: double.infinity,
                                                      child: RoundedProgressBar(
                                                          style: RoundedProgressBarStyle(
                                                                  borderWidth: 0, 
                                                                  widthShadow: 0),
                                                            margin: EdgeInsets.symmetric(vertical: 2),
                                                            childLeft: Text("${calculateProgress(currentQuestionNumber, _test)}%",
                                                                style: TextStyle(color: Colors.white)),
                                                            percent: calculateProgress(currentQuestionNumber, _test),
                                                            height: 16,
                                                            theme: RoundedProgressBarTheme.blue)
                                                      //  Text('50%')
                                                      //  Text('50%')
                                                    )
                                            ,Container(
                                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                              child: Text('Question: ',
                                                style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold,
                                                  fontSize: 20.0, fontFamily: 'Gilroy'
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                              child: Text( getCurrentQuestion(_test, currentQuestionNumber),
                                                style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold,
                                                  fontSize: 16.0, fontFamily: 'Gilroy'
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                              child: Text('Answers: ',
                                                style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold,
                                                  fontSize: 20.0, fontFamily: 'Gilroy'
                                                ),
                                              ),
                                            ),
                                            ListView(
                                              physics: ScrollPhysics(), // to disable GridView's scrolling
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(),
                                              children: displayAnswers(_test, currentQuestionNumber)
                                            )
                                    ]
                                  )
                            ]
                          )
                      
                      
                      ,Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: (){
                              setState(() {
                                onTapOption = true;
                                currentQuestionNumber = currentQuestionNumber > 0 ? currentQuestionNumber - 1 : 0;
                              });
                            },
                            child: Text('Prev',
                            style: TextStyle(color: Colors.white),),)
                        ),),
                        Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: currentQuestionNumber.toInt() + 1 == int.parse(_test.numberOfQuestions) ?
                            RaisedButton(
                            color: Colors.green,
                            onPressed: (){
                              handleFormSubmit(context);
                            },
                            child: Text('Submit',
                                style: TextStyle(color: Colors.white),
                              ),) : RaisedButton(
                            color: Colors.green,
                            onPressed: (){
                              setState(() {
                                onTapOption = false;
                                currentQuestionNumber = currentQuestionNumber + 1;
                              });
                            },
                            child: Text('Next',
                                style: TextStyle(color: Colors.white),
                              ),)
                        ),)

                  ]
                ),
              )
             
            )
         );
       }
       );
  }
}