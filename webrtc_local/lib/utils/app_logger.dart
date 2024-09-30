import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal();

  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() {
    return _instance;
  }

  late final Logger _logger;

  void init({Level level = Level.debug}) {
    _logger = Logger(
      level: level,
      printer: PrettyPrinter(),
    );
  }

  void log(String message, {Level level = Level.debug}) {
    _logger.log(level, message);
  }

  void debug(String message) => _logger.d(message);
  void info(String message) => _logger.i(message);
  void warning(String message) => _logger.w(message);
  void error(String message) => _logger.e(message);
}
