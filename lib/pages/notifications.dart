import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/model/appUser.dart';

class Notifications extends StatefulWidget{
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications>{
  Firestore _firestore = Firestore.instance;
  AppUser _appUser = AppUser(); 
  Future<AppUser> getUserDetails() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var user = json.decode(_prefs.getString('user'));
    
    _appUser.setUserSchoolCode(user['schoolCode']);
    return _appUser;
  }
  void onSelect(BuildContext context, DocumentSnapshot doc){
    print(doc.data);
    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:  AppBar(
        title: Text('Notifications'),
            backgroundColor:  Colors.blueAccent,
          ),
      
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  return StreamBuilder(
                      stream: _firestore.collection('notifications')
                        .where('schoolCode', isEqualTo: snapshot.data.getSchoolCode())
                        .orderBy('createdAt').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.connectionState != ConnectionState.waiting){
                              if(!snapshot.hasError){
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical:16.0),
                                  child: ListView(
                                      children: snapshot.data.documents.map((DocumentSnapshot doc){
                                          return Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Card(
                                                child: ListTile(
                                                  onTap: (){
                                                    onSelect(context, doc);
                                                  },
                                                  title: Text(doc['quizName']),
                                                  subtitle: Text(doc['type']),
                                                  trailing: Badge(
                                                    borderRadius: 4.0,
                                                    badgeColor: Colors.redAccent,
                                                    shape: BadgeShape.square,
                                                    badgeContent: Text('New',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Gilroy'
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              )
                                          );
                                      }).toList()
                                    )
                                );
                              }
                              return Container(
                                child: Center(
                                  child: Text('No new notification! ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ) ,),
                              );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                                  
                                )
                          );
                      }
                    );
                }
                return Container();
            }
            return Container();
        }),
    );
  }
}