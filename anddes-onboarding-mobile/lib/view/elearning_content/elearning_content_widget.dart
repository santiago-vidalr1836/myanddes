import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/model/process.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/title_widget.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content/elearning_content_model.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content_card_dialog/elearning_content_card_dialog_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utils/custom_view/mianddes_theme.dart';

class ELearningContentWidget extends StatefulWidget {
  final String processId;
  final String processActivityId;
  final String dateLimit;
  const ELearningContentWidget(
      {super.key,
      required this.processId,
      required this.dateLimit,
      required this.processActivityId});

  @override
  State<ELearningContentWidget> createState() => _ELearningContentWidgetState();
}

class _ELearningContentWidgetState extends State<ELearningContentWidget> {
  late ELearningContentModel _model;
  late OnboardingService _onboardingService;
  late Process process;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ELearningContentModel());
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
      //title: 'Inducción',
      //iconData: Icons.arrow_back,
      //returnToActivityList:true,
      context: this.context,
      scaffoldKey: scaffoldKey,
      //showTitle: true,
      titleWidget: TitleWidget(
          context: context,
          title: 'Inducción',
          iconData: Symbols.arrow_back,
          returnToActivityList: true),
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting)
              &&
              snapshot.data == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ProcessActivityContent processActivityContent = snapshot.data![index]!;
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 5.0, 10.0, 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MiAnddesTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: MiAnddesTheme.of(context).secondary,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                //width: double.infinity,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitHeight,
                                  imageUrl: processActivityContent.content.image!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  processActivityContent.content.name!,
                                  style: MiAnddesTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'NeoSansStd',
                                        useGoogleFonts: false,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Text(
                                  'Fecha límite: ${widget.dateLimit}',
                                  textAlign: TextAlign.justify,
                                  style: MiAnddesTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                      ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: LinearPercentIndicator(
                                  percent: processActivityContent.progress! / 100.0,
                                  lineHeight: 6.0,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  progressColor:
                                      MiAnddesTheme.of(context).primary,
                                  backgroundColor:
                                      MiAnddesTheme.of(context).alternate,
                                  padding: EdgeInsets.zero,
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                                  Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child:TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0XFFDFE3E4),
                                  ),
                                  onPressed: () async {
                                    try {
                                      if (processActivityContent.id == 0) {
                                        await _onboardingService
                                            .createRemoteProcessActivityContent(
                                            widget.processId,
                                            widget.processActivityId,
                                            "${processActivityContent.content
                                                .id}");
                                        var newProcessActivityContent = await _onboardingService
                                            .findRemoteProcessActivityContent(
                                            widget.processId,
                                            widget.processActivityId,
                                            "${processActivityContent.content
                                                .id}");
                                        if (newProcessActivityContent != null) {
                                          processActivityContent =
                                              newProcessActivityContent;
                                        }
                                      }
                                    }catch(e){
                                      
                                      return;
                                    }
                                    await showDialog(
                                      barrierColor: const Color(0x99424242),
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding:
                                              const EdgeInsets.only(top: 125.0),
                                          backgroundColor: Colors.transparent,
                                          alignment: const AlignmentDirectional(
                                                  0.0, 0.0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: GestureDetector(
                                            onTap: () => _model
                                                    .unfocusNode.canRequestFocus
                                                ? FocusScope.of(context)
                                                    .requestFocus(
                                                        _model.unfocusNode)
                                                : FocusScope.of(context)
                                                    .unfocus(),
                                            child: SizedBox(
                                              height: double.infinity,
                                              width: double.infinity,
                                              child:
                                                  ELearningContentCardDialogWidget(
                                                      processActivityContent:
                                                      processActivityContent,
                                                      processId:
                                                          widget.processId,
                                                      processActivityId: widget
                                                          .processActivityId),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => setState(() {}));
                                  },
                                  child: Text(
                                    ' INGRESAR ',
                                    style: MiAnddesTheme.of(context)
                                        .titleSmall
                                        .override(
                                            fontFamily: 'NeoSansStd',
                                            useGoogleFonts: false,
                                            letterSpacing: 3.0,
                                            fontSize: 12.0),
                                  )),
                            ))
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
        },
        future: _onboardingService.findRemoteProccessActivityContents(widget.processId, widget.processActivityId),
      ),
    );
  }
}
