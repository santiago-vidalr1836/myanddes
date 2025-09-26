import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/model/user.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/profile_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/title_widget.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/profile/profile_model.dart';

import '../../constants.dart';
import '../../model/process_activity.dart';
import '../../utils/custom_view/flutter_custom_widgets.dart';
import '../../utils/custom_view/mianddes_theme.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  late ProfileService _profileService;
  late OnboardingService _onboardingService;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late User? _user;
  late String? initialNickname;
  late String? initialHobbies;
  File? _image;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    _profileService = ProfileService();
    _onboardingService= OnboardingService();

    _model.txtNickname ??= TextEditingController();
    _model.txtFocusNodeNickname ??= FocusNode();

    _model.txtHobbies ??= TextEditingController();
    _model.txtHobbiesFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<User?> getProfile() async {
    _user = await _profileService.get();
    if (_user != null) {
      if (_user!.nickname != null) {
        _model.txtNickname.text = _user!.nickname!;
      }
      if (_user!.hobbies != null) {
        _model.txtHobbies.text = _user!.hobbies!.join(",");
      }
    }
    return _user;
  }

  @override
  Widget build(BuildContext context) {

    final picker = ImagePicker();

    return MiAnddesCommonPage(
        context: this.context,
        scaffoldKey: scaffoldKey,
        titleWidget: TitleWidget(
          context: context,
          title: 'Completar Perfil',
          iconData: Symbols.arrow_back,
        ),
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        content: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return const Center(
                    child: SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: CircularProgressIndicator(),
                ));
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Nombre abreviado',
                            style:
                                MiAnddesTheme.of(context).titleSmall.override(
                                      fontFamily: 'NeoSansStd',
                                      useGoogleFonts: false,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: TextFormField(
                            controller: _model.txtNickname,
                            focusNode: _model.txtFocusNodeNickname,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Nombre que usas',
                              helperText: 'Cómo deseas que  te llamemos',
                              labelStyle: MiAnddesTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.0,
                                    fontSize: 12.0
                                  ),
                              helperStyle: MiAnddesTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.0,
                                    fontSize: 10.0
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).secondary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            style:
                                MiAnddesTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0.0,
                                    ),
                            validator: _model.txtNicknameValidator
                                .asValidator(context),
                          ),
                        ),
                      ].divide(const SizedBox(height: 16.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Foto',
                            style:
                                MiAnddesTheme.of(context).titleSmall.override(
                                      fontFamily: 'NeoSansStd',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'La foto será utilizada para incorporarla en nuestros sistemas internos',
                            style:
                            MiAnddesTheme.of(context).titleSmall.override(
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.0,
                                fontSize: 12.0
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: _image!=null?
                            Image.file(
                              _image!,
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            )
                                :(_user == null ||
                                (_user != null && _user!.image == null))
                                ? Image.asset(
                              'assets/images/noimage.png',
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            )
                                : CachedNetworkImage(
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.fitHeight,
                              imageUrl: _user!.image!,
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                log('setState');
                                if (pickedFile != null) {
                                  _image = File(pickedFile.path);
                                  log(pickedFile.path);
                                }
                              });
                            },
                            text: 'Foto Personal',
                            icon: const Icon(
                              Symbols.file_upload,
                              size: Constants.miAnddessIconSize,
                              weight: Constants.miAnddesIconWeight,
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
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 2.0,
                                        fontSize: 12.0
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            _image!=null?_image!.uri.pathSegments.last:"-",
                            style: MiAnddesTheme.of(context).bodySmall.override(
                                  fontFamily: 'Montserrat',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),

                      ].divide(const SizedBox(height: 16.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Hobbies',
                            style:
                                MiAnddesTheme.of(context).titleSmall.override(
                                      fontFamily: 'NeoSansStd',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: TextFormField(
                            controller: _model.txtHobbies,
                            focusNode: _model.txtHobbiesFocusNode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Hobbies',
                              helperText: 'Separar por cómas cada hobbie',
                              labelStyle: MiAnddesTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.0,
                                    fontSize: 12.0
                                  ),
                              helperStyle: MiAnddesTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.0,
                                    fontSize: 10.0
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).secondary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: MiAnddesTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            style:
                                MiAnddesTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0.0,
                                    ),
                            validator:
                                _model.txtHobbiesValidator.asValidator(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                        child:FFButtonWidget(
                          text: 'GUARDAR',
                          onPressed:  () async{
                            ProcessActivity? activityCompleteProfile =
                            await _onboardingService.findProcessActivityByCode(
                                Constants.ACTIVITY_COMPLETE_PROFILE);
                            if (activityCompleteProfile != null) {
                              if (!activityCompleteProfile.completed!) {
                                activityCompleteProfile.completed = true;
                                activityCompleteProfile.completionDate =
                                    DateTime.now();
                                await _onboardingService.updateActivityCompleted(
                                    activityCompleteProfile);
                              }
                            }
                            _profileService.updateProfile(_user!,_model.txtNickname.text,_model.txtHobbies.text,_image);
                            context.pushReplacementNamed('activity-list');
                          },
                          options: FFButtonOptions(
                            height: 48.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                200.0, 0.0, 4.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Colors.transparent,
                            textStyle:
                            MiAnddesTheme.of(context).labelLarge.override(
                              fontFamily: 'Montserrat',
                              letterSpacing: 2.0,
                            ),
                            elevation: 0.0,
                            //borderRadius: BorderRadius.circular(8.0),
                          )
                        )
                        )
                      ].divide(const SizedBox(height: 16.0)),
                    ),
                  ]
                      .divide(const SizedBox(height: 48.0))
                      .addToStart(const SizedBox(height: 48.0))
                      .addToEnd(const SizedBox(height: 48.0)),
                ),
              );
            },
            future: getProfile()));
  }
}
