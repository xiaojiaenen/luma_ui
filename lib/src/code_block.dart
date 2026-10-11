import 'strings.dart';
import 'icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components.dart';
import 'design.dart';
import 'toast.dart';

/// Lightweight lexical highlighting for Dart, JSON and YAML; safe plain text fallback.
class SoftCodeBlock extends StatelessWidget {
  const SoftCodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.maxHeight = 300,
  });
  final String code, language;
  final double maxHeight;
  static final tokens = RegExp(
    r'''//[^\n]*|/\*[\s\S]*?\*/|\#[^\n]*|'(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*"|\b\d+(?:\.\d+)?\b|\b[A-Za-z_]\w*\b''',
  );
  List<TextSpan> highlight(Color accent) {
    if (!['dart', 'json', 'yaml'].contains(language)) {
      return [TextSpan(text: code)];
    }
    const keywords = {
      'class',
      'const',
      'final',
      'var',
      'return',
      'if',
      'else',
      'for',
      'while',
      'void',
      'import',
      'export',
      'extends',
      'super',
      'this',
      'required',
      'true',
      'false',
      'null',
      'async',
      'await',
      'new',
      'switch',
      'case',
      'enum',
      'static',
      'late',
      'override',
      'in',
      'is',
      'as',
      'with',
      'implements',
    };
    final spans = <TextSpan>[];
    var offset = 0;
    for (final m in tokens.allMatches(code)) {
      if (m.start > offset) {
        spans.add(TextSpan(text: code.substring(offset, m.start)));
      }
      final token = m.group(0)!;
      Color? color;
      if (token.startsWith('//') ||
          token.startsWith('/*') ||
          token.startsWith('#')) {
        color = const Color(0xFF97A2A6);
      } else if (token.startsWith("'") || token.startsWith('"')) {
        color = const Color(0xFFC3D8B2);
      } else if (RegExp(r'^\d').hasMatch(token)) {
        color = const Color(0xFFE7C99D);
      } else if (keywords.contains(token)) {
        color = Color.lerp(accent, Colors.white, .45);
      } else if (RegExp(r'^[A-Z]').hasMatch(token)) {
        color = const Color(0xFFD8C8E7);
      }
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(color: color),
        ),
      );
      offset = m.end;
    }
    if (offset < code.length) {
      spans.add(TextSpan(text: code.substring(offset)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: SoftTokens.ink,
      borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
      border: Border.all(color: Colors.white.withValues(alpha: .25)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
              IconButton(
                tooltip: softText(context, 'Copy code'),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (context.mounted) {
                    showSoftToast(context, '代码已复制');
                  }
                },
                icon: const SoftIcon(
                  Icons.copy_rounded,
                  size: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: SelectableText.rich(
                  TextSpan(children: highlight(SoftDesign.of(context).accent)),
                  style: const TextStyle(
                    fontFamily: SoftTokens.monoFontFamily,
                    fontFamilyFallback: [SoftTokens.fontFamily, 'monospace'],
                    fontSize: 12,
                    height: 1.7,
                    color: Color(0xFFF1F3F4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
