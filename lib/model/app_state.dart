import 'package:flutter/material.dart';

class AppState{
  int selectedTabIndex;
  var selectedSubject;
  Map<String, dynamic> selectedMaterial;
  Map<String, dynamic> selectedRoom;
  String educationLevel = "";
  String user = "";
  String schoolLevel = "";
  List<dynamic> materials = [];
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
  }
}