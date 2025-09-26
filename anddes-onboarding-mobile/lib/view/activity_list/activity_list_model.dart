import 'package:flutter/cupertino.dart';

import '../../utils/flutter_model.dart';
import 'activity_list_widget.dart';

class ActivityListModel extends FlutterModel<ActivityListWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
