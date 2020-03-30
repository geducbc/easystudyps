import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/pages/home.dart';
import 'package:studyapp/redux/actions.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PdfViewerState();
  }
}

class _PdfViewerState extends State<PdfViewer>{
  final String user = 'Bukola Damola';
  String pathPDF = "";
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('state loaded');
    
  }

   Future<File> createFileOfPdfUrl(Map<String, dynamic> material) async {
    // final url =
    // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // final url = "https://pdfkit.org/docs/guide.pdf";
    final url = material['url'];
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    print('bytes: '+ bytes.toString());
    await file.writeAsBytes(bytes);
    print('file binary: '+file.toString());
    return file;
  }
  getDownloadMaterial(Map<String, dynamic> material){
    createFileOfPdfUrl(material).then((f) {
      setState(() {
        pathPDF = f.path;
        print('pfg of is: '+pathPDF);
      });
    }).catchError((t){
      print('erros is'+ t.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('file: '+ pathPDF);
    
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if(pathPDF.isEmpty){
          getDownloadMaterial(state.selectedMaterial);
        }
        print('selected: '+ state.selectedMaterial.toString());
        if(state.selectedMaterial != null){
            return Scaffold(

          // appBar: AppBar(
          //   title: Text(state.selectedMaterial['name']),
          //   backgroundColor: Colors.blueAccent,
          // ),
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
        
      ) ,
          body: Stack(children: <Widget>[
                pathPDF.isNotEmpty ? PDFViewerScaffold(
        appBar: AppBar(
          title: Text(state.selectedMaterial['name']),
          actions: <Widget>[
            IconButton(
              icon: Icon(LineIcons.sticky_note_o),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF) : 
          Center(
                      child: CircularProgressIndicator(),
          ),
          // errorMessage.isEmpty
          //     ? !isReady
          //         ? Center(
          //             child: CircularProgressIndicator(),
          //           )
          //         : Container()
          //     : Center(
          //         child: Text(errorMessage),
          //       )
          ],),
        );
        }
        return Scaffold(
          body: Center(child: Text(''),)
        );
      });
    
        
  }
}

/*
PDFView(
            filePath:  pathPDF,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            defaultPage: currentPage,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
                print('on render is called: '+ pages.toString());
              });
              
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
                print('error is in here: ' + error.toString());
              });
              print('error is: ' + error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
                print('page error is: ' + '$page: ${error.toString()}');
              });
              
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
              print('view created');
            },
            onPageChanged: (int page, int total) {
              print('error is: ' +'page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          )

          PDFViewerScaffold(
        appBar: AppBar(
          title: Text(state.selectedMaterial['name']),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF)
*/