# Luma UI · 澄屿

A Flutter UI library with soft surfaces, consistent geometry, adaptive light/dark
themes, and expressive color palettes.

柔和有形，鲜活有序。包含 125 个公开 Widget（含布局、容器与动效原语），覆盖表单、导航、反馈、日历、图表、AI 和业务组合。

## Install

Version **0.0.2** fixes theme inheritance and input borders, and adds configurable
copy and custom icon rendering. See [CHANGELOG](CHANGELOG.md) for details.

Available on [pub.dev](https://pub.dev/packages/luma_ui):

```yaml
dependencies:
  luma_ui: ^0.0.2
```

For local development, use a path dependency:

```yaml
dependencies:
  luma_ui:
    path: /absolute/path/to/flutter_ui
```

Run `flutter pub get`. Currently tested with Flutter 3.47.6 / Dart 3.13.5;
the package conservatively requires these versions or later compatible versions.

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

void main() {
  const accent = Color(0xFF66D8EF);
  runApp(MaterialApp(
    theme: SoftTokens.theme(accentColor: accent),
    darkTheme: SoftTokens.theme(
      accentColor: accent,
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.system,
    home: const ExamplePage(),
  ));
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SoftSurface(
        gradientPreset: SoftGradientPreset.peach,
        child: SoftButton(
          label: 'Hello Luma',
          primary: true,
          onPressed: () => showSoftToast(context, 'Saved'),
        ),
      ),
    ),
  );
}
```

`SoftTokens.theme()` is the single configuration entry point. It stores the
resolved design in `SoftThemeData`, a Flutter theme extension. All Luma widgets
read it without requiring a `SoftDesign` ancestor. `SoftDesign` remains available
for explicit local overrides; omitted values inherit the current theme.
`SoftTokens` is exported by `luma_ui.dart` (implementation: `src/components.dart`);
consumers should import the public entry point only.

```dart
final theme = SoftTokens.theme(
  accentColor: const Color(0xFF487968),
  radius: 18,
  strings: const SoftStrings({
    'Write a message…': '写点什么…',
    'Send message': '发送',
    'Mark as read': '标为已读',
    '{percent}% downloaded': '已下载 {percent}%',
  }),
);
```

`SoftComposer` also accepts `hintText`, `sendTooltip`, and a `sendIcon` Widget.
For custom SVG or brand icons, supply `icons: SoftIcons(builder: ...)` to the theme.
The builder receives the original `IconData` identifier, resolved size and color,
and can return any Widget. This replaces Luma-owned icons; Flutter controls keep
framework rendering. See [localization and icons](doc/localization.md) for keys,
parameter templates and locale switching.

## Design and fonts

* Shared default rectangular radius: `52 / φ² ≈ 19.86`; configurable with
  `SoftDesign.radius`. Avatars and circular indicators remain circular.
* `SoftRoleColors` separates brand, secondary, tertiary, AI and chart colors.
* `SoftSurface` supports custom `gradient`, named `gradientPreset`, `onTap`,
  `selected`, and keyboard focus. Custom gradients override presets.
* Navigation supports capsule, continuous and uniform corner shapes.
* Short transitions respect the system's reduced-motion preference.
* Custom date/time dialogs inherit the active design and only commit on confirm.

HarmonyOS Sans SC (400/500/700) and JetBrains Mono are bundled in this package.
**No copying or pubspec font registration is needed in a consuming application.**
`SoftTokens.theme()` uses `SoftTokens.fontFamily` by default; code and time digits
use `SoftTokens.monoFontFamily`. Pass `fontFamily: 'YourFont'` to override, or
`fontFamily: null` to use Flutter's default typography.

Regular cards use a pearl-like surface with a highlight border. `SoftGlassSurface`
is an optional backdrop-blur component. Surface fusion is not included.

## Documentation and example

* [组件目录 / Component inventory](组件目录.md)
* [组件库指南 / Integration and configuration](组件库指南.md)
* [组件状态规范 / State coverage and limits](组件状态规范.md)

```bash
cd example
flutter pub get
flutter run -d chrome
```

The example includes search, categories, Dart usage snippets, theme controls, and a
configuration studio. Upload, AI, media, and business data are demonstrations;
connect application services through callbacks. Layout tests do not replace
screen-reader and device testing in your own application.

## License

Source code: [MIT](LICENSE), copyright © 2026 xiaojia.
Bundled fonts retain separate licenses: [third-party notices](THIRD_PARTY_NOTICES.md).
