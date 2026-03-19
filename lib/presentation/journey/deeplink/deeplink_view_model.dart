import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/analyze_link_usecase.dart';
import 'deeplink_state.dart';

@injectable
class DeeplinkViewModel extends BaseViewModel<DeeplinkState> {
  final AnalyzeLinkUseCase _analyzeLinkUseCase;
  Timer? _debounce;

  DeeplinkViewModel(
    this._analyzeLinkUseCase,
  ) : super(const DeeplinkState());

  Future<void> addOrUpdateHistory(String link) async {
    unawaited(_analyzeLinkUseCase.execute(link));
  }

  Future<void> onLinkChanged(String link) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await _parseLink(link);
    });
  }

  Future<void> _parseLink(String link) async {
    try {
      AppLogger.debug(link);
      emit(state.copyWith(resourceIdentifier: link, viewState: .loading));
      final uri = Uri.parse(link);
      Map<String, dynamic> urlParts = {
        "Scheme": uri.scheme,
        "Protocol": uri.scheme,
        "Authority": uri.authority,
        "Host": uri.host,
        "Hostname": uri.host,
        "Domain": uri.host,
        "Tld": uri.host,
        "Resource": uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
        "Directory": uri.path.endsWith('/')
            ? uri.path.substring(0, uri.path.length - 1)
            : uri.path,
        "Path": uri.path,
        "Query string": uri.query,
      };

      AppLogger.debug('\n----- URL Parts -----\n');
      urlParts.forEach((key, value) => AppLogger.debug("$key: $value"));

      AppLogger.debug('\n----- Query String-----\n');
      if (uri.queryParameters.isEmpty) {
        AppLogger.debug('No query parameters found.');
      } else {
        uri.queryParameters.forEach((key, value) {
          AppLogger.debug('$key: $value');
        });
      }
      emit(
        state.copyWith(
          viewState: .loaded,
          parsedData: urlParts,
          queryParameters: uri.queryParameters,
        ),
      );
    } catch (e) {
      AppLogger.error(e.toString());
      emit(state.copyWith(viewState: .error));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
