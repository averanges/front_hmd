import 'package:haimdall/env/environment.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime),
  output: _ConsoleOutput(),
  filter: Environment.instance.isDebugMode ? ProductionFilter() : null,
);

class Log {
  const Log._();

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void e(String message, dynamic error) {
    _logger.e(message, error: error);
  }
}

class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(printWrapped);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    // ignore: avoid_print
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
