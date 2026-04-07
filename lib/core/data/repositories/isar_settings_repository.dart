import 'package:isar/isar.dart';
import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/mappers/isar_domain_mappers.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';

class IsarSettingsRepository implements SettingsRepository {
  IsarSettingsRepository(this._isar);

  final Isar _isar;

  @override
  Future<AppSettings?> getSettings() async {
    final record = await _isar.appSettingsRecords.where().findFirst();
    return record?.toDomain();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final existing = await _isar.appSettingsRecords.filter().idEqualTo(settings.id).findFirst();
    await _isar.writeTxn(() async {
      await _isar.appSettingsRecords.put(settings.toRecord(existing));
    });
  }
}