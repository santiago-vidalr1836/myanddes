import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/process.dart';
import 'package:mi_anddes_mobile_app/model/remote_induction.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/title_widget.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/remote_induction/remote_induction_model.dart';

class RemoteInductionWidget extends StatefulWidget {
  final String activityName;
  const RemoteInductionWidget({super.key,required this.activityName});
  @override
  State<RemoteInductionWidget> createState() => _RemoteInductionWidgetState();
}

class _RemoteInductionWidgetState extends State<RemoteInductionWidget> {
  late RemoteInductionModel _model;
  late OnboardingService _onboardingService;

  late Process _process;
  late RemoteInduction _remoteInduction;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RemoteInductionModel());
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<bool> getData() async{
    var process = await _onboardingService.findProcess();
    var processActivity = await _onboardingService.findProcessActivityByCode(Constants.ACTIVITY_REMOTE_INDUCTION);
    var remoteInduction = await _onboardingService.findRemoteInduction();
    if(process != null && processActivity != null && remoteInduction != null){
      _process = process;
      _remoteInduction = remoteInduction;
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(

      context: this.context,
      scaffoldKey: scaffoldKey,
      titleWidget: TitleWidget(
        context: context,
        title: widget.activityName,
        iconData: Symbols.arrow_back,
        returnToActivityList: true,
      ),
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null || (snapshot.data != null && !snapshot.data!)) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.video_call_outlined,
                          color: MiAnddesTheme.of(context)
                              .secondary,
                          size: 24.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${dateTimeFormat('MMMMd',_process.startDate!,locale: 'es')}, ${_process.hourRemote}',
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchURL(_process.linkRemote!);
                              },
                            child:SizedBox(
                              width: 200,
                            child:Text(
                              _process.linkRemote!,
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Montserrat',
                                color: MiAnddesTheme.of(
                                    context)
                                    .tertiary,
                                letterSpacing: 0.0,
                              ),
                            ))),
                          ].divide(const SizedBox(height: 4.0)),
                        ),
                      ].divide(const SizedBox(width: 12.0)),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MiAnddesTheme.of(context)
                            .primaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Qué abordaremos?',
                              style: MiAnddesTheme.of(context)
                                  .titleSmall
                                  .override(
                                  fontFamily: 'NeoSansStd',
                                  useGoogleFonts: false,
                                  letterSpacing: 0.0,
                                  fontSize: 16.0
                              ),
                            ),
                            Text(
                              _remoteInduction.description!=null?_remoteInduction.description!:"",
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                  fontFamily: 'Montserrat',
                                  letterSpacing: 0.0,
                                  lineHeight: 1.5,
                                  fontSize: 14.0
                              ),
                            ),
                          ].divide(const SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ),
          );
        },
        future: getData(),
      ),
    );
  }
}
