import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/welcome_ceo_video/welcome_ceo_video_model.dart';

import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_icon_button.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_video_player.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';

import '../../constants.dart';

class WelcomeCeoVideoWidget extends StatefulWidget {
  const WelcomeCeoVideoWidget({super.key});

  @override
  State<WelcomeCeoVideoWidget> createState() => _WelcomeCeoVideoWidgetState();
}

class _WelcomeCeoVideoWidgetState extends State<WelcomeCeoVideoWidget> {
  late WelcomeCeoVideoModel _model;
  late OnboardingService _onboardingService;
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeCeoVideoModel());
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.data == null) {
          print('project snapshot data is: ${snapshot.data}');
          return const Center(
              child: SizedBox(
            height: 80.0,
            width: 80.0,
            child: CircularProgressIndicator(),
          ));
        }
        print('snapshot data is: ${snapshot.data}');
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: MiAnddesTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterVideoPlayer(
                    path: snapshot.data!.urlVideo!,
                    videoType: VideoType.network,
                    autoPlay: true,
                    looping: false,
                    showControls: true,
                    allowFullScreen: true,
                    allowPlaybackSpeedMenu: false,
                    placeHolder:  snapshot.data!.urlPoster !=null ?CachedNetworkImage(
                      fit: BoxFit.fitHeight,
                      imageUrl: snapshot.data!.urlPoster!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ):null,
                  ),
                  Align(
                    alignment: const AlignmentDirectional(1.0, 0.0),
                    child: FlutterIconButton(
                      borderRadius: 4.0,
                      borderWidth: 0.0,
                      buttonSize: 40.0,
                      //fillColor: MiAnddesTheme.of(context).aliceBlue,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: MiAnddesTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        ProcessActivity? activityCEOPresentation =
                            await _onboardingService.findProcessActivityByCode(
                                Constants.ACTIVITY_CEO_PRESENTATION);
                        if (activityCEOPresentation != null) {
                          if (!activityCEOPresentation.completed!) {
                            activityCEOPresentation.completed = true;
                            activityCEOPresentation.completionDate =
                                DateTime.now();
                            await _onboardingService.updateActivityCompleted(
                                activityCEOPresentation);
                          }
                          context.pushReplacementNamed('activity-list');
                        }
                      },
                    ),
                  ),
                ]
                    .divide(const SizedBox(height: 24.0))
                    .addToStart(const SizedBox(height: 59.0))
                    .addToEnd(const SizedBox(height: .0)),
              ),
            ),
          ),
        );
      },
      future: _onboardingService.findCEOPresentation(),
    );
  }
}
