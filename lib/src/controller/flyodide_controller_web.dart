// import 'dart:convert';
// import 'dart:js_interop';

// import 'package:flutter/foundation.dart';

// class FlyodideControllerJSInterop {
//   @JS('PyodideLoadedCallback')
//   external set pyodideLoadedCallback(JSFunction callback);

//   @JS('PyodideErrorCallback')
//   external set pyodideErrorCallback(JSFunction callback);

//   @JS('PythonReturnCallback')
//   external set pythonReturnCallback(JSFunction callback);

//   @JS('PythonOutputCallback')
//   external set pythonOutputCallback(JSFunction callback);

//   @JS('PythonErrorCallback')
//   external set pythonErrorCallback(JSFunction callback);

//   @JS('initPyodide')
//   external void initPyodide(String pyodideIndexUrl);

//   @JS('executePythonCode')
//   external void executePythonCode(String pythonCode);
// }

// class FlyodideControllerPlatform extends ChangeNotifier {
//   FlyodideControllerJSInterop flyodideControllerJSInterop =
//       FlyodideControllerJSInterop();

//   String pythonOutput = '';
//   String pythonError = '';
//   String pyodideLoadStatus = 'Loading Pyodide...';
//   bool isPyodideLoaded = false;

//   String? pyodideIndexUrl;
//   dynamic pythonReturn;

//   FlyodideControllerPlatform() {
//     flyodideControllerJSInterop.pyodideLoadedCallback = onPyodideLoaded.toJS;
//     flyodideControllerJSInterop.pyodideErrorCallback = onPyodideError.toJS;
//     flyodideControllerJSInterop.pythonReturnCallback = onPythonReturn.toJS;
//     flyodideControllerJSInterop.pythonOutputCallback = onPythonOutput.toJS;
//     flyodideControllerJSInterop.pythonErrorCallback = onPythonError.toJS;
//   }

//   Future<FlyodideControllerPlatform> initController(
//       {String pyodideIndexUrl =
//           'https://cdn.jsdelivr.net/pyodide/v0.27.5/full/',
//       int serverPort = 0}) async {
//     flyodideControllerJSInterop.initPyodide(pyodideIndexUrl);
//     return this;
//   }

//   void onPyodideLoaded(JSNumber onPyodideLoadedCallbackMessage) {
//     isPyodideLoaded = true;
//     var msg = onPyodideLoadedCallbackMessage.toString();
//     pyodideLoadStatus = msg;
//     notifyListeners();
//     _controllerDebugPrint(msg);
//   }

//   void onPyodideError(JSNumber onPyodideErrorCallbackMessage) {
//     isPyodideLoaded = false;
//     var msg = onPyodideErrorCallbackMessage.toString();
//     pyodideLoadStatus = msg;
//     notifyListeners();
//     _controllerDebugPrint(msg);
//   }

//   void onPythonReturn(JSNumber onPythonReturnCallbackMessage) {
//     pythonReturn = json.decode(onPythonReturnCallbackMessage.toString());
//     notifyListeners();
//   }

//   void onPythonOutput(JSNumber onPythonOutputCallbackMessage) {
//     pythonOutput += '${onPythonOutputCallbackMessage.toString()}\n';
//     notifyListeners();
//   }

//   void onPythonError(JSNumber onPythonErrorCallbackMessage) {
//     pythonError += '${onPythonErrorCallbackMessage.toString()}\n';
//     notifyListeners();
//   }

//   void _controllerDebugPrint(String debugMessage) {
//     if (kDebugMode) print('FlyodideConsoleMessage: $debugMessage');
//   }

//   Future<void> executePythonCode(String pythonCode) async {
//     flyodideControllerJSInterop.executePythonCode(pythonCode);
//     return;
//   }

//   Future<void> closeController() async {
//     return;
//   }
// }
