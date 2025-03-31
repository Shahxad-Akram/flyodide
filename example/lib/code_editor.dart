import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atelier-seaside-light.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flyodide/flyodide.dart';
import 'package:flyodide_example/default_code_autocomplete_listview.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/python.dart';

class PyCodeEditor extends StatelessWidget {
  PyCodeEditor({super.key, required this.pyCodeController}) {
    _codeLineEditorController.text = intCode;
  }

  // final List<CodePrompt> _directPrompts = [];

  final FlyodideController pyCodeController;

  final CodeLineEditingController _codeLineEditorController =
      CodeLineEditingController();

  // final Map<String, List<CodePrompt>> _relatedPrompts = {};

  final String intCode = """
import numpy as np
aa = np.random.rand(3,2,3)
aa
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CodeAutocomplete(
          viewBuilder: (context, notifier, onSelected) {
            return DefaultCodeAutocompleteListView(
              notifier: notifier,
              onSelected: onSelected,
            );
          },
          promptsBuilder: DefaultCodeAutocompletePromptsBuilder(
            language: langPython,
            // directPrompts: _directPrompts,
            // relatedPrompts: _relatedPrompts,
          ),
          child: CodeEditor(
            style: CodeEditorStyle(
              backgroundColor:
                  atelierSeasideLightTheme['root']!.backgroundColor,
              fontSize: 18,
              codeTheme: CodeHighlightTheme(languages: {
                'python': CodeHighlightThemeMode(
                  mode: langPython,
                )
              }, theme: monokaiTheme),
            ),

            controller: _codeLineEditorController,
            wordWrap: false,
            indicatorBuilder:
                (context, editingController, chunkController, notifier) {
              return Row(
                children: [
                  DefaultCodeLineNumber(
                    controller: editingController,
                    notifier: notifier,
                  ),
                  DefaultCodeChunkIndicator(
                      width: 20,
                      controller: chunkController,
                      notifier: notifier)
                ],
              );
            },
            // findBuilder: (context, controller, readOnly) =>
            //     CodeFindPanelView(controller: controller, readOnly: readOnly),
            toolbarController: const ContextMenuControllerImpl(),
            sperator: Container(width: 1, color: Colors.blueGrey),
            autocompleteSymbols: true,
          )),
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
            await pyCodeController
                .executePythonCode(_codeLineEditorController.text);
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

class ContextMenuControllerImpl implements SelectionToolbarController {
  const ContextMenuControllerImpl();

  @override
  void hide(BuildContext context) {}

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    showMenu(
        context: context,
        position: RelativeRect.fromSize(
            anchors.primaryAnchor & const Size(150, double.infinity),
            MediaQuery.of(context).size),
        items: [
          ContextMenuItemWidget(
            text: 'Cut',
            onTap: () {
              controller.cut();
            },
          ),
          ContextMenuItemWidget(
            text: 'Copy',
            onTap: () {
              controller.copy();
            },
          ),
          ContextMenuItemWidget(
            text: 'Paste',
            onTap: () {
              controller.paste();
            },
          ),
        ]);
  }
}
