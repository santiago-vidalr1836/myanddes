import 'package:mi_anddes_mobile_app/service/auth_service.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import '../../model/token.dart';
import '../../utils/custom_view/aad_login_button.dart';
import 'package:flutter/material.dart';
import '../../utils/custom_view/mianddes_theme.dart';
import 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  late AuthService _authService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
    _authService = AuthService();
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
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Opacity(
            opacity: 0.9,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Material(
                color: Colors.transparent,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500.0,
                  ),
                  decoration: BoxDecoration(
                    color: MiAnddesTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/logo-azul.png',
                              width: 213.0,
                              height: 40.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        AADLoginButton(
                          context: context,
                          onAnyTokenRetrieved: (Token anyToken) {},
                          onIDToken: (Token token) {},
                          onAccessToken: (Token token) {
                            _authService.saveAccessToken(token);
                          },
                          onRefreshToken: (Token token) {
                            _authService.saveRefreshToken(token);
                            context.pushNamed('splash');
                          },
                          onRedirect: (context) =>
                              {context.pushNamed('splash')},
                        ),
                      ]
                          .divide(const SizedBox(height: 32.0))
                          .addToStart(const SizedBox(height: 48.0))
                          .addToEnd(const SizedBox(height: 49.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
