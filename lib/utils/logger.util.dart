import 'package:logger/logger.dart';

final Logger log = new Logger(
  printer: new PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 10,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);