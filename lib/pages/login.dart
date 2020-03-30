import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studyapp/pages/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}


class _LoginState extends State<Login>{
  String appName = "";
  String _pin = "";
  String errorMessage ="";
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appName = 'STUDY APP';
  }
  _activateApp(context){
    // call the api to activat school
    // get the school domain name and store as global variable
    appDomain = 'http://digitalschool.easystudy.com.ng/';
    // fetch all secondary school
    // print('here 00000');
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(vertical:16.0, horizontal: 16.0),
          child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            Container(padding: EdgeInsets.symmetric(horizontal:16.0),
              child: new Text("Loading"),
            )
          ],
        ),),
      );
      });
    _fetchPrimarySchoolSubject(context);
    
    // call the api
    // Navigator.of(context).pushReplacementNamed('/app');
  }

  Future<http.Response> _fetchPrimarySchoolSubject(BuildContext context) async {
      // print('here 1');
      final response = await http.get(appDomain+'subjects_api.php?cat_id=2');
      if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('here 2');
      // print(json.decode(response.body).toString());
      // SharedPreferences
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final SharedPreferences prefs = await _prefs;
      print('here o'+ json.decode(response.body).toString());
      // prefs.setStringList('primary_subjects', json.decode(response.body));
      // print('hello '+ prefs.getStringList('primary_subjects').toString());
      Navigator.of(context).pop();
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      Navigator.of(context).pop();
      throw Exception('Failed to load album');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final double deviceHeight = MediaQuery.of(context).size.height;
    return StoreConnector<AppState,AppState>(converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          
          body: GestureDetector(
            onTap: (){ FocusScope.of(context).requestFocus(FocusNode());},
            child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            child: Container(
            width: double.infinity,
            // height: deviceHeight,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: AssetImage('assets/online.jpg'),
              // )
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Center(child: Text(appName,
                      style: TextStyle(
                        fontFamily:'Gilroy', fontSize: 26.0, fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                  ),)),
                  SizedBox(height: 40.0,),
                  Form(
                    key: _formKey,
                    child: Column(
                    children: <Widget>[
                         Card(
                          child: TextFormField(
                            initialValue: _pin,
                            decoration: InputDecoration(labelText: 'School Activation Pin',
                              prefixIcon: Icon(LineIcons.key),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            onSaved: (value){
                              _pin = value;
                            },
                          ) ,
                        ),
                        Card(
                          child: TextFormField(
                            initialValue: _pin,
                            decoration: InputDecoration(labelText: 'First Name',
                              prefixIcon: Icon(Icons.person),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            onSaved: (value){
                              _pin = value;
                            },
                          ) ,
                        ),
                        Card(
                          child: TextFormField(
                            initialValue: _pin,
                            decoration: InputDecoration(labelText: 'Last Name',
                              prefixIcon: Icon(Icons.person),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            onSaved: (value){
                              _pin = value;
                            },
                          ) ,
                        ),
                        Card(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: _pin,
                            decoration: InputDecoration(labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            onSaved: (value){
                              _pin = value;
                            },
                          ) ,
                        ),
                        Card(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: _pin,
                            decoration: InputDecoration(labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            onSaved: (value){
                              _pin = value;
                            },
                          ) ,
                        ),
                        SizedBox(height: 10.0,),
                        errorMessage.isNotEmpty ? Center(child: 
                        Text(errorMessage,
                          style: TextStyle(color:Colors.red, fontFamily: 'Gilroy'),
                        ),) : Text(''),
                        SizedBox(height: 20.0,),
                        Container(
                                      margin: EdgeInsets.symmetric(vertical: 20.0),
                                      child: RaisedButton(
                                        color: Colors.greenAccent[700],
                                        onPressed: (){
                                          _activateApp(context);
                                        },
                                        child: Row(

                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(right: 8.0),
                                                child: Icon(LineIcons.check,
                                                  color: Colors.white,
                                                ),),
                                              Text('Activate',
                                                  style: TextStyle(
                                                    fontFamily: 'Gilroy',fontWeight: FontWeight.bold, 
                                                    fontSize: 18.0, color: Colors.white
                                                  ),
                                              )
                                          ],)
                                    )
                                    
                                  )
                    ]
                  ))
                ]
              )
            ,)
        )
          )
          ,)
        );
      },
    );
  }
}