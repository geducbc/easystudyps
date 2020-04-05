import 'package:studyapp/model/app_state.dart';
import 'package:studyapp/redux/actions.dart';
 

AppState reducer(AppState prevState, dynamic action){
  AppState newState = AppState.fromAppState(prevState);
  if(action is TabIndex){
     newState.selectedTabIndex = action.payload;
  }
  if(action is SelectSubject){
    newState.selectedSubject = action.payload;
  }
  if(action is SelectedMaterial){
    newState.selectedMaterial = action.payload;
  }
  if(action is SelectedRoom){
    newState.selectedRoom = action.payload;
  }
  if(action is EducationLevel){
    newState.educationLevel = action.payload;
  }
  if(action is SchoolLevel){
    newState.schoolLevel = action.payload;
  }
  if(action is MaterialLoaded){
    newState.materials = action.payload;
  }
  return newState;
}