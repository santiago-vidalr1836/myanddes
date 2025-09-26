import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/firstday_information_dialog/firstday_information_dialog_model.dart';

class FirstInformationDialogWidget extends StatefulWidget {
  final String content;
  final String title;
  const FirstInformationDialogWidget(
      {super.key, required this.title, required this.content});

  @override
  State<FirstInformationDialogWidget> createState() =>
      _FirstInformationDialogWidgetState();
}

class _FirstInformationDialogWidgetState
    extends State<FirstInformationDialogWidget> {
  late FirstDayInformationDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FirstDayInformationDialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        child: Container(
            decoration: BoxDecoration(
              color: MiAnddesTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 16.0, 0.0),
              child: ListView(
                children: [
                  Row(children: [
                    const SizedBox(width: 5.0),
                    SizedBox(
                      width: 200,
                      child:Text(widget.title,
                        style: MiAnddesTheme.of(context).titleLarge.override(
                          fontFamily: 'NeoSansStd',
                          useGoogleFonts: false,
                          fontSize: 22.0
                        ))
                    )/*,
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: FlutterIconButton(
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.close,
                          color: MiAnddesTheme.of(context).secondary,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                    ))*/
                  ]),
                  const SizedBox(height: 40.0),
                  HtmlWidget(widget.content,textStyle: MiAnddesTheme.of(context).bodyMedium),
                  const SizedBox(height: 24.0),
                ],
              ),
            )));
  }
}
