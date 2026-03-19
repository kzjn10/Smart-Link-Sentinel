import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/settings_repository.dart';

@singleton
class LocaleCubit extends Cubit<String?> {
  final SettingsRepository _settingsRepository;

  LocaleCubit(this._settingsRepository) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final langCode = await _settingsRepository.getLanguageCode();
    emit(langCode);
  }

  Future<void> changeLocale(String? langCode) async {
    await _settingsRepository.saveLanguageCode(langCode);
    emit(langCode);
  }
}
