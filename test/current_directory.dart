import 'dart:io';

Directory savedCurrentDirectory;

/// Set current directory relative to initial current directory.
void setCurrentDirectory(String path) {
  if (savedCurrentDirectory == null) {
    savedCurrentDirectory = Directory.current;
  }

  if (path == null) {
    Directory.current = savedCurrentDirectory;
  } else {
    Directory.current = savedCurrentDirectory;
    Directory.current = path;
  }
}
