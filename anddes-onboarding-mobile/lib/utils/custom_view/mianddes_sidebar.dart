import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/model/process.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/profile_service.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import '../../constants.dart';
import '../../model/process_activity.dart';
import 'flutter_custom_widgets.dart';
import 'mianddes_theme.dart';

class MiAnddesSidebar extends StatefulWidget {
  final BuildContext? context;

  const MiAnddesSidebar({super.key, required this.context});

  @override
  State<MiAnddesSidebar> createState() => _MiAnddesSidebarState();
}

class _MiAnddesSidebarState extends State<MiAnddesSidebar> {
  late Process? _process;
  late ProcessActivity _activityELearningContent;

  ProfileService userService = ProfileService();
  final OnboardingService _onboardingService = OnboardingService();

  Future<bool?> getData() async {
    try {
      _process = await _onboardingService.findProcess();

      List<ProcessActivity>? activities =
          await _onboardingService.findActivities();
      if (activities != null && activities.isNotEmpty) {
        _activityELearningContent = activities.firstWhere((processActivity) =>
            processActivity.activity?.code! ==
            Constants.ACTIVITY_INDUCTION_ELEARNING);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: MiAnddesTheme.of(context).sidebar,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, top: 10.0, bottom: 15.0),
                  child: Image.asset(
                    'assets/images/logo-blanco.png',
                    width: 100.0,
                    height: 30.0,
                    fit: BoxFit.contain,
                  ),
                )),
            Align(
              alignment: Alignment.topLeft,
              child: FFButtonWidget(
                onPressed: () {
                  context.pushNamed("services");
                },
                icon: const Icon(
                  Symbols.mood,
                  size: Constants.miAnddessIconSize,
                  weight: Constants.miAnddesIconWeight,
                ),
                text: 'VIDA EN LA EMPRESA',
                options: FFButtonOptions(
                  splashColor: MiAnddesTheme.of(context).gray,
                  disabledColor: MiAnddesTheme.of(context).sidebar,
                  height: 40.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: MiAnddesTheme.of(context).sidebar,
                  textStyle: MiAnddesTheme.of(context).bodyMedium.override(
                      fontFamily: 'NeoSansStd',
                      useGoogleFonts: false,
                      color: MiAnddesTheme.of(context).primaryBackground,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: FFButtonWidget(
                  onPressed: () {
                    context.pushNamed("tools");
                  },
                  icon: const Icon(
                    Symbols.handyman,
                    size: Constants.miAnddessIconSize,
                    weight: Constants.miAnddesIconWeight,
                  ),
                  text: 'HERRAMIENTAS',
                  options: FFButtonOptions(
                    splashColor: MiAnddesTheme.of(context).gray,
                    disabledColor: MiAnddesTheme.of(context).sidebar,
                    height: 40.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: MiAnddesTheme.of(context).sidebar,
                    textStyle: MiAnddesTheme.of(context).bodyMedium.override(
                        fontFamily: 'NeoSansStd',
                        useGoogleFonts: false,
                        color: MiAnddesTheme.of(context).primaryBackground,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder(
                  future: getData(),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData ||
                        (userSnap.data == null) ||
                        (userSnap.data != null &&
                            userSnap.data! &&
                            _process == null)) {
                      return const SizedBox();
                    }
                    return FFButtonWidget(
                      onPressed: () {
                        context.pushNamed("activity-list");
                      },
                      icon: const Icon(
                        Symbols.door_sliding,
                        size: Constants.miAnddessIconSize,
                        weight: Constants.miAnddesIconWeight,
                      ),
                      text: 'ONBOARDING',
                      options: FFButtonOptions(
                        splashColor: MiAnddesTheme.of(context).gray,
                        disabledColor: MiAnddesTheme.of(context).sidebar,
                        height: 40.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        color: MiAnddesTheme.of(context).sidebar,
                        textStyle: MiAnddesTheme.of(context)
                            .bodyMedium
                            .override(
                                fontFamily: 'NeoSansStd',
                                useGoogleFonts: false,
                                color:
                                    MiAnddesTheme.of(context).primaryBackground,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w600),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    );
                  },
                )),
            Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder(
                  future: getData(),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData ||
                        (userSnap.data == null) ||
                        (userSnap.data != null &&
                            userSnap.data! &&
                            _process == null)) {
                      return const SizedBox();
                    }
                    return Row(children: [
                      const SizedBox(width: 20.0),
                      FFButtonWidget(
                        onPressed: () {
                          var dateLimit = DateTime(
                              _process!.startDate!.year,
                              _process!.startDate!.month,
                              _process!.startDate!.day + 7);
                          context.pushNamed('elearning-contents',
                              queryParameters: {
                                'processId': '${_process!.id}',
                                'dateLimit': dateTimeFormat(
                                    'EEEE dd/MM', dateLimit,
                                    locale: 'es'),
                                'processActivityId':
                                    '${_activityELearningContent.id}'
                              });
                        },
                        icon: const Icon(
                          Symbols.book_online,
                          size: Constants.miAnddessIconSize,
                          weight: Constants.miAnddesIconWeight,
                        ),
                        text: 'INDUCCION',
                        options: FFButtonOptions(
                          splashColor: MiAnddesTheme.of(context).gray,
                          disabledColor: MiAnddesTheme.of(context).sidebar,
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: MiAnddesTheme.of(context).sidebar,
                          textStyle: MiAnddesTheme.of(context)
                              .bodyMedium
                              .override(
                                  fontFamily: 'NeoSansStd',
                                  useGoogleFonts: false,
                                  color: MiAnddesTheme.of(context)
                                      .primaryBackground,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.w600),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      )
                    ]);
                  },
                )),
          ]
              .divide(const SizedBox(height: 32.0))
              .addToStart(const SizedBox(height: 48.0)),
        ),
      ),
    );
  }
}
