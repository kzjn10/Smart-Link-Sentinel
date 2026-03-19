import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    stderr.writeln('Directory not found: ${l10nDir.path}');
    exitCode = 1;
    return;
  }

  final arbFiles =
      l10nDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.arb'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in arbFiles) {
    final raw = await file.readAsString();
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      stderr.writeln('Skipping non-object ARB: ${file.path}');
      continue;
    }

    final map = Map<String, dynamic>.from(decoded);
    final sorted = _sortArb(map);
    final pretty = const JsonEncoder.withIndent('  ').convert(sorted);

    await file.writeAsString('$pretty\n');
  }
}

Map<String, dynamic> _sortArb(Map<String, dynamic> input) {
  final baseKeys = <String>{};
  final metaKeys = <String>{};

  for (final k in input.keys) {
    if (k.startsWith('@')) {
      metaKeys.add(k);
    } else {
      baseKeys.add(k);
    }
  }

  String typeOf(String key) {
    final i = key.indexOf('_');
    if (i <= 0) return '';
    return key.substring(0, i);
  }

  int specialRank(String key) {
    if (key == 'app_name' || key == 'appName') return -1000;
    if (key == 'end_content') return 1000;
    return 0;
  }

  final baseKeyList = baseKeys.toList()
    ..sort((a, b) {
      final ra = specialRank(a);
      final rb = specialRank(b);
      if (ra != rb) return ra.compareTo(rb);

      final ta = typeOf(a);
      final tb = typeOf(b);
      final tc = ta.compareTo(tb);
      if (tc != 0) return tc;
      return a.compareTo(b);
    });

  final out = <String, dynamic>{};

  for (final key in baseKeyList) {
    out[key] = input[key];

    final metaKey = '@$key';
    if (metaKeys.remove(metaKey)) {
      out[metaKey] = input[metaKey];
    }
  }

  if (metaKeys.isNotEmpty) {
    final remainingMeta = metaKeys.toList()
      ..sort((a, b) {
        final ka = a.substring(1);
        final kb = b.substring(1);

        final ta = typeOf(ka);
        final tb = typeOf(kb);
        final tc = ta.compareTo(tb);
        if (tc != 0) return tc;
        return a.compareTo(b);
      });

    for (final k in remainingMeta) {
      out[k] = input[k];
    }
  }

  return out;
}
