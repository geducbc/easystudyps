import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:bubble/bubble.dart';

class ChatRoom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatRoomState();
  }
}

class _ChatRoomState extends State<ChatRoom>{
  final String user = 'Bukola Damola';
  
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
    return StoreConnector<AppState, AppState>(
      converter:(store) => store.state,
      builder: (context, state){
        return Scaffold(
            appBar:  AppBar(
                  title: Text(state.selectedRoom['roomName']),
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
                              Bubble(
                                style: styleMe,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                  
                                  SizedBox(height: 6.0,),
                                  Text('Whats\'up?')
                                ]),
                              ),
                              
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
                  //    Positioned(
                  //   child: new Align(
                  //     alignment: FractionalOffset.bottomLeft,
                  //     child: Container(
                  //       height: 32.0,
                  //        width: double.infinity,
                  //        color: Colors.black,
                  //       child: Container(
                  //         height: 32.0,
                  //         width: double.infinity,
                  //         child: Row(children: <Widget>[
                  //           Center(
                  //             child: TextField(
                  //                   decoration: InputDecoration(
                  //                     // border: InputBorder.none,
                  //                     hintText: 'Enter a search term'
                  //                   ),
                  //                 )
                  //           ,)
                  //         ],)
                  //       )
                  //     )
                  //   )
                  // )
                  ],)
            )
             ,
             
            // bottomNavigationBar: Container(
            //             height: 32.0,
            //              width: double.infinity,
            //             //  color: Colors.green,
            //             child:  Row(children: <Widget>[
            //                 Container(
            //                   child: TextFormField(
            //                           decoration: InputDecoration(
            //                             labelText: 'Enter your username'
            //                           ),
            //                         )
            //                 )
            //               ],)
            //           ),
        );
      },
    );
  }
}