import 'package:flutter/widgets.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';

class ActivityType{
  List<ProcessActivity> activities;
  int color;
  Widget widget;

  ActivityType({
    required this.activities,
    required this.color,
    required this.widget
  });
}
