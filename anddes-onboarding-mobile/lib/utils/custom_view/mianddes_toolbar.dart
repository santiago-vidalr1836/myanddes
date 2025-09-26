import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import 'flutter_icon_button.dart';
import 'mianddes_theme.dart';

class MiAnddesToolbar extends StatefulWidget {
  final BuildContext? context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MiAnddesToolbar(
      {super.key, required this.context, required this.scaffoldKey});

  @override
  State<MiAnddesToolbar> createState() => _MiAnddesToolbarState();
}

class _MiAnddesToolbarState extends State<MiAnddesToolbar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlutterIconButton(
              buttonSize: 40.0,
              icon: Icon(
                Symbols.menu,
                color: MiAnddesTheme.of(context).primaryBackground,
                size: Constants.miAnddessIconSize,
                weight: Constants.miAnddesIconWeight,
              ),
              onPressed: () async {
                widget.scaffoldKey.currentState!.openDrawer();
              },
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/logo-blanco.png',
                  width: 116.0,
                  height: 51.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ].divide(const SizedBox(width: 11.0)),
        ),
      ),
    );
  }
}
