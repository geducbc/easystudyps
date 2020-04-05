import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/pages/LandingPage.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:http/http.dart' as http;

class SelectSubjectPage extends StatefulWidget {
  final String classSelected;
  SelectSubjectPage(this.classSelected);
  
  State<StatefulWidget> createState() => SelectedSubjectState();
  
}

class SelectedSubjectState extends State<SelectSubjectPage>{
  var subjects = [];
  final String user = 'Bukola Damola';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subjects = [
          {'id': 1, 'subject': 'English Language'},
          {'id': 2, 'subject': 'Matematics'},
          {'id': 3, 'subject': 'Health Education'},
          {'id': 4, 'subject': 'Computer Science'},
          
      ];
    print(widget.classSelected);
  }
  _hanldeNavigationToCourseDetailPage(Map<String, dynamic> selectedSubject, String schoolLevel){
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
      _fetchSubjectMaterials(selectedSubject,schoolLevel, context);
    
  }
   _fetchSubjectMaterials(Map<String, dynamic> selectedSubject,schoolLevel, BuildContext context) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString(schoolLevel + selectedSubject['subject']) == null){
          final response = await http.get(prefs.getString('appDomain')+'materials.php?id='+ selectedSubject['id']);
            if (response.statusCode == 200) {
            final responseSubjects = json.decode(response.body);

            prefs.setString(schoolLevel + selectedSubject['subject'] , json.encode(responseSubjects['materials']));

          } else {
            // If the server did not return a 200 OK response,
            // then throw an exception.
            Navigator.of(context).pop();
            return throw Exception('Failed to load subjects');
          }
      }
      Navigator.of(context).pop();
      StoreProvider.of<AppState>(context).dispatch(SelectSubject(selectedSubject));
      Navigator.of(context).pushReplacementNamed('/viewsubject');
      
  }
  Future getSubject(AppState state) async{
    print('app state'+ state.educationLevel.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(state.educationLevel == 'primary'){
      print('helllo');
      // final Map<dynamic, dynamic> response = prefs.getString('primary_subjects');
      final data = prefs.getString('primary_subjects');
      try{
          // print(json.decode(data));
          var response = json.decode(data);
          print(response);
          return response;
      }catch(error){
        print(error);
      }
    }
    else if(state.educationLevel == 'Junior School'){
      print('helllo');
      // final Map<dynamic, dynamic> response = prefs.getString('primary_subjects');
      final data = prefs.getString('junior_subjects');
      try{
          // print(json.decode(data));
          var response = json.decode(data);
          print(response);
          return response;
      }catch(error){
        print(error);
      }
    }
    else if(state.educationLevel == 'Senior School'){
      print('helllo');
      // final Map<dynamic, dynamic> response = prefs.getString('primary_subjects');
      final data = prefs.getString('senior_subjects');
      try{
          // print(json.decode(data));
          var response = json.decode(data);
          print(response);
          return response;
      }catch(error){
        print(error);
      }
    }
  }
  Future<String> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = json.decode(prefs.getString('user'));
    return user['firstName'] + " " + user['lastName'];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int count = 0;
    return StoreConnector<AppState, AppState>(
        builder: (context, state){
          return Scaffold(
      appBar: AppBar(
         title: Text('Select your subject'),
         backgroundColor: Colors.blueAccent,
        ),
      endDrawer: FutureBuilder(
        future: getLoggedInUser() ,
        builder: (context, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                 if(snapshot.hasData){
                      return  Drawer(
                            child: SafeArea(
                              child: Column(
                                crossAxisAlignment:  CrossAxisAlignment.start,
                                children: <Widget>[
                                Container(

                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                  ),
                                  child: Center(
                                    child: Text(snapshot.data,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(

                                        color: Colors.white, fontFamily: 'Gilroy',
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800
                                        ),
                                    ) ,)
                                ,),
                                SizedBox(height: 20,),
                                FlatButton(child: Card(
                                            child: ListTile(
                                              title: Text('Home'),
                                              leading: Icon(Icons.home),
                                            ),
                                          ),
                                onPressed: (){
                                  Navigator.pop(context);
                                  StoreProvider.of<AppState>(context).dispatch(TabIndex(0));
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                                }
                                ),
                                FlatButton(child: Card(
                                            child: ListTile(
                                              title: Text('Learning'),
                                              leading: Icon(LineIcons.book),
                                            ),
                                          ),
                                onPressed: (){
                                  Navigator.pop(context);
                                  StoreProvider.of<AppState>(context).dispatch(TabIndex(1));
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                                }
                                ),
                                FlatButton(child: Card(
                                            child: ListTile(
                                              title: Text('Classroom'),
                                              leading: Icon(LineIcons.users),
                                            ),
                                          ),
                                onPressed: (){
                                  Navigator.pop(context);
                                  StoreProvider.of<AppState>(context).dispatch(TabIndex(2));
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                                }
                                ),
                                FlatButton(child: Card(
                                            child: ListTile(
                                              title: Text('Profile'),
                                              leading: Icon(LineIcons.user),
                                            ),
                                          ),
                                onPressed: (){
                                  Navigator.pop(context);
                                  StoreProvider.of<AppState>(context).dispatch(TabIndex(3));
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                                }
                                )
                            ],)
                            ,) 
                            
                          );
                 }
                 return  Drawer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: <Widget>[
                Container(

                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: Center(
                    child: Text('',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        color: Colors.white, fontFamily: 'Gilroy',
                          fontSize: 26,
                          fontWeight: FontWeight.w800
                        ),
                    ) ,)
                ,),
                SizedBox(height: 20,),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Home'),
                              leading: Icon(Icons.home),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(0));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Learning'),
                              leading: Icon(LineIcons.book),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(1));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Classroom'),
                              leading: Icon(LineIcons.users),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(2));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Profile'),
                              leading: Icon(LineIcons.user),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(3));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                )
            ],)
            ,) 
            
          );
              }
              return  Drawer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: <Widget>[
                Container(

                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: Center(
                    child: Text('',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        color: Colors.white, fontFamily: 'Gilroy',
                          fontSize: 26,
                          fontWeight: FontWeight.w800
                        ),
                    ) ,)
                ,),
                SizedBox(height: 20,),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Home'),
                              leading: Icon(Icons.home),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(0));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Learning'),
                              leading: Icon(LineIcons.book),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(1));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Classroom'),
                              leading: Icon(LineIcons.users),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(2));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                ),
                FlatButton(child: Card(
                            child: ListTile(
                              title: Text('Profile'),
                              leading: Icon(LineIcons.user),
                            ),
                          ),
                onPressed: (){
                  Navigator.pop(context);
                  StoreProvider.of<AppState>(context).dispatch(TabIndex(3));
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                }
                )
            ],)
            ,) 
            
          );
          } 
        ,),
      body: FutureBuilder(
        future: getSubject(state),
        builder: (context, AsyncSnapshot snapshot){
           if(snapshot.connectionState == ConnectionState.done){
             if(snapshot.hasData){
               print(snapshot.data);
               return  StoreConnector<AppState,AppState>(converter: (store) => store.state,
                builder: (context, state){
                  return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Expanded(
                            child: ListView(children: <Widget>[
                          Container(child: GridView.count(
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          physics: ScrollPhysics(), // to disable GridView's scrolling
                          shrinkWrap: true,
                          children: snapshot.data.map<Widget>((var item){
                            count = count + 1;
                            return GestureDetector(child: Container(
                                            // width: 300,
                                            decoration: BoxDecoration(
                                              color: count / 2 == 0 ? Colors.deepPurpleAccent : Colors.deepPurple,
                                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                              boxShadow: [
                                                          new BoxShadow(
                                                            color: Colors.grey[300],
                                                            offset: new Offset(4.0, 2.0),
                                                          )
                                                        ]
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                                            child: Center(child: Text(item['subject'],
                                                style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Gilroy',
                                                      fontSize: 18
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                        ), onTap: (){
                                          
                                          _hanldeNavigationToCourseDetailPage(item, state.schoolLevel);
                                        }
                                        ,);
                          }).toList(),
                        ))
                        ],),
                          )
                        ],);
                },
               );
             }
             return Container(color: Colors.white);
           }
           return Container(color: Colors.white);
        },),
    );
        },
    
        converter: (store) => store.state ,);
  }
}