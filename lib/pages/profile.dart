import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/model/app_state.dart';

class Profile extends StatefulWidget{
    @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _firstName = "Charles";
  String _lastName = "Onuorah";
  String _phoneNumber ="08163113450";
  String _emailAddress = "charles.onuorah@yahoo.com";
  String _initals = "" ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _initals = _firstName.substring(0,1).toUpperCase() +" "+ _lastName.substring(0,1).toUpperCase();
  }
  _saveProfile(){
    _formkey.currentState.save();
    print(_firstName);
  }
  Future<Map<String, dynamic>> getUserProfile() async{
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> userInfo = json.decode(_prefs.getString('user'));
      String _firstName = userInfo['firstName'];
      String _lastName = userInfo['lastName'];
      _initals = _firstName.substring(0,1).toUpperCase() +" "+ _lastName.substring(0,1).toUpperCase();
      return userInfo;
  }
  Future<String> getInitials() async{
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> userInfo = json.decode(_prefs.getString('user'));
      String _firstName = userInfo['firstName'];
      String _lastName = userInfo['lastName'];
      String _initials = _firstName.substring(0,1).toUpperCase() +" "+ _lastName.substring(0,1).toUpperCase();
      return _initials;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, AppState>(
        builder: (context, state) {
          return GestureDetector(
                onTap: (){ FocusScope.of(context).requestFocus(FocusNode());},
                child: SingleChildScrollView(
                            child: Column(
                              children:<Widget>[
                                    Container(
                                        color: Colors.greenAccent,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
                                        child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                        width: 120.0,
                                                        height: 120.0,
                                                        decoration: new BoxDecoration(
                                                          // color: Colors.orange,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.white60,
                                                          child: FutureBuilder(
                                                            future: getInitials(),
                                                            builder: (BuildContext context,AsyncSnapshot snapshot){
                                                                if(snapshot.connectionState == ConnectionState.done){
                                                                  if(snapshot.hasData){
                                                                    return Text(snapshot.data,
                                                                            style: TextStyle(
                                                                              color: Colors.white, fontFamily: 'Gilroy', fontWeight: FontWeight.bold, 
                                                                              fontSize: 26.0
                                                                            ),
                                                                          );
                                                                  }
                                                                  return Container();
                                                                }
                                                                return Container();
                                                            })
                                                        ),
                                                      ),
                                                      Container(
                                                        child: IconButton(
                                                          iconSize: 32.0,
                                                          icon: Icon(LineIcons.camera_retro) ,
                                                        onPressed: (){
                                                          print('change photo requested');
                                                        }),
                                                      )
                                                ],
                                                )
                                      ),
                                    FutureBuilder(
                                      future: getUserProfile(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.connectionState == ConnectionState.done){
                                            if(snapshot.hasData){
                                              return Form(
                                                    key: _formkey,
                                                    child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0) ,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Card(
                                                    child: TextFormField(
                                                      initialValue: snapshot.data['firstName'].toString(),
                                                      decoration: InputDecoration(labelText: 'First Name',
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                      onSaved: (value){
                                                        _firstName = value;
                                                      },
                                                    ) ,
                                                  ),
                                                  Card(
                                                    child: TextFormField(
                                                      initialValue: snapshot.data['lastName'],
                                                      decoration: InputDecoration(labelText: 'Last Name',
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                        onSaved: (value){
                                                        _lastName = value;
                                                      }
                                                      ) ,
                                                  ),
                                                  Card(
                                                    child: TextFormField(
                                                        initialValue: snapshot.data['phoneNumber'],
                                                        keyboardType: TextInputType.number,
                                                        decoration: InputDecoration(labelText: 'Phone Number', 
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                        onSaved: (value){
                                                        _phoneNumber = value;
                                                      }
                                                    ) ,
                                                  ),
                                                  Card(
                                                    child: TextFormField(
                                                      initialValue: snapshot.data['email'],
                                                      keyboardType: TextInputType.emailAddress,
                                                      decoration: InputDecoration(labelText: 'Email Address',
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                      onSaved: (value){
                                                        _emailAddress = value;
                                                      }
                                                    ) ,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 20.0),
                                                    child: RaisedButton(
                                                      color: Colors.greenAccent[700],
                                                      onPressed: (){
                                                        _saveProfile();
                                                      },
                                                      child: Row(

                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.only(right: 8.0),
                                                              child: Icon(Icons.save,
                                                                color: Colors.white,
                                                              ),),
                                                            Text('Update Profile',
                                                                style: TextStyle(
                                                                  fontFamily: 'Gilroy',fontWeight: FontWeight.bold, 
                                                                  fontSize: 18.0, color: Colors.white
                                                                ),
                                                            )
                                                        ],)
                                                  )
                                                  
                                                )
                                                      ]
                                                    ),
                                                  
                                                )
                                              );
                                            }
                                            return Form(
                                                  key: _formkey,
                                                  child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0) ,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Card(
                                                  child: TextFormField(
                                                    initialValue: '',
                                                    decoration: InputDecoration(labelText: 'First Name',
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                    onSaved: (value){
                                                      _firstName = value;
                                                    },
                                                  ) ,
                                                ),
                                                Card(
                                                  child: TextFormField(
                                                    initialValue: '',
                                                    decoration: InputDecoration(labelText: 'Last Name',
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                      onSaved: (value){
                                                      _lastName = value;
                                                    }
                                                    ) ,
                                                ),
                                                Card(
                                                  child: TextFormField(
                                                      initialValue: '',
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(labelText: 'Phone Number', 
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                      onSaved: (value){
                                                      _phoneNumber = value;
                                                    }
                                                  ) ,
                                                ),
                                                Card(
                                                  child: TextFormField(
                                                    initialValue: '',
                                                    keyboardType: TextInputType.emailAddress,
                                                    decoration: InputDecoration(labelText: 'Email Address',
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                                    onSaved: (value){
                                                      _emailAddress = value;
                                                    }
                                                  ) ,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                                  child: RaisedButton(
                                                    color: Colors.greenAccent[700],
                                                    onPressed: (){
                                                      _saveProfile();
                                                    },
                                                    child: Row(

                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets.only(right: 8.0),
                                                            child: Icon(Icons.save,
                                                              color: Colors.white,
                                                            ),),
                                                          Text('Update Profile',
                                                              style: TextStyle(
                                                                fontFamily: 'Gilroy',fontWeight: FontWeight.bold, 
                                                                fontSize: 18.0, color: Colors.white
                                                              ),
                                                          )
                                                      ],)
                                                )
                                                
                                              )
                                                    ]
                                                  ),
                                                
                                              )
                                                );
                                          }
                                          print('not here 2');
                                          return Container();
                                          // return Form(
                                          //         key: _formkey,
                                          //         child: Container(
                                          //         padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0) ,
                                          //         child: Column(
                                          //           children: <Widget>[
                                          //             Card(
                                          //         child: TextFormField(
                                          //           initialValue: '',
                                          //           decoration: InputDecoration(labelText: 'First Name',
                                          //             contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                          //           onSaved: (value){
                                          //             _firstName = value;
                                          //           },
                                          //         ) ,
                                          //       ),
                                          //       Card(
                                          //         child: TextFormField(
                                          //           initialValue: '',
                                          //           decoration: InputDecoration(labelText: 'Last Name',
                                          //           contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                          //             onSaved: (value){
                                          //             _lastName = value;
                                          //           }
                                          //           ) ,
                                          //       ),
                                          //       Card(
                                          //         child: TextFormField(
                                          //             initialValue: '',
                                          //             keyboardType: TextInputType.number,
                                          //             decoration: InputDecoration(labelText: 'Phone Number', 
                                          //             contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                          //             onSaved: (value){
                                          //             _phoneNumber = value;
                                          //           }
                                          //         ) ,
                                          //       ),
                                          //       Card(
                                          //         child: TextFormField(
                                          //           initialValue: '',
                                          //           keyboardType: TextInputType.emailAddress,
                                          //           decoration: InputDecoration(labelText: 'Email Address',
                                          //           contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                                          //           onSaved: (value){
                                          //             _emailAddress = value;
                                          //           }
                                          //         ) ,
                                          //       ),
                                          //       Container(
                                          //         margin: EdgeInsets.symmetric(vertical: 20.0),
                                          //         child: RaisedButton(
                                          //           color: Colors.greenAccent[700],
                                          //           onPressed: (){
                                          //             _saveProfile();
                                          //           },
                                          //           child: Row(

                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             children: <Widget>[
                                          //                 Container(
                                          //                   padding: EdgeInsets.only(right: 8.0),
                                          //                   child: Icon(Icons.save,
                                          //                     color: Colors.white,
                                          //                   ),),
                                          //                 Text('Update Profile',
                                          //                     style: TextStyle(
                                          //                       fontFamily: 'Gilroy',fontWeight: FontWeight.bold, 
                                          //                       fontSize: 18.0, color: Colors.white
                                          //                     ),
                                          //                 )
                                          //             ],)
                                          //       )
                                                
                                          //     )
                                          //           ]
                                          //         ),
                                                
                                          //     )
                                          //       );
                                      }
                                    )
                                    
                                    
                              ]
                            )
                            )
                );
        },
        converter: (store) => store.state ,);
     
    
  }
}

/*


Container(
                color: Colors.greenAccent,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: new BoxDecoration(
                                  // color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white60,
                                  child: Text('AH',
                                    style: TextStyle(
                                      color: Colors.white, fontFamily: 'Gilroy', fontWeight: FontWeight.bold, 
                                      fontSize: 26.0
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  iconSize: 32.0,
                                  icon: Icon(LineIcons.camera_retro) ,
                                 onPressed: (){
                                   print('change photo requested');
                                 }),
                              )
                        ],
                        )
              )
*/