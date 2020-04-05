import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/pages/LandingPage.dart';
import 'package:studyapp/pages/SubjectDetailPage.dart';
import 'package:studyapp/pages/chatroom.dart';
import 'package:studyapp/pages/classroom.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/pages/learning.dart';
import 'package:studyapp/pages/login.dart';
import 'package:studyapp/pages/pdfViewer.dart';
import 'package:studyapp/pages/profile.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/pages/subjectPages.dart';
import 'package:studyapp/pages/videoPlayer.dart';
import 'package:studyapp/redux/reducers.dart';
import 'package:studyapp/redux/actions.dart';



void main() {
  // SharedPreferences.setMockInitialValues({});
  final _initialState = AppState(selectedTabIndex: 0);
  final Store<AppState> _store = Store<AppState>(reducer, initialState: _initialState);
  runApp(MyApp(_store));
} 


class MyApp extends StatelessWidget {
  
  // final SharedPreferences prefs;
  final Store<AppState> store;
  MyApp(this.store);
  Future getLocalUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('user');
    return prefs.getString('user');
  }
  @override
  Widget build(BuildContext context)  {
     
     return FutureBuilder(future: getLocalUser(),
      builder: (context, AsyncSnapshot snapshot){
        print(snapshot.hasData);
        if(snapshot.connectionState == ConnectionState.done){
          print(snapshot.data);
          return snapshot.hasData ?  StoreProvider<AppState>(store: store, 
                  child: MaterialApp(
                    title: 'Study App',
                    theme: ThemeData(
                        primaryColor: Colors.grey[800],
                      ),
                      home: Home(),
                      initialRoute: '/',
                      routes: {
                        '/app': (context) => Home(),
                        '/home': (context) => LandingPage(),
                        '/learning': (context) => Learning(),
                        '/classroom': (context) => ClassRoom(),
                        '/profile': (context) => Profile(),
                        '/viewsubject': (context) => SubjectDetailPage(),
                        '/pdfview': (context) => PdfViewer(),
                        '/videoView': (context) => VideoPlayerWidget(),
                        '/chatroom': (context) => ChatRoom()
                      },
                      onGenerateRoute: (RouteSettings setting){
                        final List<String> pathElements = setting.name.split('/');
                        if(pathElements[0] != ''){
                          return null;
                        }
                        if(pathElements[1] == 'selectSubjects'){
                            return MaterialPageRoute(builder: (BuildContext context)  {
                              return SelectSubjectPage(pathElements[2]);
                            });
                        }
                        // if(pathElements[1] == 'viewsubject'){
                        //   return MaterialPageRoute(builder: (BuildContext context)  {
                        //       return SubjectDetailPage();
                        //     });
                        // }
                        return null;
                      }
                  )
                  ) :  StoreProvider<AppState>(store: store, 
                  child: MaterialApp(
                    title: 'Study App',
                    theme: ThemeData(
                        primaryColor: Colors.grey[800],
                      ),
                      home: Login(),
                      initialRoute: '/',
                      routes: {
                        '/app': (context) => Home(),
                        '/home': (context) => LandingPage(),
                        '/learning': (context) => Learning(),
                        '/classroom': (context) => ClassRoom(),
                        '/profile': (context) => Profile(),
                        '/viewsubject': (context) => SubjectDetailPage(),
                        '/pdfview': (context) => PdfViewer(),
                        '/videoView': (context) => VideoPlayerWidget(),
                        '/chatroom': (context) => ChatRoom()
                      },
                      onGenerateRoute: (RouteSettings setting){
                        final List<String> pathElements = setting.name.split('/');
                        if(pathElements[0] != ''){
                          return null;
                        }
                        if(pathElements[1] == 'selectSubjects'){
                            return MaterialPageRoute(builder: (BuildContext context)  {
                              return SelectSubjectPage(pathElements[2]);
                            });
                        }
                        // if(pathElements[1] == 'viewsubject'){
                        //   return MaterialPageRoute(builder: (BuildContext context)  {
                        //       return SubjectDetailPage();
                        //     });
                        // }
                        return null;
                      }
                  )
                  );
        }
        return Container(color: Colors.white);
      },
     );
  } 
}


