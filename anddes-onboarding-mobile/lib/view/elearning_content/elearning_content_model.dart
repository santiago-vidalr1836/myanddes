import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content/elearning_content_widget.dart';

import '../../utils/flutter_model.dart';

class ELearningContentModel extends FlutterModel<ELearningContentWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
