import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/activity_list/activity_list_widget.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content/elearning_content_widget.dart';
import 'package:mi_anddes_mobile_app/view/firstday_information/firstday_information_widget.dart';
import 'package:mi_anddes_mobile_app/view/know_your_team/know_your_team_widget.dart';
import 'package:mi_anddes_mobile_app/view/login/login_widget.dart';
import 'package:mi_anddes_mobile_app/view/onsite_induction/onsite_induction_widget.dart';
import 'package:mi_anddes_mobile_app/view/profile/profile_widget.dart';
import 'package:mi_anddes_mobile_app/view/remote_induction/remote_induction_widget.dart';
import 'package:mi_anddes_mobile_app/view/services/services_widget.dart';
import 'package:mi_anddes_mobile_app/view/splash/splash_widget.dart';
import 'package:mi_anddes_mobile_app/view/tools/tools_widget.dart';
import 'package:mi_anddes_mobile_app/view/welcome_user/welcome_user_widget.dart';
import 'package:provider/provider.dart';

import '/utils/flutter_util.dart';

export 'package:go_router/go_router.dart';

export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => const SplashWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const SplashWidget(),
        ),
        FFRoute(
          name: 'splash',
          path: '/splash',
          builder: (context, params) => const SplashWidget(),
        ),
        FFRoute(
          name: 'login',
          path: '/login',
          builder: (context, params) => const LoginWidget(),
        ),
        FFRoute(
          name: 'welcome-user',
          path: '/welcome-user',
          builder: (context, FFParameters params) => WelcomeUserWidget(
              userGivenName: params.getParam<String>(
                  "userGivenName", ParamType.String,
                  isList: false)),
        ),
        FFRoute(
          name: 'activity-list',
          path: '/activity-list',
          builder: (context, params) => const ActivityListWidget(),
        ),
        FFRoute(
          name: 'tools',
          path: '/tools',
          builder: (context, params) => const ToolsWidget(),
        ),
        FFRoute(
          name: 'profile-edit',
          path: '/profile-edit',
          builder: (context, params) => const ProfileWidget(),
        ),
        FFRoute(
          name: 'first-day-information-item',
          path: '/first-day-information-item',
          builder: (context, params) => const FirstdayInformationWidget(),
        ),
        FFRoute(
          name: 'services',
          path: '/services',
          builder: (context, params) => const ServicesWidget(),
        ),
        FFRoute(
          name: 'know-your-team',
          path: '/know-your-team',
          builder: (context, params) => const KnowYourTeamWidget(),
        ),
        FFRoute(
          name: 'onsite-induction',
          path: '/onsite-induction',
          builder: (context, params) => OnsiteInductionWidget(activityName:params.getParam<String>(
                                        "activityName", ParamType.String,
                                        isList: false) ),
        ),
        FFRoute(
          name: 'remote-induction',
          path: '/remote-induction',
          builder: (context, params) => RemoteInductionWidget(activityName:params.getParam<String>(
              "activityName", ParamType.String,
              isList: false) ),
        ),
        FFRoute(
          name: 'elearning-contents',
          path: '/elearning-contents',
          builder: (context, params) => ELearningContentWidget(
              processId:params.getParam<String>("processId", ParamType.String,isList: false),
              dateLimit:params.getParam<String>("dateLimit", ParamType.String,isList: false),
              processActivityId:params.getParam<String>("processActivityId", ParamType.String,isList: false)),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
