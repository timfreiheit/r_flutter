import 'dart:io';

Directory _savedCurrentDirectory;
Directory get savedCurrentDirectory =>
    _savedCurrentDirectory ?? Directory.current;

/// Set current directory relative to initial current directory.
void setCurrentDirectory(String path) {
  if (_savedCurrentDirectory == null) {
    _savedCurrentDirectory = Directory.current;
  }

  if (path == null) {
    if (_savedCurrentDirectory != null) {
      Directory.current = _savedCurrentDirectory;
    }
  } else {
    Directory.current = _savedCurrentDirectory;
    Directory.current = path;
  }
}
