import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/pages/LandingPage.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:studyapp/model/app_state.dart';

class SelectSubjectPage extends StatefulWidget {
  final String classSelected;
  SelectSubjectPage(this.classSelected);
  
  State<StatefulWidget> createState() => SelectedSubjectState();
  
}

class SelectedSubjectState extends State<SelectSubjectPage>{
  List<Map<String, dynamic>> subjects = [];
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
  _hanldeNavigationToCourseDetailPage(Map<String, dynamic> selectedSubject){
    StoreProvider.of<AppState>(context).dispatch(SelectSubject(selectedSubject));
    Navigator.of(context).pushReplacementNamed('/viewsubject');
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int count = 0;
    return Scaffold(
      appBar: AppBar(
         title: Text('Select your subject'),
         backgroundColor: Colors.blueAccent,
        ),
      endDrawer: Drawer(
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
                child: Text(user,
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
        
      ),
      body: Column(
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
        children: subjects.map((Map<String, dynamic> item){
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
                        _hanldeNavigationToCourseDetailPage(item);
                      }
                      ,);
        }).toList(),
      ))
      ],),
        )
      ],),
    );
  }
}