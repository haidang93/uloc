import 'dart:convert';
import 'dart:io';

void upgrade() async {
  final process = await Process.start(
    'dart',
    ['pub', 'global', 'activate', 'uloc'],
    runInShell: true, // needed on Windows
  );

  // Print stdout line-by-line as it comes
  process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (line) {
      print(line);
    },
  );

  // Print stderr as well (optional)
  process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (line) {
      print(line);
    },
  );

  // Wait for the process to finish
  final exitCode = await process.exitCode;
  print('Process exited with code $exitCode');
}
