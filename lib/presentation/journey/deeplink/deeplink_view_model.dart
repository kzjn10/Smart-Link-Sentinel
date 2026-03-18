import 'dart:async';
import 'dart:developer' as AppLogger;

import 'package:injectable/injectable.dart';

import '../../../core/base/base_view_model.dart';
import '../../../domain/repositories/history_repository.dart';
import 'deeplink_state.dart';

@injectable
class DeeplinkViewModel extends BaseViewModel<DeeplinkState> {
  final HistoryRepository _historyRepository;
  Timer? _debounce;

  DeeplinkViewModel(this._historyRepository) : super(const DeeplinkState());

  void addHistory(String link) {
    _historyRepository.addHistory(link);
  }

  void onLinkChanged(String link) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _parseLink(link);
    });
  }

  Future<void> _parseLink(String link) async {
    try {
      AppLogger.log(link);
      final uri = Uri.parse(link);

      // Tạo Map để chứa dữ liệu theo định dạng trong ảnh
      Map<String, dynamic> urlParts = {
        "Scheme": uri.scheme,
        "Protocol": uri.scheme,
        "Authority": uri.authority,
        "Host": uri.host,
        "Hostname": uri.host,
        "Domain": uri.host,
        "Tld": uri.host, // Với custom scheme, TLD thường trùng với host
        "Resource": uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
        "Directory": uri.path.endsWith('/')
            ? uri.path.substring(0, uri.path.length - 1)
            : uri.path,
        "Path": uri.path,
        "Query string": uri.query,
      };

      // In phần -URL Parts-
      print("-URL Parts-");
      urlParts.forEach((key, value) => print("$key: $value"));

      // In phần -Query String-
      print("\n-Query String-");
      if (uri.queryParameters.isEmpty) {
        print("No query parameters found.");
      } else {
        uri.queryParameters.forEach((key, value) {
          print("'$key': $value");
        });
      }
    } catch (e) {
      emit(state.copyWith(viewState: .error));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
