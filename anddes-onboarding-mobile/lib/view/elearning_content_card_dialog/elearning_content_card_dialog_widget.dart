import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/model/elearning_result.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_card.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_card_answer.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_icon_button.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_video_player.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content_card_dialog/elearning_content_card_dialog_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ELearningContentCardDialogWidget extends StatefulWidget {
  final ProcessActivityContent processActivityContent;
  final String processId;
  final String processActivityId;

  const ELearningContentCardDialogWidget(
      {super.key,
      required this.processActivityContent,
      required this.processId,
      required this.processActivityId});

  @override
  State<ELearningContentCardDialogWidget> createState() =>
      _ELearningContentCardDialogWidgetState();
}

class _ELearningContentCardDialogWidgetState
    extends State<ELearningContentCardDialogWidget> {
  late ELearningContentCardDialogModel _model;
  ProcessActivityContentCard? _currentCard;
  ELearningContentCardOption? _optionSelected;
  bool showLoadingIndicator = false;
  int _currentIndex = 0;
  bool _finished = false;
  late OnboardingService _onboardingService;
  bool _canContinue=false;
  @override
  void setState(VoidCallback callback) async {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ELearningContentCardDialogModel());
    _onboardingService = OnboardingService();
    if ((widget.processActivityContent.result == null) &&
        widget.processActivityContent.cards.isNotEmpty &&
        widget.processActivityContent.cards.where((c) => c.readMobileDate != null).isNotEmpty) {
      _currentCard = widget.processActivityContent.cards.firstWhere((c) => c.readMobileDate == null );
      _currentIndex = widget.processActivityContent.cards.indexOf(_currentCard!);
    }else{
      _currentCard = widget.processActivityContent.cards.first;
      _currentIndex = widget.processActivityContent.cards.indexOf(_currentCard!);
    }
    setTimer();
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
                  const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 16.0, 0.0),
              child: ListView(
                children: [
                  Row(children: [
                    const SizedBox(width: 5.0),
                    SizedBox(
                      width: 250,
                      child: Text(widget.processActivityContent.content.name!,
                          style: MiAnddesTheme.of(context).titleLarge.override(
                              fontSize: 22.0,
                              fontFamily: 'NeoSansStd',
                              useGoogleFonts: false)),
                    ) /*,
                    Expanded(
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
                  const SizedBox(height: 15.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: LinearPercentIndicator(
                        percent: widget.processActivityContent.content.progress! / 100.0,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: MiAnddesTheme.of(context).primary,
                        backgroundColor: MiAnddesTheme.of(context).alternate,
                        padding: EdgeInsets.zero,
                      )),
                  const SizedBox(height: 35.0),
                  if (_currentCard == null)
                    resultWidget()
                  else if (_currentCard!.card.type ==
                      Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)
                    questionWidget()
                  else if (_currentCard!.card.type ==
                      Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO)
                    videoWidget()
                  else
                    contentWidget(),
                  const SizedBox(height: 45.0),
                  _currentCard != null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${_currentIndex + 1}/${widget.processActivityContent.content.cards!.length}',
                              style:
                                  MiAnddesTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 0.0,
                                      ),
                            ),
                            const SizedBox(
                              width: 80.0,
                            ),
                            Align(
                              alignment: const AlignmentDirectional(1.0, 1.0),
                              child: _canContinue?FlutterIconButton(
                                borderRadius: 4.0,
                                borderWidth: 0.0,
                                buttonSize: 40.0,
                                fillColor: Colors.transparent,
                                showLoadingIndicator : showLoadingIndicator,
                                icon: Icon(
                                  Symbols.arrow_forward,
                                  color: MiAnddesTheme.of(context).primaryText,
                                  size: Constants.miAnddessIconSize,
                                  weight: Constants.miAnddesIconWeight,
                                ),
                                onPressed: () async {
                                  nextButtonClick();
                                },
                              ):const SizedBox(width: 40.0,height: 40.0,),
                            ),
                          ].divide(const SizedBox(width: 24.0)),
                        )
                      : const SizedBox(),
                  //HtmlWidget(widget.content),
                  const SizedBox(height: 12.0),
                ],
              ),
            )));
  }
  Widget resultWidget() {
    return Center(
      heightFactor: 1.5,
      child: Column(
        children: [
          Icon(
            Symbols.check_circle_outline,
            color: MiAnddesTheme.of(context).secondary,
            size: 32.0,
          ),
          Text('Completaste el modulo',
              style: MiAnddesTheme.of(context).titleMedium),
          const SizedBox(height: 10),
          SizedBox(
              width: 250,
              child: Text(widget.processActivityContent.content.name!,
                  style: MiAnddesTheme.of(context).titleLarge,
                  textAlign: TextAlign.center)),
          const SizedBox(height: 10),
          SizedBox(
              width: 100,
              child: Row(
                children: [
                  Icon(
                    Symbols.checklist_rtl,
                    color: MiAnddesTheme.of(context).secondary,
                    size: 24.0,
                  ),
                  Text('${widget.processActivityContent.result!}%',
                      style: MiAnddesTheme.of(context).titleLarge)
                ],
              ))
        ],
      ),
    );
  }

  Widget questionWidget() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 14.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evaluación',
                style: MiAnddesTheme.of(context).titleSmall.override(
                    fontFamily: 'NeoSansStd',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false),
              ),
              const SizedBox(height: 5.0),
              Text(
                _currentCard!.card.content!,
                style: MiAnddesTheme.of(context).bodyMedium.override(
                    fontFamily: 'Montserrat',
                    letterSpacing: 0.0,
                    lineHeight: 1.5,
                    fontSize: 14.0),
              ),
              const SizedBox(height: 25.0),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opciones de respuesta',
                      style: MiAnddesTheme.of(context).bodySmall.override(
                          fontFamily: 'NeoSansStd',
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false),
                    ),
                    const SizedBox(height: 8.0),
                    if (_currentCard!.card.options != null &&
                        _currentCard!.card.options!.isNotEmpty)
                      for (ELearningContentCardOption option
                          in _currentCard!.card.options!)
                        RadioListTile<ELearningContentCardOption>(
                          title: Text(
                            option.description!,
                            style: MiAnddesTheme.of(context).bodyMedium,
                          ),
                          value: option,
                          groupValue: widget.processActivityContent.content.result!=null
                              ? _currentCard!.card.options!
                                  .firstWhere((o) => o.correct!)
                              : _optionSelected,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (ELearningContentCardOption? value) {
                            if (widget.processActivityContent.result!= null) {
                              setState(() {
                                _optionSelected = value;
                              });
                            }
                          },
                          //subtitle: const Text('Supporting text'),
                        )
                  ])
            ]));
  }

  Widget contentWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: HtmlWidget(_currentCard!.card.content!,
            textStyle: MiAnddesTheme.of(context).bodyMedium));
  }

  Widget videoWidget() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
          child: Text(
            _currentCard!.card.title!,
            textAlign: TextAlign.justify,
            style: MiAnddesTheme.of(context).bodyMedium.override(
                fontFamily: 'Montserrat',
                letterSpacing: 0.0,
                lineHeight: 1.5,
                fontSize: 14.0),
          )),
      FlutterVideoPlayer(
        path: _currentCard!.card.urlVideo!,
        videoType: VideoType.network,
        autoPlay: true,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowPlaybackSpeedMenu: false,
        placeHolder: _currentCard!.card.urlPoster != null
            ? CachedNetworkImage(
                fit: BoxFit.fitHeight,
                imageUrl: _currentCard!.card.urlPoster!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Symbols.error),
              )
            : null,
      )
    ]);
  }

  void nextButtonClick() async {
    showLoadingIndicator=true;
    if (_finished) {
      context.pop();
    } else {
      if (widget.processActivityContent.result == null) {
        _currentCard!.readMobileDate = DateTime.now();
        ProcessActivityContentCardAnswer? answer;
        if (_optionSelected != null) {
          log(_optionSelected!.description!);
          log(_optionSelected!.correct!.toString());
          _optionSelected!.checked = true;
          answer= ProcessActivityContentCardAnswer(id:DateTime.now().millisecondsSinceEpoch,readDateMobile: DateTime.now(), answer: _optionSelected,sent: false);
        }
        await _onboardingService.updateRemoteProcessActivityContent
          (widget.processId,widget.processActivityId,"${widget.processActivityContent.id}","${_currentCard!.id}",answer);

        ProcessActivityContent? processActivityContent= await _onboardingService.findRemoteProcessActivityContent(widget.processId, widget.processActivityId,"${widget.processActivityContent.id}");
        _currentCard = processActivityContent!.cards.firstWhere((c) => c.readMobileDate == null );
        _currentIndex = processActivityContent.cards.indexOf(_currentCard!);
        if(_currentCard==null){
          _finished=true;

        }
      }else{

      }
      if ((_currentIndex + 1) >= widget.processActivityContent.cards.length) {
        if (widget.processActivityContent.result == null) {
          try {
            ELearningResult result = await _onboardingService.calculateResult(
                1,
                widget.processId,
                widget.processActivityId,
                widget.processActivityContent.id);

            widget.processActivityContent.result = result.result;
            widget.processActivityContent.progress = 100;
            _finished = true;
            //_onboardingService.updateContent(widget.processActivityContent);
          } on Exception {
            //widget.eLearningContent.sent = false;
            //widget.eLearningContent.progress = 100;
            //widget.eLearningContent.finished = _finished = true;
            //_onboardingService.updateContent(widget.eLearningContent);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Hubo un problema al registrar la inducción elearning. Por favor vuelva a intentarlo mas tarde.')));
            }
            context.pop();
            return;
          }
        }
        setState(() {
          _finished = true;
          _currentCard = null;
          _currentIndex = -1;
        });
      } else {
        setState(() {
          _canContinue = false;
        });
        setTimer();
        _currentIndex++;
        /*_currentCard = widget.eLearningContent.cards![_currentIndex];
        if (widget.eLearningContent.finished != null &&
            !widget.eLearningContent.finished!) {
          widget.eLearningContent.progress =
              (_currentIndex * 100 / widget.eLearningContent.cards!.length)
                  .round();
          _onboardingService.updateContent(widget.eLearningContent);
        }*/
        setState(() {});
      }
    }
  }

  void setTimer() async{
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _canContinue = true;
    });
  }
}
