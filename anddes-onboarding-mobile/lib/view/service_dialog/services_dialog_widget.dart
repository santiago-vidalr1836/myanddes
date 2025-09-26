import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mi_anddes_mobile_app/model/service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/service_dialog/services_dialog_model.dart';

class ServicesDialogWidget extends StatefulWidget {
  final List<ServiceDetail> detail;
  final String title;

  const ServicesDialogWidget(
      {super.key, required this.title, required this.detail});

  @override
  State<ServicesDialogWidget> createState() => _ServicesDialogWidgetState();
}

class _ServicesDialogWidgetState extends State<ServicesDialogWidget> {
  late ServicesDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServicesDialogModel());
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
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: ListView.builder(
                  itemCount: widget.detail.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(children: [
                        const SizedBox(height: 5.0),
                        Row(children: [
                          const SizedBox(width: 5.0),
                          SizedBox(
                              width: 250,
                              child: Text(widget.title,
                                  style: MiAnddesTheme.of(context)
                                      .titleLarge
                                      .override(
                                          fontFamily: 'NeoSansStd',
                                          fontSize: 22.0,
                                          useGoogleFonts: false))),
                          /*Expanded(
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
                        const SizedBox(height: 10.0)
                      ]);
                    }
                    index -= 1;
                    return Card(
                      elevation: 0.01,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: MiAnddesTheme.of(context).accent2)),
                      child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: MiAnddesTheme.of(context).accent2)),
                          backgroundColor: MiAnddesTheme.of(context).aliceBlue,
                          collapsedBackgroundColor: MiAnddesTheme.of(context).gray,
                          iconColor: MiAnddesTheme.of(context).primary,
                          initiallyExpanded: index==0,
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.detail[index].title!,
                                  style: MiAnddesTheme.of(context)
                                      .titleSmall
                                      .override(
                                          fontFamily: 'NeoSansStd',
                                          fontSize: 16.0,
                                          useGoogleFonts: false),
                                ),
                                Icon(
                                  getIcon(widget.detail[index].icon!),
                                  size: 24.0,
                                )
                              ]),
                          children: [
                            const SizedBox(height: 12.0),
                            ListTile(
                                title: HtmlWidget(
                                    widget.detail[index].description!,
                                    textStyle:
                                        MiAnddesTheme.of(context).bodyMedium)),
                            const SizedBox(height: 15.0)
                          ]),
                    );
                  },
                ))));
  }
}
