import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

typedef DemoBuilder = Widget Function(BuildContext, DemoData);

class ComponentSpec {
  const ComponentSpec(this.name, this.category, this.example, this.builder);
  final String name, category, example;
  final DemoBuilder builder;
}

void demoAction(BuildContext context, String message) =>
    showSoftToast(context, message);

class DemoData extends ChangeNotifier {
  bool flag = true;
  int index = 0, number = 2;
  double progress = .6;
  Color color = const Color(0xFFA8CDB8);
  String text = '', choice = 'design';
  DateTime date = DateTime(2026, 10, 10), month = DateTime(2026, 10);
  DateTimeRange? dateRange;
  TimeOfDay time = const TimeOfDay(hour: 9, minute: 30);
  RangeValues range = const RangeValues(20, 80);
  Set<int> choices = {0};
  void setFlag(bool v) {
    flag = v;
    notifyListeners();
  }

  void setIndex(int v) {
    index = v;
    notifyListeners();
  }

  void setNumber(int v) {
    number = v;
    notifyListeners();
  }

  void setProgress(double v) {
    progress = v;
    notifyListeners();
  }

  void setDate(DateTime v) {
    date = v;
    notifyListeners();
  }

  void setMonth(DateTime v) {
    month = v;
    notifyListeners();
  }

  void setTime(TimeOfDay v) {
    time = v;
    notifyListeners();
  }

  void setDateRange(DateTimeRange v) {
    dateRange = v;
    notifyListeners();
  }

  void setRange(RangeValues v) {
    range = v;
    notifyListeners();
  }

  void setChoices(Set<int> v) {
    choices = v;
    notifyListeners();
  }

  void setColor(Color v) {
    color = v;
    notifyListeners();
  }

  void setText(String v) {
    text = v;
    notifyListeners();
  }

  void setChoice(String v) {
    choice = v;
    notifyListeners();
  }
}

final componentSpecs = <ComponentSpec>[
  ComponentSpec(
    'SoftAIBubble',
    'AI',
    'SoftAIBubble(text: \'统一轮廓，把视觉重点留给内容。\', onCopy: () => demoAction(context, \'Copied\'))',
    (context, d) => SoftAIBubble(
      text: '统一轮廓，把视觉重点留给内容。',
      onCopy: () => demoAction(context, 'Copied'),
    ),
  ),
  ComponentSpec(
    'SoftPromptCard',
    'AI',
    'SoftPromptCard(title: \'细化设计\', description: \'探索新的组件组合\', onTap: () => demoAction(context, \'Prompt selected\'))',
    (context, d) => SoftPromptCard(
      title: '细化设计',
      description: '探索新的组件组合',
      onTap: () => demoAction(context, 'Prompt selected'),
    ),
  ),
  ComponentSpec(
    'SoftThinkingIndicator',
    'AI',
    'const SoftThinkingIndicator()',
    (context, d) => const SoftThinkingIndicator(),
  ),
  ComponentSpec(
    'SoftAILoadingCard',
    '业务与扩展',
    'const SoftAILoadingCard()',
    (context, d) => const SoftAILoadingCard(),
  ),
  ComponentSpec(
    'SoftAIModelSelect',
    '业务与扩展',
    'SoftAIModelSelect(models: const {\'design\': \'Studio model\', \'fast\': \'Fast model\'}, value: d.choice, onChanged: d.setChoice)',
    (context, d) => SoftAIModelSelect(
      models: const {'design': 'Studio model', 'fast': 'Fast model'},
      value: d.choice,
      onChanged: d.setChoice,
    ),
  ),
  ComponentSpec(
    'SoftAISourceCard',
    '业务与扩展',
    'SoftAISourceCard(title: \'Design notes\', source: \'Example reference document\', onOpen: () => demoAction(context, \'Open source callback\'))',
    (context, d) => SoftAISourceCard(
      title: 'Design notes',
      source: 'Example reference document',
      onOpen: () => demoAction(context, 'Open source callback'),
    ),
  ),
  ComponentSpec(
    'SoftAIToolCall',
    '业务与扩展',
    'SoftAIToolCall(tool: \'Search documents\', detail: \'Tool execution status\', running: !d.flag)',
    (context, d) => SoftAIToolCall(
      tool: 'Search documents',
      detail: 'Tool execution status',
      running: !d.flag,
    ),
  ),
  ComponentSpec(
    'SoftActivityFeed',
    '业务与扩展',
    'SoftActivityFeed(events: {\'09:00\': \'Created a component\', \'10:30\': \'Updated the theme\'})',
    (context, d) => const SoftActivityFeed(
      events: {'09:00': 'Created a component', '10:30': 'Updated the theme'},
    ),
  ),
  ComponentSpec(
    'SoftAddressCard',
    '业务与扩展',
    'SoftAddressCard(name: \'Studio address\', address: \'Example delivery address\', onEdit: () => demoAction(context, \'Edit address\'))',
    (context, d) => SoftAddressCard(
      name: 'Studio address',
      address: 'Example delivery address',
      onEdit: () => demoAction(context, 'Edit address'),
    ),
  ),
  ComponentSpec(
    'SoftAudioPlayer',
    '业务与扩展',
    'SoftAudioPlayer(title: \'Nothing Was The Same\', artist: \'Demo track · connect audio service\', playing: d.flag, onToggle: () => d.setFlag(!d.flag), progress: .4, onNext: () => demoAction(context, \'Next track\'))',
    (context, d) => SoftAudioPlayer(
      title: 'Nothing Was The Same',
      artist: 'Demo track · connect audio service',
      playing: d.flag,
      onToggle: () => d.setFlag(!d.flag),
      progress: .4,
      onNext: () => demoAction(context, 'Next track'),
    ),
  ),
  ComponentSpec(
    'SoftAvatarGroup',
    '业务与扩展',
    'SoftAvatarGroup(names: [\'Chloe\', \'Alex\', \'Jamie\', \'Sam\', \'You\'])',
    (context, d) =>
        const SoftAvatarGroup(names: ['Chloe', 'Alex', 'Jamie', 'Sam', 'You']),
  ),
  ComponentSpec(
    'SoftChecklist',
    '业务与扩展',
    'SoftChecklist(items: const [\'Check geometry\', \'Check contrast\', \'Check overflow\'], checked: d.choices, onChanged: d.setChoices)',
    (context, d) => SoftChecklist(
      items: const ['Check geometry', 'Check contrast', 'Check overflow'],
      checked: d.choices,
      onChanged: d.setChoices,
    ),
  ),
  ComponentSpec(
    'SoftChipGroup',
    '业务与扩展',
    'SoftChipGroup(labels: const [\'Design\', \'Code\', \'Motion\'], selected: d.choices, onChanged: d.setChoices)',
    (context, d) => SoftChipGroup(
      labels: const ['Design', 'Code', 'Motion'],
      selected: d.choices,
      onChanged: d.setChoices,
    ),
  ),
  ComponentSpec(
    'SoftColorPicker',
    '业务与扩展',
    'SoftColorPicker(value: d.color, onChanged: d.setColor, colors: const [Color(0xFFA8CDB8), Color(0xFFC7B8E7), Color(0xFFEFC3A4)])',
    (context, d) => SoftColorPicker(
      value: d.color,
      onChanged: d.setColor,
      colors: const [Color(0xFFA8CDB8), Color(0xFFC7B8E7), Color(0xFFEFC3A4)],
    ),
  ),
  ComponentSpec(
    'SoftCommandItem',
    '业务与扩展',
    'SoftCommandItem(label: \'Search components\', shortcut: \'⌘ K\', onTap: () => demoAction(context, \'Command selected\'))',
    (context, d) => SoftCommandItem(
      label: 'Search components',
      shortcut: '⌘ K',
      onTap: () => demoAction(context, 'Command selected'),
    ),
  ),
  ComponentSpec(
    'SoftCommentCard',
    '业务与扩展',
    'SoftCommentCard(author: \'Chloe\', text: \'The shared corner radius feels much calmer.\', time: \'Demo comment\', onReply: () => demoAction(context, \'Reply\'))',
    (context, d) => SoftCommentCard(
      author: 'Chloe',
      text: 'The shared corner radius feels much calmer.',
      time: 'Demo comment',
      onReply: () => demoAction(context, 'Reply'),
    ),
  ),
  ComponentSpec(
    'SoftConnectionCard',
    '业务与扩展',
    'SoftConnectionCard(name: \'Studio headphones\', connected: d.flag, onChanged: d.setFlag)',
    (context, d) => SoftConnectionCard(
      name: 'Studio headphones',
      connected: d.flag,
      onChanged: d.setFlag,
    ),
  ),
  ComponentSpec(
    'SoftContactCard',
    '业务与扩展',
    'SoftContactCard(name: \'Jennifer Harrison\', role: \'Product designer\', onMessage: () => demoAction(context, \'Message\'), onCall: () => demoAction(context, \'Call\'))',
    (context, d) => SoftContactCard(
      name: 'Jennifer Harrison',
      role: 'Product designer',
      onMessage: () => demoAction(context, 'Message'),
      onCall: () => demoAction(context, 'Call'),
    ),
  ),
  ComponentSpec(
    'SoftCouponCard',
    '业务与扩展',
    'SoftCouponCard(code: \'STUDIO\', description: \'Example coupon · no real discount\', onApply: () => demoAction(context, \'Coupon action\'))',
    (context, d) => SoftCouponCard(
      code: 'STUDIO',
      description: 'Example coupon · no real discount',
      onApply: () => demoAction(context, 'Coupon action'),
    ),
  ),
  ComponentSpec(
    'SoftDivider',
    '业务与扩展',
    'const SoftDivider(label: \'OR\')',
    (context, d) => const SoftDivider(label: 'OR'),
  ),
  ComponentSpec(
    'SoftDownloadCard',
    '业务与扩展',
    'SoftDownloadCard(name: \'Design assets.zip\', progress: .72, onCancel: () => demoAction(context, \'Cancel action\'))',
    (context, d) => SoftDownloadCard(
      name: 'Design assets.zip',
      progress: .72,
      onCancel: () => demoAction(context, 'Cancel action'),
    ),
  ),
  ComponentSpec(
    'SoftEmptySearch',
    '业务与扩展',
    'SoftEmptySearch(query: d.text, onClear: () => d.setText(\'\'))',
    (context, d) =>
        SoftEmptySearch(query: d.text, onClear: () => d.setText('')),
  ),
  ComponentSpec(
    'SoftErrorState',
    '业务与扩展',
    'SoftErrorState(message: \'The request could not be completed.\', onRetry: () => demoAction(context, \'Retry\'))',
    (context, d) => SoftErrorState(
      message: 'The request could not be completed.',
      onRetry: () => demoAction(context, 'Retry'),
    ),
  ),
  ComponentSpec(
    'SoftFileTile',
    '业务与扩展',
    'SoftFileTile(name: \'Design system.fig\', details: \'24 MB · Figma\', onRemove: () => demoAction(context, \'Remove action\'))',
    (context, d) => SoftFileTile(
      name: 'Design system.fig',
      details: '24 MB · Figma',
      onRemove: () => demoAction(context, 'Remove action'),
    ),
  ),
  ComponentSpec(
    'SoftFilterBar',
    '业务与扩展',
    'SoftFilterBar(labels: const [\'All\', \'Active\', \'Saved\'], selected: d.index, onChanged: d.setIndex)',
    (context, d) => SoftFilterBar(
      labels: const ['All', 'Active', 'Saved'],
      selected: d.index,
      onChanged: d.setIndex,
    ),
  ),
  ComponentSpec(
    'SoftFlightTicket',
    '业务与扩展',
    'const SoftFlightTicket(from: \'SFO\', to: \'JFK\', departure: \'9:25 PM\', arrival: \'2:15 AM\', gate: \'B16\')',
    (context, d) => const SoftFlightTicket(
      from: 'SFO',
      to: 'JFK',
      departure: '9:25 PM',
      arrival: '2:15 AM',
      gate: 'B16',
    ),
  ),
  ComponentSpec(
    'SoftHealthCard',
    '业务与扩展',
    'const SoftHealthCard(heartRate: \'98\', distance: \'8.13 km\', calories: \'768 kcal\', hours: \'5 hr\')',
    (context, d) => const SoftHealthCard(
      heartRate: '98',
      distance: '8.13 km',
      calories: '768 kcal',
      hours: '5 hr',
    ),
  ),
  ComponentSpec(
    'SoftIcon',
    '业务与扩展',
    'const SoftIcon(Icons.cloud_outlined, size: 40)',
    (context, d) => const SoftIcon(Icons.cloud_outlined, size: 40),
  ),
  ComponentSpec(
    'SoftIconGrid',
    '业务与扩展',
    'SoftIconGrid(icons: const {\'Home\': Icons.home_outlined, \'Calendar\': Icons.calendar_today_outlined, \'Cloud\': Icons.cloud_outlined, \'Chat\': Icons.chat_bubble_outline_rounded, \'Settings\': Icons.settings_outlined, \'Favorite\': Icons.favorite_border_rounded, \'AI\': Icons.auto_awesome_outlined, \'Music\': Icons.music_note_outlined}, onSelected: (v) => demoAction(context, v))',
    (context, d) => SoftIconGrid(
      icons: const {
        'Home': Icons.home_outlined,
        'Calendar': Icons.calendar_today_outlined,
        'Cloud': Icons.cloud_outlined,
        'Chat': Icons.chat_bubble_outline_rounded,
        'Settings': Icons.settings_outlined,
        'Favorite': Icons.favorite_border_rounded,
        'AI': Icons.auto_awesome_outlined,
        'Music': Icons.music_note_outlined,
      },
      onSelected: (v) => demoAction(context, v),
    ),
  ),
  ComponentSpec(
    'SoftImageTile',
    '业务与扩展',
    'const SoftImageTile(caption: \'ImageProvider placeholder\')',
    (context, d) => const SoftImageTile(caption: 'ImageProvider placeholder'),
  ),
  ComponentSpec(
    'SoftKanbanColumn',
    '业务与扩展',
    'SoftKanbanColumn(title: \'In progress\', tasks: [SoftTag(\'Calendar\'), SoftTag(\'Gradient cards\')])',
    (context, d) => SoftKanbanColumn(
      title: 'In progress',
      tasks: const [SoftTag('Calendar'), SoftTag('Gradient cards')],
    ),
  ),
  ComponentSpec(
    'SoftKbd',
    '业务与扩展',
    'const SoftKbd(\'⌘ K\')',
    (context, d) => const SoftKbd('⌘ K'),
  ),
  ComponentSpec(
    'SoftMetricCard',
    '业务与扩展',
    'const SoftMetricCard(label: \'Members · demo\', value: \'1,930\', change: \'Example trend\', trend: [2, 4, 3, 6, 8])',
    (context, d) => const SoftMetricCard(
      label: 'Members · demo',
      value: '1,930',
      change: 'Example trend',
      trend: [2, 4, 3, 6, 8],
    ),
  ),
  ComponentSpec(
    'SoftNotificationCard',
    '业务与扩展',
    'SoftNotificationCard(title: \'New comment\', message: \'Chloe left feedback on your design.\', time: \'Demo · just now\', onRead: () => demoAction(context, \'Marked as read\'))',
    (context, d) => SoftNotificationCard(
      title: 'New comment',
      message: 'Chloe left feedback on your design.',
      time: 'Demo · just now',
      onRead: () => demoAction(context, 'Marked as read'),
    ),
  ),
  ComponentSpec(
    'SoftNotificationPreference',
    '业务与扩展',
    'SoftNotificationPreference(email: d.flag, push: !d.flag, onEmailChanged: d.setFlag, onPushChanged: (v) => d.setFlag(!v))',
    (context, d) => SoftNotificationPreference(
      email: d.flag,
      push: !d.flag,
      onEmailChanged: d.setFlag,
      onPushChanged: (v) => d.setFlag(!v),
    ),
  ),
  ComponentSpec(
    'SoftNumberField',
    '业务与扩展',
    'SoftNumberField(value: d.number, onChanged: d.setNumber)',
    (context, d) => SoftNumberField(value: d.number, onChanged: d.setNumber),
  ),
  ComponentSpec(
    'SoftOfflineBanner',
    '业务与扩展',
    'SoftOfflineBanner(onReconnect: () => demoAction(context, \'Reconnect\'))',
    (context, d) =>
        SoftOfflineBanner(onReconnect: () => demoAction(context, 'Reconnect')),
  ),
  ComponentSpec(
    'SoftOrderCard',
    '业务与扩展',
    'const SoftOrderCard(number: \'Order #2048\', status: \'In transit · demo\', total: \'€165.95\')',
    (context, d) => const SoftOrderCard(
      number: 'Order #2048',
      status: 'In transit · demo',
      total: '€165.95',
    ),
  ),
  ComponentSpec(
    'SoftOtpField',
    '业务与扩展',
    'SoftOtpField(onCompleted: (v) => demoAction(context, \'Code: \$v\'))',
    (context, d) =>
        SoftOtpField(onCompleted: (v) => demoAction(context, 'Code: $v')),
  ),
  ComponentSpec(
    'SoftPasswordStrength',
    '业务与扩展',
    'SoftPasswordStrength(password: d.text)',
    (context, d) => SoftPasswordStrength(password: d.text),
  ),
  ComponentSpec(
    'SoftPermissionCard',
    '业务与扩展',
    'SoftPermissionCard(title: \'Keep your files close\', description: \'Permission UI example; does not request access.\', onAllow: () => demoAction(context, \'Allow callback\'), onDecline: () => demoAction(context, \'Decline callback\'))',
    (context, d) => SoftPermissionCard(
      title: 'Keep your files close',
      description: 'Permission UI example; does not request access.',
      onAllow: () => demoAction(context, 'Allow callback'),
      onDecline: () => demoAction(context, 'Decline callback'),
    ),
  ),
  ComponentSpec(
    'SoftPriceCard',
    '业务与扩展',
    'SoftPriceCard(plan: \'Studio\', price: \'Pricing example\', features: const [\'Shared components\', \'Custom themes\', \'Motion tokens\'], onChoose: () => demoAction(context, \'Plan selected\'))',
    (context, d) => SoftPriceCard(
      plan: 'Studio',
      price: 'Pricing example',
      features: const ['Shared components', 'Custom themes', 'Motion tokens'],
      onChoose: () => demoAction(context, 'Plan selected'),
    ),
  ),
  ComponentSpec(
    'SoftProductCard',
    '业务与扩展',
    'SoftProductCard(title: \'Crush Contrast\', price: \'€165.95 · demo\', onAdd: () => demoAction(context, \'Added to demo cart\'))',
    (context, d) => SoftProductCard(
      title: 'Crush Contrast',
      price: '€165.95 · demo',
      onAdd: () => demoAction(context, 'Added to demo cart'),
    ),
  ),
  ComponentSpec(
    'SoftQuote',
    '业务与扩展',
    'const SoftQuote(text: \'Less, but better.\', author: \'Demo quote card\')',
    (context, d) =>
        const SoftQuote(text: 'Less, but better.', author: 'Demo quote card'),
  ),
  ComponentSpec(
    'SoftRangeSlider',
    '业务与扩展',
    'SoftRangeSlider(value: d.range, onChanged: d.setRange)',
    (context, d) => SoftRangeSlider(value: d.range, onChanged: d.setRange),
  ),
  ComponentSpec(
    'SoftRating',
    '业务与扩展',
    'SoftRating(value: d.number, onChanged: d.setNumber)',
    (context, d) => SoftRating(value: d.number, onChanged: d.setNumber),
  ),
  ComponentSpec(
    'SoftReviewCard',
    '业务与扩展',
    'const SoftReviewCard(author: \'Demo review\', text: \'Clear hierarchy and careful details.\', rating: 4)',
    (context, d) => const SoftReviewCard(
      author: 'Demo review',
      text: 'Clear hierarchy and careful details.',
      rating: 4,
    ),
  ),
  ComponentSpec(
    'SoftSearchField',
    '业务与扩展',
    'SoftSearchField(onChanged: d.setText)',
    (context, d) => SoftSearchField(onChanged: d.setText),
  ),
  ComponentSpec(
    'SoftSegmentedProgress',
    '业务与扩展',
    'const SoftSegmentedProgress(steps: 5, current: 3)',
    (context, d) => const SoftSegmentedProgress(steps: 5, current: 3),
  ),
  ComponentSpec(
    'SoftStatusDot',
    '业务与扩展',
    'SoftStatusDot(label: d.flag ? \'Connected\' : \'Disconnected\', active: d.flag)',
    (context, d) => SoftStatusDot(
      label: d.flag ? 'Connected' : 'Disconnected',
      active: d.flag,
    ),
  ),
  ComponentSpec(
    'SoftStorageCard',
    '业务与扩展',
    'const SoftStorageCard(used: \'6.4 GB\', capacity: \'10 GB\', fraction: .64)',
    (context, d) =>
        const SoftStorageCard(used: '6.4 GB', capacity: '10 GB', fraction: .64),
  ),
  ComponentSpec(
    'SoftTaskCard',
    '业务与扩展',
    'SoftTaskCard(title: \'Review motion details\', due: \'Today · demo\', done: d.flag, onChanged: d.setFlag)',
    (context, d) => SoftTaskCard(
      title: 'Review motion details',
      due: 'Today · demo',
      done: d.flag,
      onChanged: d.setFlag,
    ),
  ),
  ComponentSpec(
    'SoftTokenUsage',
    '业务与扩展',
    'const SoftTokenUsage(used: 2400, limit: 8000)',
    (context, d) => const SoftTokenUsage(used: 2400, limit: 8000),
  ),
  ComponentSpec(
    'SoftUploadZone',
    '业务与扩展',
    'SoftUploadZone(onSelect: () => demoAction(context, \'Connect file picker\'))',
    (context, d) => SoftUploadZone(
      onSelect: () => demoAction(context, 'Connect file picker'),
    ),
  ),
  ComponentSpec(
    'SoftVideoTile',
    '业务与扩展',
    'SoftVideoTile(title: \'Studio walkthrough\', duration: \'02:34 · demo\', onPlay: () => demoAction(context, \'Connect video player\'))',
    (context, d) => SoftVideoTile(
      title: 'Studio walkthrough',
      duration: '02:34 · demo',
      onPlay: () => demoAction(context, 'Connect video player'),
    ),
  ),
  ComponentSpec(
    'SoftWeatherCard',
    '业务与扩展',
    'const SoftWeatherCard(city: \'Calicut, Kerala\', temperature: \'28°\', condition: \'Pretty sunny · demo\', humidity: \'72%\')',
    (context, d) => const SoftWeatherCard(
      city: 'Calicut, Kerala',
      temperature: '28°',
      condition: 'Pretty sunny · demo',
      humidity: '72%',
    ),
  ),
  ComponentSpec(
    'SoftCodeBlock',
    '代码',
    'const SoftCodeBlock(code: "// Shared geometry\\nconst radius = 52 / (1.618 * 1.618);\\nSoftButton(label: \'Hello\', onPressed: () {});")',
    (context, d) => const SoftCodeBlock(
      code: "// Shared geometry\nconst radius = 52 / (1.618 * 1.618);\nSoftButton(label: 'Hello', onPressed: () {});",
    ),
  ),
  ComponentSpec(
    'SoftPress',
    '动效',
    'SoftPress(child: SoftButton(label: \'Press gently\', onPressed: () => demoAction(context, \'Pressed\')))',
    (context, d) => SoftPress(
      child: SoftButton(
        label: 'Press gently',
        onPressed: () => demoAction(context, 'Pressed'),
      ),
    ),
  ),
  ComponentSpec(
    'SoftReveal',
    '动效',
    'SoftReveal(identity: d.flag, child: SoftButton(label: \'Replay entrance\', onPressed: () => d.setFlag(!d.flag)))',
    (context, d) => SoftReveal(
      identity: d.flag,
      child: SoftButton(
        label: 'Replay entrance',
        onPressed: () => d.setFlag(!d.flag),
      ),
    ),
  ),
  ComponentSpec(
    'SoftToast',
    '反馈',
    'SoftToast(message: \'设计已保存\', description: \'组件配置已更新。\', onDismiss: () => demoAction(context, \'Dismissed\'))',
    (context, d) => SoftToast(
      message: '设计已保存',
      description: '组件配置已更新。',
      onDismiss: () => demoAction(context, 'Dismissed'),
    ),
  ),
  ComponentSpec(
    'SoftAreaChart',
    '图表',
    'const SoftAreaChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftAreaChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'SoftBarChart',
    '图表',
    'const SoftBarChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftBarChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'SoftChartLegend',
    '图表',
    'SoftChartLegend(labels: [\'Design\', \'Code\', \'Motion\'])',
    (context, d) => const SoftChartLegend(labels: ['Design', 'Code', 'Motion']),
  ),
  ComponentSpec(
    'SoftComparisonBars',
    '图表',
    'SoftComparisonBars(values: {\'Design\': .8, \'Code\': .65, \'Motion\': .4})',
    (context, d) => const SoftComparisonBars(
      values: {'Design': .8, 'Code': .65, 'Motion': .4},
    ),
  ),
  ComponentSpec(
    'SoftDonutChart',
    '图表',
    'const SoftDonutChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftDonutChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'SoftGaugeChart',
    '图表',
    'SoftGaugeChart(value: d.progress)',
    (context, d) => SoftGaugeChart(value: d.progress),
  ),
  ComponentSpec(
    'SoftHeatmap',
    '图表',
    'SoftHeatmap(values: List.generate(28, (i) => ((i * 7) % 11).toDouble()))',
    (context, d) => SoftHeatmap(
      values: List.generate(28, (i) => ((i * 7) % 11).toDouble()),
    ),
  ),
  ComponentSpec(
    'SoftLineChart',
    '图表',
    'const SoftLineChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftLineChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'SoftRadarChart',
    '图表',
    'const SoftRadarChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftRadarChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'SoftScatterChart',
    '图表',
    'const SoftScatterChart(values: [2, 5, 3, 8, 6, 9, 7])',
    (context, d) => const SoftScatterChart(values: [2, 5, 3, 8, 6, 9, 7]),
  ),
  ComponentSpec(
    'AnalyticsCard',
    '基础与参考',
    'AnalyticsCard(title: \'Members\', value: \'1,930\', values: const [2, 4, 3, 6, 8], selected: d.index, onChanged: d.setIndex)',
    (context, d) => AnalyticsCard(
      title: 'Members',
      value: '1,930',
      values: const [2, 4, 3, 6, 8],
      selected: d.index,
      onChanged: d.setIndex,
    ),
  ),
  ComponentSpec(
    'ChatBubble',
    '基础与参考',
    'const ChatBubble(message: \'One shared visual language.\', outgoing: true)',
    (context, d) => const ChatBubble(
      message: 'One shared visual language.',
      outgoing: true,
    ),
  ),
  ComponentSpec(
    'ProfileCard',
    '基础与参考',
    'ProfileCard(name: \'Chloe Harrison\', role: \'Product designer\', tags: const [\'Figma\', \'UX Design\'], onContact: () => demoAction(context, \'Contact\'))',
    (context, d) => ProfileCard(
      name: 'Chloe Harrison',
      role: 'Product designer',
      tags: const ['Figma', 'UX Design'],
      onContact: () => demoAction(context, 'Contact'),
    ),
  ),
  ComponentSpec(
    'SoftButton',
    '基础与参考',
    'SoftButton(label: \'Continue\', primary: d.flag, onPressed: () => d.setFlag(!d.flag))',
    (context, d) => SoftButton(
      label: 'Continue',
      primary: d.flag,
      onPressed: () => d.setFlag(!d.flag),
    ),
  ),
  ComponentSpec(
    'SoftComposer',
    '基础与参考',
    'SoftComposer(onSend: (v) => demoAction(context, \'Message: \$v\'))',
    (context, d) =>
        SoftComposer(onSend: (v) => demoAction(context, 'Message: $v')),
  ),
  ComponentSpec(
    'SoftEmptyState',
    '基础与参考',
    'SoftEmptyState(title: \'A quieter update\', description: \'No notifications yet.\', onAction: () => demoAction(context, \'Set up\'))',
    (context, d) => SoftEmptyState(
      title: 'A quieter update',
      description: 'No notifications yet.',
      onAction: () => demoAction(context, 'Set up'),
    ),
  ),
  ComponentSpec(
    'SoftSegmented',
    '基础与参考',
    'SoftSegmented(labels: const [\'All\', \'Active\', \'Saved\'], selected: d.index, onChanged: d.setIndex)',
    (context, d) => SoftSegmented(
      labels: const ['All', 'Active', 'Saved'],
      selected: d.index,
      onChanged: d.setIndex,
    ),
  ),
  ComponentSpec(
    'SoftSurface',
    '基础与参考',
    'SoftSurface(tinted: true, child: Text(\'Pearl gradient surface\'))',
    (context, d) =>
        const SoftSurface(tinted: true, child: Text('Pearl gradient surface')),
  ),
  ComponentSpec(
    'SoftTag',
    '基础与参考',
    'const SoftTag(\'DESIGN SYSTEM\')',
    (context, d) => const SoftTag('DESIGN SYSTEM'),
  ),
  ComponentSpec(
    'UploadCard',
    '基础与参考',
    'UploadCard(fileName: \'Design system.fig\', progress: .6, onSelect: () => demoAction(context, \'Choose file\'))',
    (context, d) => UploadCard(
      fileName: 'Design system.fig',
      progress: .6,
      onSelect: () => demoAction(context, 'Choose file'),
    ),
  ),
  ComponentSpec(
    'SoftNavigation',
    '导航',
    'SoftNavigation(selected: d.index, onChanged: d.setIndex)',
    (context, d) => SoftNavigation(selected: d.index, onChanged: d.setIndex),
  ),
  ComponentSpec(
    'SoftAspectCard',
    '布局',
    'SoftAspectCard(child: Text(\'φ · 1.618 : 1\'))',
    (context, d) => const SoftAspectCard(child: Text('φ · 1.618 : 1')),
  ),
  ComponentSpec(
    'SoftBottomActions',
    '布局',
    'SoftBottomActions(primary: SoftButton(label: \'Save\', primary: true, onPressed: () => demoAction(context, \'Saved\')), secondary: SoftButton(label: \'Cancel\', onPressed: () => demoAction(context, \'Cancelled\')))',
    (context, d) => SoftBottomActions(
      primary: SoftButton(
        label: 'Save',
        primary: true,
        onPressed: () => demoAction(context, 'Saved'),
      ),
      secondary: SoftButton(
        label: 'Cancel',
        onPressed: () => demoAction(context, 'Cancelled'),
      ),
    ),
  ),
  ComponentSpec(
    'SoftDetailRows',
    '布局',
    'SoftDetailRows(values: {\'Status\': \'Ready\', \'Version\': \'1.0\', \'Theme\': \'Shared\'})',
    (context, d) => const SoftDetailRows(
      values: {'Status': 'Ready', 'Version': '1.0', 'Theme': 'Shared'},
    ),
  ),
  ComponentSpec(
    'SoftExpandablePanel',
    '布局',
    'Column(children: [SoftButton(label: \'Toggle panel\', onPressed: () => d.setFlag(!d.flag)), SoftExpandablePanel(expanded: d.flag, child: Padding(padding: EdgeInsets.all(20), child: Text(\'Details appear smoothly.\')))])',
    (context, d) => Column(
      children: [
        SoftButton(label: 'Toggle panel', onPressed: () => d.setFlag(!d.flag)),
        SoftExpandablePanel(
          expanded: d.flag,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Details appear smoothly.'),
          ),
        ),
      ],
    ),
  ),
  ComponentSpec(
    'SoftMasonryLayout',
    '布局',
    'SoftMasonryLayout(children: [SoftSurface(child: SizedBox(height: 60, child: Text(\'Short\'))), SoftSurface(child: SizedBox(height: 100, child: Text(\'Tall\')))])',
    (context, d) => const SoftMasonryLayout(
      children: [
        SoftSurface(child: SizedBox(height: 60, child: Text('Short'))),
        SoftSurface(child: SizedBox(height: 100, child: Text('Tall'))),
      ],
    ),
  ),
  ComponentSpec(
    'SoftPageHeader',
    '布局',
    'SoftPageHeader(title: \'Your workspace\', subtitle: \'A little room for your ideas.\', actions: [SoftButton(label: \'Create\', onPressed: () => demoAction(context, \'Create\'))])',
    (context, d) => SoftPageHeader(
      title: 'Your workspace',
      subtitle: 'A little room for your ideas.',
      actions: [
        SoftButton(
          label: 'Create',
          onPressed: () => demoAction(context, 'Create'),
        ),
      ],
    ),
  ),
  ComponentSpec(
    'SoftResponsiveGrid',
    '布局',
    'SoftResponsiveGrid(minItemWidth: 110, children: [SoftSurface(child: Text(\'One\')), SoftSurface(child: Text(\'Two\')), SoftSurface(child: Text(\'Three\'))])',
    (context, d) => const SoftResponsiveGrid(
      minItemWidth: 110,
      children: [
        SoftSurface(child: Text('One')),
        SoftSurface(child: Text('Two')),
        SoftSurface(child: Text('Three')),
      ],
    ),
  ),
  ComponentSpec(
    'SoftSafeText',
    '布局',
    'const SoftSafeText(\'A deliberately long heading that stays within its component instead of stretching the whole layout.\', maxLines: 2)',
    (context, d) => const SoftSafeText(
      'A deliberately long heading that stays within its component instead of stretching the whole layout.',
      maxLines: 2,
    ),
  ),
  ComponentSpec(
    'SoftScrollPanel',
    '布局',
    'SoftScrollPanel(height: 160, child: Column(children: List.generate(12, (i) => SoftListTile(title: \'Item \${i + 1}\'))))',
    (context, d) => SoftScrollPanel(
      height: 160,
      child: Column(
        children: List.generate(
          12,
          (i) => SoftListTile(title: 'Item ${i + 1}'),
        ),
      ),
    ),
  ),
  ComponentSpec(
    'SoftSection',
    '布局',
    'const SoftSection(title: \'A clear section\', description: \'Heading, context and content.\', child: SoftSurface(child: Text(\'Your content\')))',
    (context, d) => const SoftSection(
      title: 'A clear section',
      description: 'Heading, context and content.',
      child: SoftSurface(child: Text('Your content')),
    ),
  ),
  ComponentSpec(
    'SoftSidebarLayout',
    '布局',
    'SoftSidebarLayout(sidebar: SoftSurface(child: Text(\'Navigation\')), content: SoftSurface(child: Text(\'Workspace\')))',
    (context, d) => const SoftSidebarLayout(
      sidebar: SoftSurface(child: Text('Navigation')),
      content: SoftSurface(child: Text('Workspace')),
    ),
  ),
  ComponentSpec(
    'SoftSplitLayout',
    '布局',
    'SoftSplitLayout(leading: SoftSurface(child: Text(\'Content\')), trailing: SoftSurface(child: Text(\'Details\')))',
    (context, d) => const SoftSplitLayout(
      leading: SoftSurface(child: Text('Content')),
      trailing: SoftSurface(child: Text('Details')),
    ),
  ),
  ComponentSpec(
    'SoftTimeline',
    '布局',
    'SoftTimeline(events: {\'09:00\': \'Created component\', \'10:30\': \'Updated theme\', \'12:00\': \'Ready for review\'})',
    (context, d) => const SoftTimeline(
      events: {
        '09:00': 'Created component',
        '10:30': 'Updated theme',
        '12:00': 'Ready for review',
      },
    ),
  ),
  ComponentSpec(
    'SoftToolbar',
    '布局',
    'SoftToolbar(actions: [IconButton(tooltip: \'Search\', onPressed: () => demoAction(context, \'Search\'), icon: const Icon(Icons.search)), IconButton(tooltip: \'More\', onPressed: () => demoAction(context, \'More\'), icon: const Icon(Icons.more_horiz))])',
    (context, d) => SoftToolbar(
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () => demoAction(context, 'Search'),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          tooltip: 'More',
          onPressed: () => demoAction(context, 'More'),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    ),
  ),
  ComponentSpec(
    'SoftWrapLayout',
    '布局',
    'SoftWrapLayout(children: [SoftTag(\'Design\'), SoftTag(\'Flutter\'), SoftTag(\'Motion\')])',
    (context, d) => const SoftWrapLayout(
      children: [SoftTag('Design'), SoftTag('Flutter'), SoftTag('Motion')],
    ),
  ),
  ComponentSpec(
    'SoftAccordion',
    '常用控件',
    'const SoftAccordion(title: \'How does composition work?\', child: Text(\'Combine primitives and keep the shared theme.\'))',
    (context, d) => const SoftAccordion(
      title: 'How does composition work?',
      child: Text('Combine primitives and keep the shared theme.'),
    ),
  ),
  ComponentSpec(
    'SoftAlert',
    '常用控件',
    'SoftAlert(title: \'All in sync\', message: \'Shared style across every component.\', onDismiss: () => demoAction(context, \'Dismissed\'))',
    (context, d) => SoftAlert(
      title: 'All in sync',
      message: 'Shared style across every component.',
      onDismiss: () => demoAction(context, 'Dismissed'),
    ),
  ),
  ComponentSpec(
    'SoftAvatar',
    '常用控件',
    'const SoftAvatar(label: \'Chloe\', size: 64)',
    (context, d) => const SoftAvatar(label: 'Chloe', size: 64),
  ),
  ComponentSpec(
    'SoftBadge',
    '常用控件',
    'const SoftBadge(label: \'3\', child: SoftIcon(Icons.notifications_none_rounded))',
    (context, d) => const SoftBadge(
      label: '3',
      child: SoftIcon(Icons.notifications_none_rounded),
    ),
  ),
  ComponentSpec(
    'SoftBreadcrumbs',
    '常用控件',
    'SoftBreadcrumbs(labels: const [\'Library\', \'Components\', \'Detail\'], onSelected: (i) => demoAction(context, \'Breadcrumb \$i\'))',
    (context, d) => SoftBreadcrumbs(
      labels: const ['Library', 'Components', 'Detail'],
      onSelected: (i) => demoAction(context, 'Breadcrumb $i'),
    ),
  ),
  ComponentSpec(
    'SoftCheckbox',
    '常用控件',
    'SoftCheckbox(label: \'Keep me updated\', value: d.flag, onChanged: (v) => d.setFlag(v!))',
    (context, d) => SoftCheckbox(
      label: 'Keep me updated',
      value: d.flag,
      onChanged: (v) => d.setFlag(v!),
    ),
  ),
  ComponentSpec(
    'SoftDateField',
    '常用控件',
    'SoftDateField(value: d.date, onChanged: d.setDate)',
    (context, d) => SoftDateField(value: d.date, onChanged: d.setDate),
  ),
  ComponentSpec(
    'SoftListTile',
    '常用控件',
    'SoftListTile(title: \'Design workspace\', subtitle: \'Shared with your team\', leading: const SoftIcon(Icons.folder_outlined), onTap: () => demoAction(context, \'Workspace\'))',
    (context, d) => SoftListTile(
      title: 'Design workspace',
      subtitle: 'Shared with your team',
      leading: const SoftIcon(Icons.folder_outlined),
      onTap: () => demoAction(context, 'Workspace'),
    ),
  ),
  ComponentSpec(
    'SoftMenu',
    '常用控件',
    'SoftMenu(items: const [\'Duplicate\', \'Archive\'], onSelected: (v) => demoAction(context, v))',
    (context, d) => SoftMenu(
      items: const ['Duplicate', 'Archive'],
      onSelected: (v) => demoAction(context, v),
    ),
  ),
  ComponentSpec(
    'SoftPagination',
    '常用控件',
    'SoftPagination(page: d.number, pages: 5, onChanged: d.setNumber)',
    (context, d) =>
        SoftPagination(page: d.number, pages: 5, onChanged: d.setNumber),
  ),
  ComponentSpec(
    'SoftProgress',
    '常用控件',
    'SoftProgress(value: d.progress)',
    (context, d) => SoftProgress(value: d.progress),
  ),
  ComponentSpec(
    'SoftSkeleton',
    '常用控件',
    'const SoftSkeleton(height: 24)',
    (context, d) => const SoftSkeleton(height: 24),
  ),
  ComponentSpec(
    'SoftSlider',
    '常用控件',
    'SoftSlider(label: \'Volume\', value: d.progress * 100, onChanged: (v) => d.setProgress(v / 100))',
    (context, d) => SoftSlider(
      label: 'Volume',
      value: d.progress * 100,
      onChanged: (v) => d.setProgress(v / 100),
    ),
  ),
  ComponentSpec(
    'SoftSteps',
    '常用控件',
    'SoftSteps(labels: const [\'Choose\', \'Adjust\', \'Publish\'], current: d.index, onSelected: d.setIndex)',
    (context, d) => SoftSteps(
      labels: const ['Choose', 'Adjust', 'Publish'],
      current: d.index,
      onSelected: d.setIndex,
    ),
  ),
  ComponentSpec(
    'SoftSwitch',
    '常用控件',
    'SoftSwitch(label: \'Enable notifications\', value: d.flag, onChanged: d.setFlag)',
    (context, d) => SoftSwitch(
      label: 'Enable notifications',
      value: d.flag,
      onChanged: d.setFlag,
    ),
  ),
  ComponentSpec(
    'SoftTable',
    '常用控件',
    'SoftTable(columns: [\'Name\', \'Role\'], rows: [[\'Chloe\', \'Design\'], [\'Alex\', \'Code\']])',
    (context, d) => SoftTable(
      columns: const ['Name', 'Role'],
      selectedRows: d.choices,
      onSelectionChanged: d.setChoices,
      pageSize: 1,
      page: d.number,
      onPageChanged: d.setNumber,
      sortColumnIndex: d.index,
      sortAscending: d.flag,
      onSort: (column, ascending) {
        d.setIndex(column);
        d.setFlag(ascending);
      },
      rows: (d.flag
          ? const [
              ['Alex', 'Code'],
              ['Chloe', 'Design'],
            ]
          : const [
              ['Chloe', 'Design'],
              ['Alex', 'Code'],
            ]),
    ),
  ),
  ComponentSpec(
    'SoftTabs',
    '常用控件',
    'SoftTabs(labels: const [\'Design\', \'Code\', \'Motion\'], selected: d.index, onChanged: d.setIndex)',
    (context, d) => SoftTabs(
      labels: const ['Design', 'Code', 'Motion'],
      selected: d.index,
      onChanged: d.setIndex,
    ),
  ),
  ComponentSpec(
    'SoftTextField',
    '常用控件',
    'SoftTextField(label: \'Your name\', hint: \'Write something\', onChanged: d.setText)',
    (context, d) => SoftTextField(
      label: 'Your name',
      hint: 'Write something',
      onChanged: d.setText,
    ),
  ),
  ComponentSpec(
    'SoftTimeField',
    '常用控件',
    'SoftTimeField(value: d.time, onChanged: d.setTime)',
    (context, d) => SoftTimeField(value: d.time, onChanged: d.setTime),
  ),
  ComponentSpec(
    'SoftTooltip',
    '常用控件',
    'const SoftTooltip(message: \'Helpful context\', child: SoftTag(\'Hover or long press\'))',
    (context, d) => const SoftTooltip(
      message: 'Helpful context',
      child: SoftTag('Hover or long press'),
    ),
  ),
  ComponentSpec(
    'SoftAgenda',
    '日期与日程',
    'SoftAgenda(events: {\'09:00\': \'Design review\', \'11:30\': \'Team sync\', \'15:00\': \'Focus time\'})',
    (context, d) => const SoftAgenda(
      events: {
        '09:00': 'Design review',
        '11:30': 'Team sync',
        '15:00': 'Focus time',
      },
    ),
  ),
  ComponentSpec(
    'SoftAppointmentCard',
    '日期与日程',
    'SoftAppointmentCard(title: \'Design review\', time: \'09:00 — 09:45 · demo\', attendees: const [\'Chloe\', \'Alex\', \'You\'], onJoin: () => demoAction(context, \'Join callback\'))',
    (context, d) => SoftAppointmentCard(
      title: 'Design review',
      time: '09:00 — 09:45 · demo',
      attendees: const ['Chloe', 'Alex', 'You'],
      onJoin: () => demoAction(context, 'Join callback'),
    ),
  ),
  ComponentSpec(
    'SoftCalendar',
    '日期与日程',
    'SoftCalendar(month: d.month, selected: d.date, onMonthChanged: d.setMonth, onSelected: d.setDate)',
    (context, d) => SoftCalendar(
      month: d.month,
      selected: d.date,
      onMonthChanged: d.setMonth,
      onSelected: d.setDate,
    ),
  ),
  ComponentSpec(
    'SoftDateRangeCalendar',
    '日期与日程',
    'SoftDateRangeCalendar(month: d.month, value: d.dateRange, onMonthChanged: d.setMonth, onChanged: d.setDateRange)',
    (context, d) => SoftDateRangeCalendar(
      month: d.month,
      value: d.dateRange,
      onMonthChanged: d.setMonth,
      onChanged: d.setDateRange,
    ),
  ),
  ComponentSpec(
    'SoftMonthPicker',
    '日期与日程',
    'SoftMonthPicker(value: d.date, onChanged: d.setDate)',
    (context, d) => SoftMonthPicker(value: d.date, onChanged: d.setDate),
  ),
  ComponentSpec(
    'SoftWeekStrip',
    '日期与日程',
    'SoftWeekStrip(start: DateTime(2026, 10, 5), selected: d.date, onSelected: d.setDate)',
    (context, d) => SoftWeekStrip(
      start: DateTime(2026, 10, 5),
      selected: d.date,
      onSelected: d.setDate,
    ),
  ),
  ComponentSpec(
    'SoftYearPicker',
    '日期与日程',
    'SoftYearPicker(value: d.date, onChanged: d.setDate)',
    (context, d) => SoftYearPicker(value: d.date, onChanged: d.setDate),
  ),
  ComponentSpec(
    'SoftGlassSurface',
    '材质与高光',
    'Stack(children: [Container(height: 140, decoration: BoxDecoration(gradient: LinearGradient(colors: [SoftDesign.of(context).accent, Colors.white]))), Positioned.fill(child: Center(child: SoftGlassSurface(child: Text(\'Backdrop blur · real glass\'))))])',
    (context, d) => Stack(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [SoftDesign.of(context).accent, Colors.white],
            ),
          ),
        ),
        const Positioned.fill(
          child: Center(
            child: SoftGlassSurface(child: Text('Backdrop blur · real glass')),
          ),
        ),
      ],
    ),
  ),
  ComponentSpec(
    'SoftHighlight',
    '材质与高光',
    'const SoftHighlight(child: Padding(padding: EdgeInsets.all(24), child: Text(\'Directional highlight border\')))',
    (context, d) => const SoftHighlight(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Directional highlight border'),
      ),
    ),
  ),
];
