# Localization and icon rendering (0.0.2 candidate)

Pass `strings: SoftStrings(messages)` to **both** light and dark
`SoftTokens.theme()` factories. Derive this map from your application's current
Locale; rebuilding the theme updates descendants and dialogs. This configuration
is shared through Flutter ThemeExtension and does not require a SoftDesign wrapper.
Missing keys preserve the original UI copy. Retain `{query}`, `{percent}` and other
placeholders in translations. Labels matching a dictionary key are resolved;
use explicit composer parameters when a particular instance needs different copy.

```dart
final messages = SoftStrings({
  'Write a message…': '写点什么…',
  'Send message': '发送',
  'Mark as read': '标为已读',
  'Storage': '存储空间',
  'No matches for {query}': '没有找到“{query}”',
  '{percent}% downloaded': '已下载 {percent}%',
});
final theme = SoftTokens.theme(strings: messages);
```

MaterialApp's supportedLocales/localizationsDelegates remain the application's
responsibility. Luma retains the previous mixed English/Chinese defaults for
compatibility; override the keys below to fully localize library UI.

## Custom icons

```dart
final icons = SoftIcons(builder: (context, icon, size, color) {
  // Return your own SVG/custom Widget here. IDs remain Material IconData keys.
  return SizedBox(width: size, height: size, child: YourBrandIcon(icon: icon, color: color));
});
final theme = SoftTokens.theme(icons: icons);
```

`YourBrandIcon` is an application-owned widget, not supplied by Luma UI.
The renderer controls Luma-owned icons, not Flutter's internal control rendering.
SoftComposer also accepts a per-instance `sendIcon` Widget. SoftNavigation's
`items`, `actionLabel` and `actionIcon` remain available for per-instance choices.

## Default copy keys

Week-strip keys distinguish weekdays even when their default initials match.
Calendar weekday keys `一` through `日` retain their original Chinese defaults.

- `24 小时制`
- `A little space for your files`
- `AI model`
- `AI 生成内容 · 请核对`
- `Active`
- `Add to cart`
- `All`
- `Allow`
- `Apply coupon`
- `Arrival`
- `BOARDING PASS`
- `Bookmark`
- `Call`
- `Calories`
- `Cancel`
- `Cancel download`
- `Change filters or add a record.`
- `Changes will sync when you reconnect.`
- `Chat`
- `Choose a file`
- `Choose a file to get started`
- `Choose another`
- `Choose file`
- `Choose plan`
- `Clear search`
- `Color {value}`
- `Connection`
- `Context usage`
- `Copy code`
- `Copy response`
- `Create`
- `Date`
- `Decrease`
- `Departure`
- `Dismiss`
- `Dismiss notification`
- `Distance`
- `Edit address`
- `Email updates`
- `Enrolled`
- `Forecast`
- `Gate`
- `Get in touch`
- `Heart rate · demo data`
- `Home`
- `Humidity`
- `Increase`
- `Jan`
- `Join meeting`
- `Jul`
- `Loading`
- `Loading table`
- `Loading…`
- `Local demo`
- `Mar`
- `Mark as read`
- `May`
- `Message`
- `Next month`
- `Next page`
- `Next track`
- `No chart data`
- `No matches for {query}`
- `No results`
- `No rows`
- `Not now`
- `Open menu`
- `Overview · demo data`
- `Pause`
- `Play`
- `Play video`
- `Previous month`
- `Previous page`
- `Push notifications`
- `Rate {value}`
- `Reconnect`
- `Regenerate response`
- `Remove bookmark`
- `Remove file`
- `Reply`
- `Retry`
- `Search components`
- `Send message`
- `Set up now`
- `Something needs attention`
- `Stand hours`
- `Status`
- `Stop generation`
- `Storage`
- `Studio assistant`
- `Tasks`
- `Team`
- `Thinking`
- `Total`
- `Unable to load table`
- `Verification code`
- `Write a message…`
- `You are offline`
- `Your file is on its way`
- `weekstrip.fri`
- `weekstrip.mon`
- `weekstrip.sat`
- `weekstrip.sun`
- `weekstrip.thu`
- `weekstrip.tue`
- `weekstrip.wed`
- `{percent}% downloaded`
- `{used} / {limit} tokens`
- `{value} BPM`
- `一`
- `三`
- `二`
- `五`
- `六`
- `减少{label}`
- `分钟`
- `取消`
- `四`
- `增加{label}`
- `小时`
- `日`
- `正在理解你的想法`
- `正在生成…`
- `生成失败，请重试`
- `确定`
- `选择日期`
- `选择时间`
