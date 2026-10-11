## 0.0.2 — 2026-10-11

* Share Material and Luma configuration through SoftThemeData. Theme-only use now inherits accent, geometry, component styles and brightness; SoftDesign is optional for local overrides.
* Fix nearly invisible light-mode input borders with a separate controlBorder token (tested at >= 3:1 against the default fill), preserving decorative surface highlights.
* Add SoftStrings copy overrides, including parameterized download/search messages, navigation tooltips and AI thinking accessibility labels.
* Route Luma-owned icons through SoftIcons custom-widget rendering (including SVG support); preserve the existing SoftIcon API entry point.
* Add SoftComposer hintText, sendTooltip and sendIcon overrides.
* Document single-source setup, localization, icon rendering and the verified 0.0.1 bug report.

### 修复说明

* **L1 · 主题配置漂移**：`SoftTokens.theme()` 成为统一入口，强调色、亮暗模式、圆角、间距和组件样式由 Material 与 Luma 共享。默认 `SoftDesign` 包裹器及其 `copyWith` 不再覆盖继承值；无需为全局使用额外挂包裹器。0.0.1 原本已有无祖先回退，本次修复的是主题继承不完整。
* **L2 · 浅色输入边界不可见**：控件边框使用独立 `controlBorder`，默认浅色边界通过 ≥3:1 对比度测试，卡片高光保持原样。
* **L3 · 接入示例不清晰**：README 改为主题单入口，补充主题工厂位置及局部覆盖说明。
* **L4 · 默认英文与固定图标难以替换**：新增 `SoftStrings` 统一覆盖文案及动态占位符，覆盖导航提示、AI 思考状态无障碍标签；`SoftComposer` 新增 `hintText`、`sendTooltip`、`sendIcon`。新增 `SoftIcons` Widget 渲染器，可接入自定义 SVG 图标。
* **使用边界**：未覆盖的文案保留原默认值；应用仍需自行配置 Flutter 的 MaterialLocalizations。图标替换覆盖库自身图标，不接管框架控件内部图标。
* **验证**：新增 8 项回归测试；根包 36 项、示例 22 项测试，静态分析及 Web 构建通过。

## 0.0.1

* Initial Luma UI release with 125 public widgets and design primitives.
* Adaptive light/dark themes, shared geometry, semantic colors and role palettes.
* Multi-color card gradients, interaction feedback and reduced-motion support.
* Calendar, custom date/time dialogs, charts, code highlighting and AI components.
* Bundled HarmonyOS Sans SC and JetBrains Mono with separate font licenses.
* Responsive component catalog, configuration studio and example application.
