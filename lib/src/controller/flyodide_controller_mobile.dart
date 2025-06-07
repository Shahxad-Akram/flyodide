import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class FlyodideControllerPlatform extends ChangeNotifier {
  final webViewControllerPlus = WebViewControllerPlus();

  String pythonOutput = '';
  String pythonError = '';
  String pyodideLoadStatus = 'Loading Pyodide...';
  bool isPyodideLoaded = false;

  String? pyodideIndexUrl;
  dynamic pythonReturn;

  FlyodideControllerPlatform() {
    webViewControllerPlus
      ..addJavaScriptChannel(
        'PyodideLoadedCallback',
        onMessageReceived: (onPyodideLoadedCallbackMessage) {
          isPyodideLoaded = true;
          var msg = onPyodideLoadedCallbackMessage.message;
          pyodideLoadStatus = msg;
          notifyListeners();
          _controllerDebugPrint(msg);
        },
      )
      ..addJavaScriptChannel(
        'PyodideErrorCallback',
        onMessageReceived: (onPyodideErrorCallbackMessage) {
          isPyodideLoaded = false;
          var msg = onPyodideErrorCallbackMessage.message;
          pyodideLoadStatus = msg;
          notifyListeners();
          _controllerDebugPrint(msg);
        },
      )
      ..addJavaScriptChannel(
        'PythonReturnCallback',
        onMessageReceived: (onPythonReturnCallbackMessage) {
          pythonReturn = json.decode(onPythonReturnCallbackMessage.message);
          notifyListeners();
        },
      )
      ..addJavaScriptChannel(
        'PythonOutputCallback',
        onMessageReceived: (onPythonOutputCallbackMessage) {
          pythonOutput += '${onPythonOutputCallbackMessage.message}\n';
          notifyListeners();
        },
      )
      ..addJavaScriptChannel(
        'PythonErrorCallback',
        onMessageReceived: (onPythonErrorCallbackMessage) {
          pythonError += '${onPythonErrorCallbackMessage.message}\n';
          notifyListeners();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            await webViewControllerPlus
                .runJavaScript("initPyodide('$pyodideIndexUrl');");
          },
        ),
      )
      ..setOnConsoleMessage(
        (message) {
          _controllerDebugPrint(message.message);
        },
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
  }

  void _controllerDebugPrint(String debugMessage) {
    if (kDebugMode) print('FlyodideConsoleMessage: $debugMessage');
  }

  // Future<List> jediCodeCompletion(String source, int line, int column) async {
  //   final jediPrompt =
  //       "[[c.name, c.type] for c in jedi.Script('''$source''').complete($line, $column)]";

  //   var codeCompletions = json.decode(
  //       (await webViewController.runJavaScriptReturningResult(
  //               "autoCompleteWithJedi(${jsonEncode(jediPrompt.replaceAll("\"", "\\\""))});"))
  //           .toString());

  //   notifyListeners();
  //   return codeCompletions;
  // }

  Future<FlyodideControllerPlatform> initController(
      {String pyodideIndexUrl =
          'https://cdn.jsdelivr.net/pyodide/v0.27.5/full/',
      int serverPort = 0}) async {
    this.pyodideIndexUrl = Uri.parse(pyodideIndexUrl).isAbsolute
        ? pyodideIndexUrl
        : pyodideIndexUrl;

    // await webViewControllerPlus.loadFlutterAssetWithServer(
    //     'packages/flyodide/core/flyodide.html', localHostServer.port!);

    await webViewControllerPlus
        .loadFlutterAsset('packages/flyodide/core/flyodide.html');

    return this;
  }

  Future<void> executePythonCode(String pythonCode) async {
    return await webViewControllerPlus
        .runJavaScript('executePythonCode(`$pythonCode`);');
  }

  // Future<void> closeController() async {
  //   return await localHostServer.close();
  // }
}
