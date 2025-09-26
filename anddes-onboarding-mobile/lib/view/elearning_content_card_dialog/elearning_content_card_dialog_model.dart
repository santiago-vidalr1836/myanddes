import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content_card_dialog/elearning_content_card_dialog_widget.dart';

import '../../utils/flutter_model.dart';

class ELearningContentCardDialogModel
    extends FlutterModel<ELearningContentCardDialogWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
