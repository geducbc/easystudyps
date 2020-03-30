
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:badges/badges.dart';

class SubjectDetailPage extends StatelessWidget{
  final String user = 'Bukola Damola';
  final List<Map<String, dynamic>> courseMaterial = [
    {'id': 1, 'name': 'Trignometry', 'type':'pdf', 'url': 'https://pdfkit.org/docs/guide.pdf'},
    {'id': 2, 'name': 'Comprehension', 'type':'video', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'},
    {'id': 3, 'name': 'Equations', 'type':'audio', 'url': 'https://pdfkit.org/docs/guide.pdf'},
    {'id': 4, 'name': 'Algebraic Expressions', 'type':'video', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'},
    {'id': 5, 'name': 'Common Factors', 'type':'pdf', 'url': 'https://pdfkit.org/docs/guide.pdf'}
  ];
  renderIcon(Map<String, dynamic> material){
    switch(material['type']){
      case 'pdf':
        return LineIcons.file_pdf_o;
      case 'video':
        return LineIcons.play_circle;
      case 'audio':
        return LineIcons.music;
      default:
        return LineIcons.book;
    }
  }
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    // TODO: implement build   
    return StoreConnector<AppState, AppState>( 
      converter: (store) => store.state, 
      builder: (context, state){
        print(state.selectedSubject.toString());
        return Scaffold(
          appBar: AppBar(
         title: Text(state.selectedSubject['subject']),
         backgroundColor: Colors.blueAccent,
        ),
          endDrawer:  Drawer(
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
        
      ) ,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: ListView(children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: deviceHeight * 0.32,
                    padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                            
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/study3.jpg'),
                        )
                    ),
                    child: Text(
                      state.selectedSubject['subject'],
                      style: TextStyle(color: Colors.white,
                      fontSize: 18, fontWeight: FontWeight.bold,
                       fontFamily: 'Gilroy'),
                    )
                  ,),
                  SizedBox(height: 20.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text('Resources',
                          style: TextStyle(
                            color: Colors.black87, fontFamily: 'Gilroy', fontSize: 18.0, 
                            fontWeight: FontWeight.bold
                          ),
                        ),

                      ),
                      Container(
                        child: RaisedButton(
                          onPressed: (){
                            StoreProvider.of<AppState>(context).dispatch(TabIndex(2));
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()) );
                          },
                          color: Colors.white,
                          child: Text('Join Classroom'),
                        ) ,)
                    ]
                  )
                  ,),
                  SizedBox(height: 8.0,),
                  Container(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      physics: ScrollPhysics(), // to disable GridView's scrolling
                      shrinkWrap: true,
                      children: courseMaterial.map((Map<String, dynamic> material){
                        return FlatButton(
                            child: Card(
                              child: ListTile(
                                title: Text(material['name']),
                                leading: Icon(Icons.book),
                                trailing: CircleButton(
                                        onTap: (){},
                                        iconData: renderIcon(material)
                                      ),
                              ),
                            ),
                            onPressed: (){
                              StoreProvider.of<AppState>(context).dispatch(SelectedMaterial(material));
                              if(material['type'] == 'pdf'){
                                
                                return Navigator.of(context).pushNamed('/pdfview');
                              }
                              if(material['type'] == 'video'){
                                return Navigator.of(context).pushNamed('/videoView');
                              }
                              print('her insider o');
                            },
                          );
                      }).toList(),) ,
                  )

              ],))
            ]
          ) ,
          floatingActionButton: Builder(builder: (BuildContext context){
                  return FloatingActionButton(
                  child: new Icon(LineIcons.sticky_note),
                  onPressed: (){
                    print('pressed o');
                    Scaffold.of(context).openDrawer();
                  },
                );
          },),
        );
      });
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }

}