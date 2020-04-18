import 'package:flutter/material.dart';
import 'package:studyapp/model/test.dart';

class AppState{
  int selectedTabIndex;
  var selectedSubject;
  Map<String, dynamic> selectedMaterial;
  Map<String, dynamic> selectedRoom;
  String educationLevel = "";
  String user = "";
  String schoolLevel = "";
  List<dynamic> materials = [];
  Test testSelected;
  AppState({this.selectedTabIndex});
  
  AppState.fromAppState(AppState anotherState){
    selectedTabIndex = anotherState.selectedTabIndex;
    selectedSubject = anotherState.selectedSubject;
    selectedMaterial = anotherState.selectedMaterial;
    selectedRoom = anotherState.selectedRoom;
    educationLevel = anotherState.educationLevel;
    user = anotherState.user;
    schoolLevel = anotherState.schoolLevel;
    materials = anotherState.materials;
    testSelected = anotherState.testSelected;
  }
}