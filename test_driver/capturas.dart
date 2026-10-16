import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (nombre, bytes, [argumentos]) async {
      final carpeta = Directory('entrega1/capturas');
      await carpeta.create(recursive: true);
      await File('${carpeta.path}/$nombre.png').writeAsBytes(bytes);
      return true;
    },
  );
}
