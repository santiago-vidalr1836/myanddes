import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/view/welcome_ceo_video/welcome_ceo_video_widget.dart';
import 'package:mi_anddes_mobile_app/view/welcome_user/welcome_user_model.dart';

import '../../utils/custom_view/flutter_custom_widgets.dart';

class WelcomeUserWidget extends StatefulWidget {
  final String userGivenName;
  const WelcomeUserWidget({super.key, required this.userGivenName});

  @override
  State<WelcomeUserWidget> createState() => _WelcomeWidgetWidgetState();
}

class _WelcomeWidgetWidgetState extends State<WelcomeUserWidget> {
  late WelcomeUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeUserModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MiAnddesTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: MiAnddesTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/background.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: const AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 24.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 12.0, 0.0, 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 116.0,
                            height: 51.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 12.0, 16.0, 32.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500.0,
                  ),
                  decoration: BoxDecoration(
                    color: MiAnddesTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 24.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/wave.png',
                                  width: 47.0,
                                  height: 47.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 220.0,
                              child: Text(
                              '${widget.userGivenName}, \nBienvenido\n a bordo!',
                              style: MiAnddesTheme.of(context)
                                  .headlineLarge
                                  .override(
                                    useGoogleFonts: false,
                                    fontFamily: 'NeoSansStd',
                                    color: MiAnddesTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.0,
                                  ),
                            )),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: MiAnddesTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 24.0, 16.0, 24.0),
                            child: Text(
                              'Te damos la bienvenida a nombre del equipo de Gestión del Talento, queremos que tu inicio en Anddes sea una excelente experiencia. \n\nPara comenzar revisa por favor el video de bienvenida de nuestro gerente general.\n',
                              style:
                                  MiAnddesTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.5,
                                      ),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) => FFButtonWidget(
                            onPressed: () async {
                              await showDialog(
                                barrierColor: const Color(0x99424242),
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: const EdgeInsets.only(top: 200.0),
                                    backgroundColor: Colors.transparent,
                                    alignment: const AlignmentDirectional(
                                            70.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: GestureDetector(
                                      onTap: () => _model
                                              .unfocusNode.canRequestFocus
                                          ? FocusScope.of(context)
                                              .requestFocus(_model.unfocusNode)
                                          : FocusScope.of(context).unfocus(),
                                      child: const SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: WelcomeCeoVideoWidget(),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            },
                            text: 'VIDEO BIENVENIDA',
                            icon: const Icon(
                              Icons.videocam_outlined,
                              size: 24.0,
                            ),
                            options: FFButtonOptions(
                              height: 48.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Colors.transparent,
                              textStyle:
                                  MiAnddesTheme.of(context).bodySmall.override(
                                        useGoogleFonts: false,
                                        fontFamily: 'NeoSansStd',
                                        fontSize: 12.0,
                                        letterSpacing: 2.0,
                                      ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: MiAnddesTheme.of(context).secondary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ]
                          .divide(SizedBox(height: 32.0))
                          .addToStart(SizedBox(height: 48.0))
                          .addToEnd(SizedBox(height: 48.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
