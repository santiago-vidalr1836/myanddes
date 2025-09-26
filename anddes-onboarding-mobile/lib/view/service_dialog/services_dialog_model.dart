import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/services/services_widget.dart';

import '../../utils/flutter_model.dart';

class ServicesDialogModel extends FlutterModel<ServicesWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
