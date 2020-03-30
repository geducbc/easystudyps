import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/redux/actions.dart';

class ClassRoom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClassRoomState();
  }
}

class _ClassRoomState extends State<ClassRoom>{
  final List<Map<String, dynamic>> classRooms = [
    {'id': 1, 'subject': 'Maths', 'category':'Primay 1', 'roomName': 'Primary One Maths', 'lastJoined':''},
    {'id': 1, 'subject': 'Biology', 'category':'Primay 1', 'roomName': 'Primary One Biology', 'lastJoined':''},
    {'id': 1, 'subject': 'English', 'category':'Primay 1', 'roomName': 'Primary One English', 'lastJoined':''},
    {'id': 1, 'subject': 'Physics', 'category':'Primay 1', 'roomName': 'Primary One Physics', 'lastJoined':''}
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final double deviceHeight = MediaQuery.of(context).size.height;
    
    // TODO: implement build
    return StoreConnector<AppState,AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
                width: double.infinity,
                height: deviceHeight,
                decoration: BoxDecoration(             
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/chatbg.jpeg'),
                    )
                  ),
              child: SafeArea(
                minimum: EdgeInsets.symmetric(vertical: 40.0),
                child: classRooms.length > 0 ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Your Classrooms',
                        style: TextStyle(fontFamily: 'Gilroy', fontSize: 26.0, 
                        fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16.0,),
                    Container(
                      child: ListView(
                        physics: ScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        children: classRooms.map((Map<String, dynamic> room){
                            return FlatButton(
                              onPressed: (){
                                StoreProvider.of<AppState>(context).dispatch(SelectedRoom(room));
                                Navigator.of(context).pushNamed('/chatroom');
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(room['roomName']),
                                  leading: Icon(Icons.book),
                                  trailing: CircleButton(
                                          onTap: (){},
                                          iconData: Icons.chat
                                        ),
                                ),
                              )
                            );
                        }).toList()
                        ,)
                        ,)
                ],): Center(
                  child: Container(
                    child: RaisedButton(onPressed: (){},
                    color: Colors.deepOrangeAccent,
                     textColor: Colors.white,
                      child: Text('No Classroom found, Join Classroom'),
                    )
                    ,)
                ) ,)
              ,);
      },);
  }
}

/*
[
    {'id': 1, 'subject': 'Maths', 'category':'Primay 1', 'roomName': 'Primary One Maths', 'lastJoined':''},
    {'id': 1, 'subject': 'Biology', 'category':'Primay 1', 'roomName': 'Primary One Maths', 'lastJoined':''},
    {'id': 1, 'subject': 'English', 'category':'Primay 1', 'roomName': 'Primary One Maths', 'lastJoined':''},
    {'id': 1, 'subject': 'Physics', 'category':'Primay 1', 'roomName': 'Primary One Maths', 'lastJoined':''}
  ]

*/

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