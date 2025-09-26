import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/activity_type.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/welcome_ceo_video/welcome_ceo_video_widget.dart';

import '../../model/process.dart';
import 'activity_list_model.dart';

class ActivityListWidget extends StatefulWidget {
  const ActivityListWidget({super.key});

  @override
  State<ActivityListWidget> createState() => _ActivityListWidgetState();
}

class _ActivityListWidgetState extends State<ActivityListWidget> {
  late ActivityListModel _model;
  late OnboardingService _onboardingService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ProcessActivity _activityCEOPresentation;
  late ProcessActivity _activityCompleteProfile;
  late ProcessActivity _activityFirstDayInformation;
  late ProcessActivity _activityKnowTeam;
  late ProcessActivity _activityOnsiteInduction;
  late ProcessActivity _activityRemoteInduction;
  late ProcessActivity _activityELearningContent;

  late Process? _process;
  late int _processTotal;
  late int _processCompleted;

  late List<ActivityType> types;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityListModel());
    _onboardingService = OnboardingService();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<bool?> getActivity() async {
    _process = await _onboardingService.findProcess();

    List<ProcessActivity>? activities =
        await _onboardingService.findActivities();

    if (activities != null && activities.isNotEmpty) {
      _activityCEOPresentation = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_CEO_PRESENTATION);
      _activityCompleteProfile = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_COMPLETE_PROFILE);
      _activityFirstDayInformation = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_FIRST_DAY_INFORMATION);
      _activityKnowTeam = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! == Constants.ACTIVITY_KNOW_YOUR_TEAM);
      _activityOnsiteInduction = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_ON_SITE_INDUCTION);
      _activityRemoteInduction = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_REMOTE_INDUCTION);
      _activityELearningContent = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_INDUCTION_ELEARNING);

      if (_activityELearningContent.completed != null &&
          !_activityELearningContent.completed!) {
        try {
          var remoteActivityELearningContent =
              await _onboardingService.callApiProcessActivityById(
                  1, _process!.id, _activityELearningContent.id);
          if (remoteActivityELearningContent != null) {
            _activityELearningContent = remoteActivityELearningContent;
          }
        } on Exception {
          //Each time the activity list is shown, we call the api to see the progress of elearning
        }
      }

      types = [];

      types.add(ActivityType(
          color: 0xFFE9F5FF,
          widget: antesWidget(),
          activities: [
            _activityCEOPresentation,
            _activityCompleteProfile,
            _activityFirstDayInformation
          ]));
      types.add(ActivityType(
          color: 0xFFDFE3E4,
          widget: miPrimerDiaWidget(),
          activities: [
            _activityKnowTeam,
            _activityOnsiteInduction,
            _activityRemoteInduction
          ]));
      types.add(ActivityType(
          color: 0xFFFFF8E1,
          widget: miPrimeraSemanaWidget(),
          activities: [_activityELearningContent]));

      _processTotal = activities.length;
      _processCompleted = activities.where((a) => a.completed!).length;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.data!) {
            //print('project snapshot data is: ${projectSnap.data}');
            return MiAnddesCommonPage(
              context: context,
              scaffoldKey: scaffoldKey,
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              titleWidget: const SizedBox(),
              content: const Center(
                  child: SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(),
              )),
            );
          }
          return MiAnddesCommonPage(
            context: context,
            scaffoldKey: scaffoldKey,
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            titleWidget: activityListTitleWidget(context),
            content: contentActivityList(context),
          );
        },
        future: getActivity());
  }

  Widget activityListTitleWidget(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 4.0),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Onboarding',
            style: MiAnddesTheme.of(context).headlineLarge.override(
                  fontFamily: 'NeoSansStd',
                  useGoogleFonts: false,
                  fontSize: 28.0,
                  fontWeight: FontWeight.normal,
                  color: MiAnddesTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          ),
          Row(children: [
            SizedBox(
                height: 27.0,
                width: 27.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: MiAnddesTheme.of(context).primary,
                  value: _processCompleted / _processTotal,
                )),
            const SizedBox(width: 12.0),
            Text(
              '$_processCompleted / $_processTotal',
              style: MiAnddesTheme.of(context).bodyLarge.override(
                    fontFamily: 'NeoSansStd',
                    useGoogleFonts: false,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                  ),
            )
          ]),
        ],
      )
    ]);
  }

  Widget contentActivityList(BuildContext context) {
    return ListView.builder(
      itemCount: types.length,
      itemBuilder: (context, index) {
        ActivityType type = types[index];
        return Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(type.color),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: MiAnddesTheme.of(context).secondary,
                    width: 0.2,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 1.0),
                      type.widget,
                      processActivityList(type.activities)
                    ]
                        .divide(const SizedBox(height: 16.0))
                        //.addToStart(const SizedBox(height: 2.0))
                        .addToEnd(const SizedBox(height: 14.0)),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget antesWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 8.0),
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(
            color: MiAnddesTheme.of(context).primary,
            borderRadius: BorderRadius.circular(24.0)),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
          child: Text(
            'Antes',
            textAlign: TextAlign.start,
            style: MiAnddesTheme.of(context).titleSmall.override(
                  useGoogleFonts: false,
                  fontFamily: 'NeoSansStd',
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  lineHeight: 1.5,
                ),
          ),
        ),
      ),
    );
  }

  Widget miPrimerDiaWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 8.0),
            child: Container(
              width: 150.0,
              decoration: BoxDecoration(
                color: MiAnddesTheme.of(context).primaryText,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                child: Text(
                  'Mi primer día',
                  textAlign: TextAlign.start,
                  style: MiAnddesTheme.of(context).titleSmall.override(
                        useGoogleFonts: false,
                        fontFamily: 'NeoSansStd',
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontSize: 14.0,
                        lineHeight: 1.5,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Text(
              '🚀',
              style: MiAnddesTheme.of(context).titleLarge,
            ),
          )
        ]),
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              DateFormat("dd MMM", "es").format(_process!.startDate!),
              style: MiAnddesTheme.of(context).bodyMedium.override(
                  useGoogleFonts: false,
                  fontFamily: 'NeoSansStd',
                  letterSpacing: 0.0,
                  fontSize: 11.0),
            ))
      ],
    );
  }

  Widget miPrimeraSemanaWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 8.0),
          child: Container(
            width: 200.0,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
              child: Text(
                'Mi primera semana',
                textAlign: TextAlign.start,
                style: MiAnddesTheme.of(context).titleSmall.override(
                      useGoogleFonts: false,
                      fontFamily: 'NeoSansStd',
                      letterSpacing: 0.0,
                      fontSize: 14.0,
                      lineHeight: 1.5,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget processActivityList(List<ProcessActivity> activities) {
    return Column(children: [
      for (ProcessActivity processActivity in activities)
        activityItemWidget(processActivity)
    ]);
  }

  Widget activityItemWidget(ProcessActivity processActivity) {
    return GestureDetector(
        onTap: () {
          onActivityItemTapped(processActivity);
        },
        child: Container(
            height: 62.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(15.0, 12.0, 15.0, 0.0),
              child: Container(
                height: 62.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              14.0, 15.0, 0.0, 0.0),
                          child: Text(
                            processActivity.activity != null
                                ? MediaQuery.sizeOf(context).width>360.0 ||
                                  processActivity.activity!.name!.length<16?
                                  processActivity.activity!.name!:
                                  '${processActivity.activity!.name!.substring(0,15)}..'
                                : "-",
                            style: MiAnddesTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 15.0, 0.0),
                          child: Icon(
                            processActivity.completed != null &&
                            processActivity.completed!
                                ? Symbols.check_circle_outline
                                : Symbols.circle,
                            color: MiAnddesTheme.of(context).primaryText,
                            size: Constants.miAnddessIconSize,
                            weight: Constants.miAnddesIconWeight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  void onActivityItemTapped(ProcessActivity processActivity) async {
    if (processActivity == _activityCEOPresentation) {
      await showDialog(
        barrierColor: const Color(0x80424242),
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.only(top: 125.0),
            backgroundColor: Colors.transparent,
            alignment: const AlignmentDirectional(70.0, 0.0)
                .resolve(Directionality.of(context)),
            child: GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: const WelcomeCeoVideoWidget(),
              ),
            ),
          );
        },
      ).then((value) => setState(() {}));
    } else if (processActivity == _activityCompleteProfile) {
      context.pushNamed('profile-edit');
    } else if (processActivity == _activityFirstDayInformation) {
      if (!_activityFirstDayInformation.completed!) {
        _activityFirstDayInformation.completed = true;
        _activityFirstDayInformation.completionDate = DateTime.now();
        await _onboardingService
            .updateActivityCompleted(_activityFirstDayInformation);
      }
      context.pushNamed('first-day-information-item');
    } else if (processActivity == _activityKnowTeam) {
      if (!_activityKnowTeam.completed!) {
        _activityKnowTeam.completed = true;
        _activityKnowTeam.completionDate = DateTime.now();
        await _onboardingService.updateActivityCompleted(_activityKnowTeam);
      }
      context.pushNamed('know-your-team');
    } else if (processActivity == _activityOnsiteInduction) {
      context.pushNamed('onsite-induction', queryParameters: {
        'activityName': _activityOnsiteInduction.activity!.name!
      });
    } else if (processActivity == _activityRemoteInduction) {
      context.pushNamed('remote-induction', queryParameters: {
        'activityName': _activityRemoteInduction.activity!.name!
      });
    } else if (processActivity == _activityELearningContent) {
      var dateLimit = DateTime(_process!.startDate!.year,
          _process!.startDate!.month, _process!.startDate!.day + 7);
      context.pushNamed('elearning-contents', queryParameters: {
        'processId': '${_process!.id}',
        'dateLimit': dateTimeFormat('EEEE dd/MM', dateLimit, locale: 'es'),
        'processActivityId': '${_activityELearningContent.id}'
      });
    }
  }
}
