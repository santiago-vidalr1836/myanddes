import '../../utils/flutter_model.dart';
import 'welcome_user_widget.dart' show WelcomeUserWidget;
import 'package:flutter/material.dart';

class WelcomeUserModel extends FlutterModel<WelcomeUserWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
