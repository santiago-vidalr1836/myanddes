import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/profile/profile_widget.dart';

import '../../utils/flutter_model.dart';

class ProfileModel extends FlutterModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? txtFocusNodeNickname;
  TextEditingController? txtNickname;
  String? Function(BuildContext, String?)? txtNicknameValidator;
  // State field(s) for TextField widget.
  FocusNode? txtHobbiesFocusNode;
  TextEditingController? txtHobbies;
  String? Function(BuildContext, String?)? txtHobbiesValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    txtFocusNodeNickname?.dispose();
    txtNickname?.dispose();

    txtHobbiesFocusNode?.dispose();
    txtHobbies?.dispose();
  }
}
