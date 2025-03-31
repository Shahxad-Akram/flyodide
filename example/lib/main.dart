import 'package:flutter/material.dart';
import 'package:flyodide/flyodide.dart';
import 'package:flyodide_example/code_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PyCodeApp());
}

class PyCodeApp extends StatelessWidget {
  const PyCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Code Editor'),
      ),
      body: FutureBuilder<FlyodideController>(
          future: FlyodideController().initController(),
          builder: (_, snap) {
            if (snap.hasData && !snap.hasError) {
              final pyCodeController = snap.data!;
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 500,
                    child: PyCodeEditor(
                      pyCodeController: pyCodeController,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: ListenableBuilder(
                          listenable: pyCodeController,
                          builder: (context, child) {
                            return RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: pyCodeController.pythonOutput,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: pyCodeController.pythonError,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
