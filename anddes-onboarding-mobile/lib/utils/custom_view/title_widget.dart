import 'package:flutter/cupertino.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_icon_button.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

class TitleWidget extends StatefulWidget {
  final BuildContext? context;
  final IconData? iconData;
  final String title;
  final bool canGoBack;
  final bool returnToActivityList;
  const TitleWidget({
    super.key,
    required this.context,
    this.iconData,
    required this.title,
    this.canGoBack=true,
    this.returnToActivityList=true,
  });

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.iconData!=null?FlutterIconButton(
          //buttonSize: 30.0,
          icon: Icon(
            widget
                .iconData /*Icons.arrow_back*/,
            color:
            MiAnddesTheme
                .of(context)
                .primaryText,
            size: Constants.miAnddessIconSize,
            weight: Constants.miAnddesIconWeight
          ),
          onPressed: () {
            if (widget.canGoBack) {
              if (widget.returnToActivityList) {
                widget.context!.pushReplacementNamed('activity-list');
              } else {
                widget.context!.pop();
              }
            }
          },
        ):const SizedBox(),
        SizedBox(
            height: 21,
            width: 250,
            child: Text(
              widget.title.length>24?'${widget.title.substring(0,22)}..':widget.title,
              style: MiAnddesTheme
                  .of(context)
                  .titleLarge
                  .override(
                fontSize: 21.0,
                useGoogleFonts: false,
                fontFamily: 'NeoSansStd',
                letterSpacing: 0.0,
                lineHeight: 1.0,
              ),
            )),
      ],
    );
  }
}
