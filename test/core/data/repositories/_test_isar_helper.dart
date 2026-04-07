import 'dart:io';

import 'package:isar/isar.dart';
import 'package:smartfit/core/data/isar/smartfit_isar.dart';

class TestIsarHelper {
  TestIsarHelper._(this.directory, this.isar);

  static Future<void>? _coreInitialization;

  final Directory directory;
  final Isar isar;

  static Future<TestIsarHelper> create() async {
    await (_coreInitialization ??= Isar.initializeIsarCore(download: true));
    final directory = await Directory.systemTemp.createTemp('smartfit_isar_test_');
    final isar = await SmartFitIsar.openAt(
      directory.path,
      name: 'smartfit_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    return TestIsarHelper._(directory, isar);
  }

  Future<void> dispose() async {
    await isar.close(deleteFromDisk: true);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}