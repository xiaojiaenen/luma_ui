import 'package:flutter/material.dart';

/// Override default UI copy without translating application-owned content.
/// Keys are the documented English defaults; missing keys retain that default.
@immutable
class SoftStrings extends ThemeExtension<SoftStrings> {
  const SoftStrings(this.messages);
  final Map<String, String> messages;
  static const defaults = <String, String>{
    'weekstrip.mon': 'M',
    'weekstrip.tue': 'T',
    'weekstrip.wed': 'W',
    'weekstrip.thu': 'T',
    'weekstrip.fri': 'F',
    'weekstrip.sat': 'S',
    'weekstrip.sun': 'S',
  };
  static SoftStrings of(BuildContext context) =>
      Theme.of(context).extension<SoftStrings>() ?? const SoftStrings({});
  String resolve(String key, [Map<String, Object> arguments = const {}]) {
    var value = messages[key] ?? defaults[key] ?? key;
    for (final entry in arguments.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value.toString());
    }
    return value;
  }

  @override
  SoftStrings copyWith({Map<String, String>? messages}) =>
      SoftStrings(messages ?? this.messages);
  @override
  SoftStrings lerp(covariant SoftStrings? other, double t) =>
      t < .5 ? this : other ?? this;
}

String softText(
  BuildContext context,
  String key, [
  Map<String, Object> arguments = const {},
]) => SoftStrings.of(context).resolve(key, arguments);
