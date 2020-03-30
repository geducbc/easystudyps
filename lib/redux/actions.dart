import 'package:flutter/material.dart';

class TabIndex{
  final int payload;
  TabIndex(this.payload);
}

class SelectSubject{
  final Map<String, dynamic> payload;
  SelectSubject(this.payload);
}

class SelectedMaterial{
  final Map<String, dynamic> payload;
  SelectedMaterial(this.payload);
}

class SelectedRoom{
  final Map<String, dynamic> payload;
  SelectedRoom(this.payload);
}