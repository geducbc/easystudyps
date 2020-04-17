import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/model/appUser.dart';


class Assessment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment>{
  Firestore _firestore = Firestore.instance;
  AppUser _appUser = AppUser();

  Future<AppUser> getUserDetails() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var user = json.decode(_prefs.getString('user'));
    // ''.toUpperCase()
    // 'hhbui'.substring(startIndex)
    _appUser.setUserSchoolCode(user['schoolCode']);
    return _appUser;
  }

  gotoAssessmentDetailPage(BuildContext context, DocumentSnapshot doc){
    print('pressed');
    Navigator.of(context).pushNamed('/assessmentDetail');
    print(doc.data);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:  AppBar(
        title: Text('Assessment'),
        backgroundColor:  Colors.blueAccent,
      ),
      
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        child: FutureBuilder(
          future: getUserDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  return StreamBuilder(
                    stream:_firestore.collection('assessments')
                        .where('schoolCode', isEqualTo: snapshot.data.getSchoolCode())
                        .orderBy('createdAt').snapshots() ,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.connectionState != ConnectionState.waiting){
                            if(snapshot.hasData){
                                return Container(
                                  child: 
                                    ListView(
                                      children: snapshot.data.documents.map((DocumentSnapshot doc){
                                        return Card(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 16.0),
                                              child: ListTile(
                                              onTap: () {
                                                gotoAssessmentDetailPage(context, doc);
                                              },
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor: Colors.deepOrangeAccent,
                                                child: Text(doc['subject'].substring(0, 1).toUpperCase(),
                                                  style: TextStyle(
                                                    color:Colors.white, fontFamily: 'Gilroy',
                                                    fontSize: 18.0, fontWeight: FontWeight.bold
                                                    ),
                                                ),
                                              ),
                                              title: Text(doc['subject'],
                                                style: TextStyle(
                                                    color:Colors.black, fontFamily: 'Gilroy',
                                                    fontSize: 16.0, fontWeight: FontWeight.bold
                                                    ),
                                                
                                              ),
                                              subtitle: Row(children: <Widget>[
                                                Text('Due Date: ',
                                                    style: TextStyle(
                                                        color:Colors.black, fontFamily: 'Gilroy',
                                                        
                                                        ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Text(doc['validUntil'],
                                                    style: TextStyle(
                                                        color:Colors.black, fontFamily: 'Gilroy',
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                  )

                                              ],),
                                              trailing: Icon(Icons.arrow_forward_ios),
                                            )
                                            ),
                                          );
                                      }).toList()
                                    )
                                  
                                );
                            }
                            return Container(
                              child: Center(
                                child: Text('No assessments found'),)
                            );
                        }
                        return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),)
                              );
                    });
                }
                return Container(
                  child: Center(
                    child: Text('No assessments found'),)
                ); 
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),)
            );
          })
      ),
    );
  }
}