# Luma UI · 澄屿

A Flutter UI library with soft surfaces, consistent geometry, adaptive light/dark
themes, and expressive color palettes.

柔和有形，鲜活有序。包含 125 个公开 Widget（含布局、容器与动效原语），覆盖表单、导航、反馈、日历、图表、AI 和业务组合。

## Install

Once version 0.0.1 is published on pub.dev:

```yaml
dependencies:
  luma_ui: ^0.0.1
```

Before publication, use a local path:

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
    builder: (context, child) => SoftDesign(
      accent: accent,
      child: child!,
    ),
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
