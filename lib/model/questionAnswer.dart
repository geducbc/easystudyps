

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:studyapp/model/response.dart';

class QuestionAnswer{
  final List<Response> response;
  final String assessmentId;
  final Timestamp completedDated;
  final String studentUserId;
  final String numberOfCorrectAnswer;

  QuestionAnswer({@required this.response, @required this.assessmentId, 
    @required this.completedDated, @required this.studentUserId, @required this.numberOfCorrectAnswer});
}