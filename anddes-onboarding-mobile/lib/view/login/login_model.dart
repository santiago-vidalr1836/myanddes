import 'package:flutter/material.dart';

import '../../utils/flutter_model.dart';
import 'login_widget.dart' show LoginWidget;

class LoginModel extends FlutterModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
