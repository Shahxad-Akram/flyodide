import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flyodide/flyodide.dart';
import 'package:highlight/languages/python.dart';

class PyCodeEditor extends StatelessWidget {
  PyCodeEditor({super.key, required this.pyCodeController});

  // final List<CodePrompt> _directPrompts = [];

  final FlyodideController pyCodeController;

  final controller = CodeController(
    text: """
import numpy as np
aa = np.random.rand(3)
aa

import pandas as pd

data = {
  "calories": [420, 380, 390],
  "duration": [50, 40, 45]
}

#load data into a DataFrame object:
df = pd.DataFrame(data)

sd =df.to_dict()
sd

""", // Initial code
    language: python,
  );

  // final Map<String, List<CodePrompt>> _relatedPrompts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: SingleChildScrollView(
          child: CodeField(
            controller: controller,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ListenableBuilder(
        builder: (context, child) {
          if (kDebugMode) {
            print("isPyodideLoaded: ${pyCodeController.isPyodideLoaded}");
          }
          return pyCodeController.isPyodideLoaded
              ? child!
              : CircularProgressIndicator();
        },
        listenable: pyCodeController,
        child: FloatingActionButton(
          onPressed: () async {
            await pyCodeController.executePythonCode(controller.text);
            pyCodeController.pythonOutput = "";
            pyCodeController.pythonError = "";
          },
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class ContextMenuItemWidget extends PopupMenuItem<void>
    implements PreferredSizeWidget {
  ContextMenuItemWidget({
    super.key,
    required String text,
    required VoidCallback onTap,
  }) : super(onTap: onTap, child: Text(text));

  @override
  Size get preferredSize => const Size(150, 25);
}
