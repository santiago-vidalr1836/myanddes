import 'package:flutter/material.dart';

import 'mianddes_sidebar.dart';
import 'mianddes_theme.dart';
import 'mianddes_toolbar.dart';

class MiAnddesCommonPage extends StatefulWidget {
  final BuildContext? context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget content;
  final VoidCallback onTap;
  final Widget titleWidget;
  const MiAnddesCommonPage(
      {super.key,
      required this.context,
      required this.scaffoldKey,
      required this.content,
      required this.onTap,
      required this.titleWidget});

  @override
  State<MiAnddesCommonPage> createState() => _MiAnddesCommonPageState();
}

class _MiAnddesCommonPageState extends State<MiAnddesCommonPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onTap(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: widget.scaffoldKey,
            backgroundColor: MiAnddesTheme.of(context).primaryBackground,
            drawer: MiAnddesSidebar(context: context),
            body: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: MiAnddesTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset("assets/images/background.png").image,
                  ),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  MiAnddesToolbar(
                    context: context,
                    scaffoldKey: widget.scaffoldKey,
                  ),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 15.0),
                      child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.80,
                          constraints: const BoxConstraints(
                              maxWidth: 500.0, maxHeight: double.infinity),
                          decoration: BoxDecoration(
                            color:
                                MiAnddesTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0,),
                                    widget.titleWidget,
                                    const SizedBox(height: 1.0),
                                    Expanded(child: widget.content)
                                  ]))))
                ]))));
  }
}
