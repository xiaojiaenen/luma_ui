import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

import 'catalog.dart';
import 'catalog_data.dart';

class NewCollection extends StatefulWidget {
  const NewCollection({super.key});
  @override
  State<NewCollection> createState() => _NewCollectionState();
}

class _NewCollectionState extends State<NewCollection> {
  DateTime month = DateTime(2026, 10), selected = DateTime(2026, 10, 10);
  bool playing = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SoftPageHeader(
        title: '日常场景，统一而不单调。',
        subtitle: '日程、旅行与音乐，各有色彩表达，共享圆角、高光和交互节奏。',
        actions: [
          SoftButton(
            label: '浏览全部 ${componentSpecs.length} 个组件',
            icon: Icons.grid_view_outlined,
            primary: true,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ComponentCatalog()),
            ),
          ),
        ],
      ),
      const SizedBox(height: 28),
      SoftSplitLayout(
        breakpoint: 760,
        leading: SoftCalendar(
          month: month,
          selected: selected,
          onMonthChanged: (d) => setState(() => month = d),
          onSelected: (d) => setState(() => selected = d),
        ),
        trailing: SoftSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('今日安排', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${selected.month} 月 ${selected.day} 日 · 演示日程'),
              const SizedBox(height: 24),
              for (final event in [
                (Icons.palette_outlined, '09:30', '设计灵感整理', SoftTone.secondary),
                (Icons.code_rounded, '14:00', '组件交互打磨', SoftTone.ai),
                (
                  Icons.wb_sunny_outlined,
                  '17:30',
                  '留一点时间给自己',
                  SoftTone.tertiary,
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: SoftDesign.of(context).container(event.$4),
                          borderRadius: BorderRadius.circular(
                            SoftDesign.of(context).radius,
                          ),
                        ),
                        child: Icon(
                          event.$1,
                          color: SoftDesign.of(context).color(event.$4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.$2,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              event.$3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 28),
      const SoftSection(
        title: '从参考图继续生长',
        description: '天气、航班、音乐和健康卡继承统一主题；所有内容为演示数据。',
        child: SizedBox.shrink(),
      ),
      SoftResponsiveGrid(
        minItemWidth: 250,
        gap: 24,
        children: [
          const SoftWeatherCard(
            city: 'Calicut, Kerala',
            temperature: '28°',
            condition: 'Pretty sunny · demo',
            humidity: '72%',
          ),
          const SoftFlightTicket(
            from: 'SFO',
            to: 'JFK',
            departure: '9:25 PM',
            arrival: '2:15 AM',
            gate: 'B16',
          ),
          SoftAudioPlayer(
            title: 'Nothing Was The Same',
            artist: 'Music card · reference study',
            playing: playing,
            onToggle: () => setState(() => playing = !playing),
            progress: .42,
          ),
          const SoftHealthCard(
            heartRate: '98',
            distance: '8.13 km',
            calories: '768 kcal',
            hours: '5 hr',
          ),
        ],
      ),
      const SizedBox(height: 28),
      SoftSplitLayout(
        breakpoint: 760,
        leading: SoftSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Color with a purpose',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text('主趋势使用品牌色，分类数据使用独立色组'),
              const SoftAreaChart(values: [2, 4, 3, 7, 6, 9]),
              const SoftChartLegend(labels: ['Theme series']),
            ],
          ),
        ),
        trailing: SoftSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('时间的颜色', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('工作与生活，保持舒服的节奏 · 演示数据'),
              const SizedBox(height: 20),
              const SoftDonutChart(values: [42, 28, 18, 12]),
              const SizedBox(height: 20),
              const SoftChartLegend(labels: ['设计', '开发', '学习', '休息']),
            ],
          ),
        ),
      ),
      const SizedBox(height: 52),
    ],
  );
}
