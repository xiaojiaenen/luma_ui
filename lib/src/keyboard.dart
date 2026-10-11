import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Arrow keys follow reading direction. Tab/Shift+Tab remain native traversal.
KeyEventResult softSelectionKey(
  BuildContext context,
  KeyEvent event,
  int current,
  int count,
  ValueChanged<int> onChanged,
) {
  if (event is KeyUpEvent || count == 0) return KeyEventResult.ignored;
  final key = event.logicalKey;
  final rtl = Directionality.of(context) == TextDirection.rtl;
  int? next;
  if (key == LogicalKeyboardKey.arrowRight) {
    next = (current + (rtl ? -1 : 1)) % count;
  }
  if (key == LogicalKeyboardKey.arrowLeft) {
    next = (current + (rtl ? 1 : -1)) % count;
  }
  if (key == LogicalKeyboardKey.home) next = 0;
  if (key == LogicalKeyboardKey.end) next = count - 1;
  if (next == null) return KeyEventResult.ignored;
  onChanged(next);
  return KeyEventResult.handled;
}
