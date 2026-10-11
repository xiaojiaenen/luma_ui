# luma_ui 0.0.1 上游问题核对

核对包 SHA-256：574b2184ae9448cc0e0996e52b64cc98a367c08aa32f59ec57233e980b37cbe4。
实际首次发布为 2026-10-11（非 2026-10-10）。下面修复已在 0.0.2 发布（2026-10-11）。

| 编号 | 核对结果 | 修复与验证 |
| --- | --- | --- |
| L1 | 强调色/几何双源成立；“无 SoftDesign 必抛异常”不成立，0.0.1 已有 fallback，但只继承亮度，没有继承强调色。 | SoftTokens.theme 写入 SoftThemeData；Material 和 Luma 共享配置；默认局部包裹器继承主题。 |
| L2 | 浅色输入框 enabledBorder 使用白色，实测边界对比度约 1.03:1；记录中的 40% 透明度属于 disabledBorder，不是 enabledBorder。 | 新增 controlBorder，可见输入边界与卡片装饰高光分开；基础浅色边界通过 >=3:1 测试。 |
| L3 | Quick start 双重装配会放大 L1；SoftTokens 在 components.dart，公开导出可用但查找说明不足。 | README 改成单入口；明确公开 import 与主题工厂实现位置。 |
| L4 | Composer、通知操作、业务卡等存在固定文案；Navigation 的 items/actionLabel/actionIcon 以及 EmptyState.actionLabel 原本已能覆盖，不能一概归为不可配置。 | SoftStrings 文案覆盖、模板参数；Composer 局部参数；SoftIcons 全局 Widget 渲染器，可返回 SVG；全部 Luma-owned Icon 经 SoftIcon 路径。 |

## 新增回归测试

`test/upstream_regressions_test.dart` 验证：无祖先的主题继承、默认包裹器不重置强调色、输入边界对比度、几何与组件样式继承、中文 Composer 的提交行为、自定义图标与通知操作、动态搜索/下载文案插值、导航提示和 AI 思考状态的无障碍文案翻译。主题复制也验证不会把未指定的参数变成默认值覆盖。

## 边界

SoftStrings 按键覆盖默认文案，不替代 Flutter 的 MaterialLocalizations。业务数据仍由应用传入；自绘图表的视觉与语义描述应在实际应用里进一步验证。SoftIcons 处理 Luma-owned 图标，不替换框架控件内部的渲染。

0.0.2 已发布到 pub.dev。原 0.0.1 包不会被覆盖；请更新依赖到 `^0.0.2` 并执行 `flutter pub upgrade luma_ui`。
