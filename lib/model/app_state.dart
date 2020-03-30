import 'package:flutter/material.dart';

class AppState{
  int selectedTabIndex;
  Map<String, dynamic> selectedSubject;
  Map<String, dynamic> selectedMaterial;
  Map<String, dynamic> selectedRoom;
  AppState({this.selectedTabIndex});
  
  AppState.fromAppState(AppState anotherState){
    selectedTabIndex = anotherState.selectedTabIndex;
    selectedSubject = anotherState.selectedSubject;
    selectedMaterial = anotherState.selectedMaterial;
    selectedRoom = anotherState.selectedRoom;
  }
}