import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_anddes_mobile_app/service/auth_service.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/service_service.dart';
import 'package:mi_anddes_mobile_app/service/tool_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_custom_widgets.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/exception/not_found_user_exception.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';
import 'package:mi_anddes_mobile_app/view/splash/splash_model.dart';

import '../../service/profile_service.dart';
import '../../utils/flutter_model.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SplashModel _model;
  late AuthService _authService;
  late ProfileService _userService;
  late ToolService _toolService;
  late ServiceService _serviceService;
  late OnboardingService _onboardingService;
  bool _isloading=true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashModel());

    _authService = AuthService();
    _userService = ProfileService();
    _toolService = ToolService();
    _serviceService = ServiceService();
    _onboardingService = OnboardingService();

    syncOnboardingInformation();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  //context.pushNamed('login');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/logo-blanco.png',
                    width: 300.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Center(
                child: _isloading?const SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: CircularProgressIndicator()
                  ,
                ):FFButtonWidget(
                    onPressed: () async{
                      _isloading=true;
                      setState(() {});
                      syncOnboardingInformation();
                    },
                    text: 'REINTENTAR',
                    options: FFButtonOptions(
                      height: 56.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: MiAnddesTheme.of(context).primary,
                      textStyle: MiAnddesTheme.of(context).bodyLarge.override(
                        fontFamily: 'Montserrat',
                        color: MiAnddesTheme.of(context).primaryBackground,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 3.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void syncOnboardingInformation() async {
    var screenToNavigate = "";
    var userGivenName = "";
    try {
      var accessToken = await _authService.getAccessToken();
      if (accessToken != null && accessToken.isValid()) {

          await _userService.getRemote();
          await _toolService.listRemote();
          await _serviceService.listRemote();

          var user = await _userService.get();
          if (user != null && user.onItinerary != null && user.onItinerary!) {
            userGivenName = user.givenName!;

            await _onboardingService.syncProcess(user.id!);
            var process = await _onboardingService.findProcess();
            if (process != null) {
              await _onboardingService.sendPendingProcessActivity();

              await _onboardingService.syncProcessActivity(user.id!, process.id);
              await _onboardingService.syncOnboarding(user.id!, process.id);

              if (!process.welcomed!) {
                await _onboardingService.updateWelcomed(user.id!, process.id);
                screenToNavigate = "welcome-user";
              } else {
                screenToNavigate = "activity-list";
              }
            } else {
              screenToNavigate = "tools";
            }
          } else {
            screenToNavigate = "tools";
          }
      } else {
        screenToNavigate = "login";
      }
    } on UnauthorizedException {
      log('UnauthorizedException');
      screenToNavigate = "login";
    }on NotFoundUserException {
      log('NotFoundUserException');
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no registrado')));
      }
      screenToNavigate = "login";
    }on SocketException{
      _isloading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Necesita  activar sus datos móviles o Wifi para poder acceder a la aplicación.')));
      return;
    }
    await Future.delayed(const Duration(seconds: 1)).then((r) => {
          context.pushReplacementNamed(screenToNavigate,
              queryParameters: {'userGivenName': userGivenName})
    });

    //context.pushNamed(screenToNavigate);
  }
}
