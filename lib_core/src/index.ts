import { loadPyodide, PyodideInterface } from 'pyodide';

let pyodide: PyodideInterface;
let executingCode: boolean = false;

async function initPyodide(indexURL: string) {
    try {
        pyodide = await loadPyodide({
            indexURL: indexURL,
            stdout: (std_out: any) => {
                channelMessageHandler((window as any).PythonOutputCallback, std_out);
            },
        });
        channelMessageHandler((window as any).PyodideLoadedCallback, "Pyodide loaded successfully...!");
    } catch (e) {
        channelMessageHandler((window as any).PyodideErrorCallback, "***Error loading Pyodide***, " + e);
    }
}

async function executePythonCode(code: string) {
    try {
        if (executingCode) {
            return;
        }
        executingCode = true;
        await pyodide.loadPackagesFromImports(code);
        var codeReturn = await pyodide.runPythonAsync(code);
        if (codeReturn !== undefined) {

            channelMessageHandler((window as any).PythonReturnCallback,
                JSON.stringify(codeReturn.toJs()));
        }
        executingCode = false;
    } catch (e) {
        const pyError = pyodide.runPython(`
            from traceback import format_exception
            import sys
            "".join(
                format_exception(sys.last_type, sys.last_value, sys.last_traceback)
            )
        `);
        channelMessageHandler((window as any).PythonErrorCallback, pyError);
        executingCode = false;
    }
}


function channelMessageHandler(channel: any, message: any) {
    if (channel) {
        channel.postMessage(message);
    } else {
        console.log(message);
    }
}

(window as any).initPyodide = initPyodide;
(window as any).executePythonCode = executePythonCode;