import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/title_widget.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/template/template_model.dart';

class TemplateWidget extends StatefulWidget {
  const TemplateWidget({super.key});
  @override
  State<TemplateWidget> createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  late TemplateModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TemplateModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<bool> getData() async{
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(

      context: this.context,
      scaffoldKey: scaffoldKey,
      titleWidget: TitleWidget(
        context: context,
        title: '',
        iconData: Icons.arrow_back,
      ),
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.data == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          return SizedBox();
        },
        future: getData(),
      ),
    );
  }
}
