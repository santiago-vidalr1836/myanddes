import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/tools/tools_widget.dart';

import '../../utils/flutter_model.dart';

class ToolModel extends FlutterModel<ToolsWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
