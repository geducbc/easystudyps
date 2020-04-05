import 'package:flutter/material.dart';

class TabIndex{
  final int payload;
  TabIndex(this.payload);
}

class SelectSubject{
  var payload;
  SelectSubject(this.payload);
}

class SelectedMaterial{
  var payload;
  SelectedMaterial(this.payload);
}

class SelectedRoom{
  final Map<String, dynamic> payload;
  SelectedRoom(this.payload);
}

class EducationLevel{
  final String payload;
  EducationLevel(this.payload);
}

class LoggedInUser{
  final String payload;
  LoggedInUser(this.payload);
}

class SchoolLevel{
  final String payload;
  SchoolLevel(this.payload);
}

class MaterialLoaded{
  final List<dynamic> payload;
  MaterialLoaded(this.payload);
}