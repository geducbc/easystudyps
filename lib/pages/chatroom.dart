import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:bubble/bubble.dart';
import 'dart:core';


class ChatRoom extends StatefulWidget{
  String selectedRoom = '';
  ChatRoom();
  ChatRoom.fromselectedRoom(this.selectedRoom);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatRoomState();
  }
}

class _ChatRoomState extends State<ChatRoom>{
  final String user = 'Bukola Damola';
   String _message = '';
  String currentUser = '';
  SharedPreferences prefs;
  var userDetails;
  final TextEditingController _controller =  new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserDetails();
  }
  getCurrentUserDetails() async{
    prefs = await SharedPreferences.getInstance();
    userDetails = json.decode(prefs.getString('user'));
  }
  _sendMessage(String roomname,BuildContext context) async{
      if(_message.isNotEmpty){
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) {
        //     return Dialog(
        //       child: Container(
        //         padding: EdgeInsets.symmetric(vertical:16.0, horizontal: 16.0),
        //         child: new Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           new CircularProgressIndicator(),
        //           Container(padding: EdgeInsets.symmetric(horizontal:16.0),
        //             child: new Text("Loading"),
        //           )
        //         ],
        //       ),),
        //     );
        //     });
        _controller.clear();
        await Firestore.instance.collection('chats').document('rooms')
            .collection(roomname).add({
              'senderId': (await FirebaseAuth.instance.currentUser()).uid,
              'message': _message,
              'sender': userDetails['firstName'] + ' ' + userDetails['lastName'],
              'createdAt': new DateTime.now()
            });
        
        // Navigator.of(context).pop();
      }
      
  }

  Future<String> getCurrentUser() async{
      if(currentUser.isEmpty){
         currentUser = (await FirebaseAuth.instance.currentUser()).uid;
      }
      return currentUser;
  }
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    // TODO: implement build
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: StreamBuilder(
      stream: Firestore.instance.collection('chats').document('rooms').collection(widget.selectedRoom)
                .orderBy('createdAt').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState != ConnectionState.waiting){
             if(!snapshot.hasError){
               
               return StoreConnector<AppState, AppState>(
                        converter:(store) => store.state,
                        builder: (context, state){
                          return Scaffold(
                              appBar:  AppBar(
                                    title: Text(state.selectedRoom['roomname']),
                                    backgroundColor: Colors.blueAccent,
                                    actions: <Widget>[
                                              IconButton(
                                              icon: Icon(
                                                Icons.video_call,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                // do something  
                                                bool canlaunch = await canLaunch('skype:username');
                                                if(canlaunch){
                                                  final bool nativeAppLaunchSucceeded = await launch(
                                                                                          'skype:username',
                                                                                        );
                                                    if(!nativeAppLaunchSucceeded){
                                                        AlertDialog(
                                                              content: Text('Skype not installed, please install to continue'),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text('Ok'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop(false);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                            return ;
                                                    }
                                                }
                                                  AlertDialog(
                                                    content: Text('Skype not installed, please install to continue'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Ok'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop(false);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                print('pressed');
                                                return;
                                              },
                                            )
                                          ]
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
                          
                        )  ,
                              body: Container(
                                width: double.infinity,
                                  height: deviceHeight,
                                  decoration: BoxDecoration(             
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/chatbg.jpeg'),
                                      )
                                  ),
                                child: Stack(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                          Expanded(child: 
                                            ListView(
                                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                          physics: ScrollPhysics(), // to disable GridView's scrolling
                                          shrinkWrap: true,
                                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                                            return FutureBuilder(
                                              future: getCurrentUser(),
                                              builder: (BuildContext context,AsyncSnapshot snapshot){
                                                if(snapshot.connectionState == ConnectionState.done){
                                                  if(snapshot.hasData){
                                                    if(snapshot.data == document['senderId']){
                                                      return Bubble(
                                                              style: styleMe,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                
                                                                SizedBox(height: 6.0,),
                                                                Text(document['message'])
                                                              ]),
                                                            );
                                                    }
                                                    return Bubble(
                                                              style: styleSomebody,
                                                              child: Container(child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Container(
                                                                    child: Text(document['sender'],
                                                                      style: TextStyle(
                                                                        color: Colors.grey[800]
                                                                      ),
                                                                    ) ,),
                                                                    SizedBox(height: 6.0,),
                                                                    Text(document['message'])
                                                                ],
                                                              ),),
                                                            );
                                                  }
                                                  return Container();
                                                }
                                                return Container();
                                              },);
                                          }).toList(),
                                        
                                        )
                                          ,
                                        ),
                                      Container(
                                      color: Colors.white,
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: TextField(
                                          controller: _controller,
                                          maxLines: 20,
                                          // controller: '',
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.send),
                                              onPressed: () {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                _sendMessage(state.selectedRoom['roomname'], context);
                                              },
                                            ),
                                            border: InputBorder.none,
                                            hintText: "enter your message",
                                          ),
                                          onChanged: (text) {
                                            _message = text;
                                            // print("First text field: $text");
                                          }
                                        ),
                                      ),
                                      )
                                    ],)
                                    
                                    ],)
                              )
                              ,
                              
                          );
                        },
                      );
             }
             
            return StoreConnector<AppState, AppState>(
                    converter:(store) => store.state,
                    builder: (context, state){
                      return Scaffold(
                          appBar:  AppBar(
                                title: Text(state.selectedRoom['roomname']),
                                backgroundColor: Colors.blueAccent,
                                actions: <Widget>[
                                          IconButton(
                                          icon: Icon(
                                            Icons.video_call,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async{
                                            // do something
                                            
                                            // if(){

                                            // }
                                            print('pressed');
                                          },
                                        )
                                      ]
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
                      
                    )  ,
                          body: Container(
                            width: double.infinity,
                              height: deviceHeight,
                              decoration: BoxDecoration(             
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/chatbg.jpeg'),
                                  )
                              ),
                            child: Stack(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Expanded(child: 
                                        ListView(
                                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                      physics: ScrollPhysics(), // to disable GridView's scrolling
                                      shrinkWrap: true,
                                      children: <Widget>[
                                            
                                    ],)
                                      ,
                                    ),
                                  Container(
                                  color: Colors.white,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      maxLines: 20,
                                      // controller: '',
                                      decoration: InputDecoration(
                                        // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {},
                                        ),
                                        border: InputBorder.none,
                                        hintText: "enter your message",
                                      ),
                                      onChanged: (text) {
                                        print("First text field: $text");
                                      }
                                    ),
                                  ),
                                  )
                                ],)
                                ],)
                          )
                          ,
                          
                      );
                    },
                  );
          }
          
          return StoreConnector<AppState, AppState>(
                      converter:(store) => store.state,
                      builder: (context, state){
                        return Scaffold(
                            appBar:  AppBar(
                                  title: Text(state.selectedRoom['roomname']),
                                  backgroundColor: Colors.blueAccent,
                                  actions: <Widget>[
                                            IconButton(
                                            icon: Icon(
                                              Icons.video_call,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // do something
                                              print('pressed');
                                            },
                                          )
                                        ]
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
                        
                      )  ,
                            body: Container(
                              width: double.infinity,
                                height: deviceHeight,
                                decoration: BoxDecoration(             
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/chatbg.jpeg'),
                                    )
                                ),
                              child: Stack(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Expanded(child: 
                                          ListView(
                                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                        physics: ScrollPhysics(), // to disable GridView's scrolling
                                        shrinkWrap: true,
                                        children: <Widget>[
                                            
                                      ],)
                                        ,
                                      ),
                                    Container(
                                    color: Colors.white,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextField(
                                        maxLines: 20,
                                        // controller: '',
                                        decoration: InputDecoration(
                                          // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {},
                                          ),
                                          border: InputBorder.none,
                                          hintText: "enter your message",
                                        ),
                                        onChanged: (text) {
                                          print("First text field: $text");
                                        }
                                      ),
                                    ),
                                    )
                                  ],)
                                  ],)
                            ),
                        );
                      },
                    );
      } ,)
   ,
    );
    
  }
}

/*

 Bubble(
    style: styleSomebody,
    child: Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text('User',
            style: TextStyle(
              color: Colors.grey[800]
            ),
          ) ,),
          SizedBox(height: 6.0,),
          Text('Hi Jason. Sorry to bother you. I have a queston for you.')
      ],
    ),),
  ),

   Bubble(
    style: styleMe,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      
      SizedBox(height: 6.0,),
      Text('Whats\'up?')
    ]),
  ),
                                                
                                                

*/
