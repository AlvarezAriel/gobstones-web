class Loader {
  // <<abstract>>:
  // save(context);
  // read(context, event, callback);

  _setCode(context, code, mode) {
    context.editor.setCode(code, mode);
  }

  _runCode(context) {
    context.editor.onRunCode();
  }

  _setAndRunCode(context, code, mode) {
    this._setCode(context, code, mode);
    this._runCode();
  }

  _readLocalFile(event) {
    const file = _.first(event.target.files);
    const fileName = _.first(file.name.split("."));

    this._clean(event);
    return { file: file, fileName: fileName };
  }

  _clean(event) {
    event.target.value = null;
  }
}
