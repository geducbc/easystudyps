import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studyapp/pages/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyapp/redux/actions.dart';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}


class _LoginState extends State<Login>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  
  String appName = "";
  String _pin = "";
  String _lastName = "";
  String _firstName = "";
  String _phoneNumber = "";
  String _emailAddress = "";
  String errorMessage ="";
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    
    super.initState();
    appName = 'Easy StudyPS';
    // _firestore.settings({
    //   sslEnabled: false,
    //   persistenceEnabled: false,
    // });
  }
  _activateApp(context){
    print('hello o');
    setState(() {
      errorMessage = "";
    });
    _formKey.currentState.save();
    if(_emailAddress.isEmpty || _pin.isEmpty || _firstName.isEmpty || _lastName.isEmpty){
      return setState((){
          errorMessage = "Email, School Activation, Fist Name and Last Name pin are required";
      });
    }
    // call the api to activat school
    // get the school domain name and store as global variable
    // appDomain = 'http://digitalschool.easystudy.com.ng/';
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
    // _fetchPrimarySchoolSubject(context);
    // print('_pin:  '+ _pin);
    // Navigator.of(context).pushReplacementNamed('/app');
    getSchoolDomain(_pin, context);
    
    // call the api to get school domain

    // Navigator.of(context).pushReplacementNamed('/app');
  }

  getSchoolDomain(String schoolCode, BuildContext context) async{
      // print('called');
      // print(schoolCode);
      // Navigator.of(context).pop();
      print('here: '+ schoolCode);
      await Firestore.instance.collection('partners').document(schoolCode).get()
        .then(( DocumentSnapshot doc) async {
           if(doc.exists){
            
             final SharedPreferences prefs = await SharedPreferences.getInstance();
             prefs.setString('appDomain', doc.data['appDomain']);
              appDomain = doc.data['appDomain'];
              print('appDomain: '+ appDomain);
              print('app domain: '+ appDomain);
              _fetchPrimarySchoolSubject(context);
              _getJuniorSchoolData(context);
              _getSeniorSchoolSubject(context);

              // if(checkIfEmailExists()){
              //     Navigator.of(context).pop();
              //     return setState((){
              //         errorMessage = "Email Already exist";
              //     });
                   
              // }
              checkIfEmailNotExistThenSignUpUser(context, schoolCode);
              print('sign up');
              
           }
           setState((){
                      errorMessage = "School Activation Pin is Invalid";
            });
           
        })
        .catchError((onError){

          Navigator.of(context).pop();
          print('error: '+ onError.toString());
        });
      
  }
   checkIfEmailNotExistThenSignUpUser(BuildContext context,String schoolCode){
     Firestore.instance.collection('users').document(_pin)
      .collection('activated users').where('email',  isEqualTo: _emailAddress)
      .getDocuments()
      .then((doc) {
          if(doc.documents.length > 0){
            Navigator.of(context).pop();
            return setState((){
                errorMessage = "Email Address already exists";
            });
          }
         return signUpUser(_emailAddress, 'bacon34567890', schoolCode, {
                          "email": _emailAddress,
                          "phoneNumber": _phoneNumber,
                          "firstName": _firstName,
                          "lastName": _lastName,
                          "schoolCode":schoolCode
                        }, context);
      })
      .catchError((onError){
        Navigator.of(context).pop();
        setState((){
            errorMessage = "Some error encountered, please try again";
        });
      });
  }

   signUpUser(String email, String password,String schoolActivationPin, 
      Map<String, dynamic> userData, BuildContext context) async{
      try{
        print(email);
        print(password);
        print('signing up user');
        AuthResult result = await _firebaseAuth
                                .createUserWithEmailAndPassword(email: email, password: password);
          print(result);
          // await Firestore.instance.document('/users/'+email).setData(userData);
          await Firestore.instance.collection('users').document(schoolActivationPin).collection('activated users')
                .add(userData);
          
          // FirebaseUser user = result.user;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // print(user.uid);
          prefs.setString('user', json.encode(userData));
          print('user fond: '+ prefs.getString('user'));
          var user = json.decode(prefs.getString('user'))['firstName'] + " " + json.decode(prefs.getString('user'))['lastName'];
          StoreProvider.of<AppState>(context).dispatch(LoggedInUser(user));
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/app');
      }catch(error){
        // print('error message: '+ error.message);
        if(error.code == 'auth/email-already-exists'){
          setState(() {
            errorMessage = "Email Already exists";
          });
        }
        return Navigator.of(context).pop();
      }
      
  }

   _fetchPrimarySchoolSubject(BuildContext context) async {
      // print('here 1');
      final response = await http.get(appDomain+'read.php?id=2');
      if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('here 2');
      // print(json.decode(response.body).toString());
      // SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseSubjects = json.decode(response.body);

      prefs.setString('primary_subjects', json.encode(responseSubjects['subjects']));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      Navigator.of(context).pop();
      setState(() {
        errorMessage = "failed to load primary school data";
      });
      throw Exception('Failed to load album');
    }
  }

  _getJuniorSchoolData(BuildContext context) async{
    final response = await http.get(appDomain+'read.php?id=3');
      if (response.statusCode == 200) {
         final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final SharedPreferences prefs = await _prefs;
      // print('here o'+ json.decode(response.body).toString());
      final responseSubjects = json.decode(response.body);
      prefs.setString('junior_subjects', json.encode(responseSubjects['subjects']));

      // print('hello '+ json.decode(prefs.getString('primary_subjects')).toString());
      // Navigator.of(context).pop();
      }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      Navigator.of(context).pop();
      setState(() {
        errorMessage = "failed to load junior secondary school data";
      });
      throw Exception('Failed to load album');
    }
  }

  _getSeniorSchoolSubject(BuildContext context) async{
      final response = await http.get(appDomain+'read.php?id=4');
      if (response.statusCode == 200) {
         final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final SharedPreferences prefs = await _prefs;
      // print('here o'+ json.decode(response.body).toString());
      final responseSubjects = json.decode(response.body);
      prefs.setString('senior_subjects', json.encode(responseSubjects['subjects']));
      // print('hello '+ json.decode(prefs.getString('primary_subjects')).toString());
      // Navigator.of(context).pop();
      }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      Navigator.of(context).pop();
      setState(() {
        errorMessage = "failed to load senior secondary school data";
      });
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
                              print('values 000'+  value);
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
                              _firstName = value;
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
                              _lastName = value;
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
                              _phoneNumber = value;
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
                              _emailAddress = value;
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