import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/model/azure_response.dart';
import 'package:pkce/pkce.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../model/token.dart';
import '../../../service/azure_auth_service.dart';
import '../../constants.dart';
import '../optional_param.dart';

/// A widget that embeds the Azure AD B2C web view for authentication purposes.
class ADB2CEmbedWebView extends StatefulWidget {
  final Function(BuildContext context)? onRedirect;
  final Function(BuildContext context)? onErrorOrCancel;
  final ValueChanged<Token> onAccessToken;
  final ValueChanged<Token> onIDToken;
  final ValueChanged<Token> onRefreshToken;
  final ValueChanged<Token>? onAnyTokenRetrieved;
  final List<OptionalParam> optionalParameters;
  final Widget? loadingReplacement;
  final Color webViewBackgroundColor;
  final String? userAgent;

  const ADB2CEmbedWebView({
    super.key,
    required this.onAccessToken,
    required this.onIDToken,
    required this.onRefreshToken,
    required this.optionalParameters,

    // Optionals
    this.onRedirect,
    this.onErrorOrCancel,
    this.onAnyTokenRetrieved,
    this.loadingReplacement,
    this.webViewBackgroundColor = const Color(0x00000000),
    this.userAgent,
  });

  @override
  ADB2CEmbedWebViewState createState() => ADB2CEmbedWebViewState();
}

class ADB2CEmbedWebViewState extends State<ADB2CEmbedWebView> {
  final _key = UniqueKey();
  final PkcePair pkcePairInstance = PkcePair.generate();
  WebViewController? controller;
  late Function(BuildContext context) onRedirect;
  late Function(BuildContext context) onErrorOrCancel;
  Widget? loadingReplacement;

  bool isLoading = true;
  bool showRedirect = false;

  @override
  void initState() {
    super.initState();
    onRedirect = widget.onRedirect ??
        (context) {
          Navigator.of(context).pop();
        };
    onErrorOrCancel = widget.onErrorOrCancel ??
        (context) {
          Navigator.of(context).pop();
        };
    loadingReplacement = widget.loadingReplacement;
    log("sUserFlowUrl=${getUserFlowUrl(
      userFlow: "${Constants.tenantUrl}/${Constants.userFlowUrlEnding}",
    )}");
    final webViewController = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.webViewBackgroundColor)
      ..setUserAgent(widget.userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onUrlChange: (change) {
              //final Uri response = Uri.dataFromString(change.url!);
              //onPageFinishedTasks(change.url!, response);
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            onNavigationRequest: (request) async {
              log("onNavigationRequest request.url=${request.url}");
              if (request.url.contains(Constants.redirectUrl) &&
                  !request.url.contains("redirect_uri=")) {
                log("loadingReplacement !=null = ${loadingReplacement != null}");
                setState(() {
                  showRedirect = true;
                });
                log("NavigationDecision.prevent");
                onPageFinishedTasks(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            }),
      )
      ..loadRequest(
        Uri.parse(getUserFlowUrl(
          userFlow: "${Constants.tenantUrl}/${Constants.userFlowUrlEnding}",
        )),
      );
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller = webViewController;
  }

  @override
  void dispose() {
    super.dispose();
    controller = null;
  }

  /// Callback function for handling any token received.
  void onAnyTokenRecivedCallback(Token token) {
    if (widget.onAnyTokenRetrieved != null) {
      widget.onAnyTokenRetrieved!(token);
    }
  }

  /// Handles the callbacks for the received tokens.
  void handleTokenCallbacks({required AzureTokenResponse? tokensData}) {
    String? accessTokenValue = tokensData?.accessToken;
    String? idTokenValue = tokensData?.idToken;
    String? refreshTokenValue = tokensData?.refreshToken;

    if (accessTokenValue != null) {
      final Token token = Token(
          type: TokenType.accessToken,
          value: accessTokenValue,
          expirationTime: tokensData?.refreshTokenExpireTime);
      widget.onAccessToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (idTokenValue != null) {
      final token = Token(type: TokenType.idToken, value: idTokenValue);
      widget.onIDToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (refreshTokenValue != null) {
      final Token token = Token(
          type: TokenType.refreshToken,
          value: refreshTokenValue,
          expirationTime: tokensData?.refreshTokenExpireTime);
      widget.onRefreshToken(token);
      onAnyTokenRecivedCallback(token);
    }
  }

  // Performs the authorization code flow using the provided URL.
  Future<void> authorizationCodeFlow(url) async {
    //onRedirect(context);
    log("url=$url");
    String authCode =
        Uri.dataFromString(url).queryParameters[Constants.authCode]!;
    log("authCode=$authCode");
    //String authCode = url.split("${Constants.authCode}=")[1];

    AzureAuthService clientAuthentication =
        AzureAuthService(pkcePair: pkcePairInstance);
    final AzureTokenResponse? tokensData =
        await clientAuthentication.getAllTokens(authCode: authCode);
    //log("accessToken=${tokensData?.accessToken}");
    //log("idToken=${tokensData?.idToken}");
    //log("refreshToken=${tokensData?.refreshToken}");
    //log("refreshTokenExpireTime=${tokensData?.refreshTokenExpireTime}");

    if (tokensData != null) {
      if (!mounted) return;
      // call redirect function
      handleTokenCallbacks(tokensData: tokensData);
    }
  }

  /// Executes tasks when the page finishes loading.
  dynamic onPageFinishedTasks(String url /*, Uri response*/) {
    //log("onPageFinishedTasks url=$url");
    //log("onPageFinishedTasks response.path=${response.path}");
    if (url.contains(Constants.redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.accessToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.authCode)) {
        //Run authorization code flow and get access token.
        authorizationCodeFlow(url);
      } else {
        // Assume login cancelled or something else went wrong
        onErrorOrCancel(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebViewWidget(
            key: _key,
            controller: controller!,
          ),
          Visibility(
              visible:
                  loadingReplacement != null && (isLoading || showRedirect),
              child: loadingReplacement ?? const SizedBox()),
          Visibility(
            visible: loadingReplacement == null && (isLoading || showRedirect),
            child: const Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
          ),
          Visibility(
            visible: loadingReplacement == null && isLoading,
            child: const Positioned(
              child: Center(
                child: Text('Cargando...'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constructs the user flow URL with optional parameters.
  String getUserFlowUrl({required String userFlow}) {
    List<String>? userFlowSplit = userFlow.split('?');
    //Check if the user added the full user flow or just till 'authorize'
    if (userFlowSplit.length == 1) {
      return concatUserFlow(userFlow);
    }
    return userFlow;
  }

  /// Concatenates the user flow URL with additional parameters.
  String concatUserFlow(String url) {
    const idClientParam = 'client_id=';
    const nonceParam = '&nonce=defaultNonce&redirect_uri=';
    const scopeParam = '&scope=';
    const responseTypeParam = '&response_type=';
    const promptParam = '&prompt=login';

    const codeChallengeMethod =
        '&code_challenge_method=${Constants.defaultCodeChallengeCode}';
    final codeChallenge = "&code_challenge=${pkcePairInstance.codeChallenge}";

    String newParameters = "";
    if (widget.optionalParameters.isNotEmpty) {
      for (OptionalParam param in widget.optionalParameters) {
        newParameters += "&${param.key}=${param.value}";
      }
    }
    return '$url?$idClientParam${Constants.clientId}$nonceParam${Constants.redirectUrl}$scopeParam${Constants.defaultScopes.replaceAll(" ", Constants.blankEncodedHtml)}$responseTypeParam${Constants.defaultResponseType}$promptParam$codeChallenge$codeChallengeMethod$newParameters';
  }
}
