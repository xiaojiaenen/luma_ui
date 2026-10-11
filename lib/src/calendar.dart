import 'strings.dart';
import 'icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components.dart';
import 'design.dart';
import 'motion.dart';
import 'controls.dart';

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class SoftCalendar extends StatelessWidget {
  const SoftCalendar({
    super.key,
    required this.month,
    required this.onMonthChanged,
    required this.onSelected,
    this.selected,
    this.range,
    this.minDate,
    this.maxDate,
  });
  final DateTime month;
  final DateTime? selected, minDate, maxDate;
  final DateTimeRange? range;
  final ValueChanged<DateTime> onSelected, onMonthChanged;
  @override
  Widget build(BuildContext context) => Focus(
    canRequestFocus: false,
    onKeyEvent: (_, event) => _key(context, event),
    child: SoftSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: softText(context, 'Previous month'),
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month - 1)),
                icon: const SoftIcon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${month.year} / ${month.month.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: softText(context, 'Next month'),
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month + 1)),
                icon: const SoftIcon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: box.maxWidth < 336 ? 336 : box.maxWidth,
                child: AnimatedSwitcher(
                  duration: SoftMotion.duration(context),
                  child: _grid(context),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  KeyEventResult _key(BuildContext context, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final date = selected ?? DateTime(month.year, month.month, 1);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    DateTime? next;
    if (key == LogicalKeyboardKey.arrowRight) {
      next = date.add(Duration(days: rtl ? -1 : 1));
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      next = date.add(Duration(days: rtl ? 1 : -1));
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      next = date.add(const Duration(days: 7));
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      next = date.subtract(const Duration(days: 7));
    }
    if (key == LogicalKeyboardKey.home) {
      next = DateTime(date.year, date.month, 1);
    }
    if (key == LogicalKeyboardKey.end) {
      next = DateTime(date.year, date.month + 1, 0);
    }
    if (key == LogicalKeyboardKey.pageUp ||
        key == LogicalKeyboardKey.pageDown) {
      final target = DateTime(
        date.year,
        date.month + (key == LogicalKeyboardKey.pageUp ? -1 : 1),
      );
      final last = DateTime(target.year, target.month + 1, 0).day;
      next = DateTime(
        target.year,
        target.month,
        date.day > last ? last : date.day,
      );
    }
    if (next == null) return KeyEventResult.ignored;
    if ((minDate == null || !next.isBefore(DateUtils.dateOnly(minDate!))) &&
        (maxDate == null || !next.isAfter(DateUtils.dateOnly(maxDate!)))) {
      if (next.year != month.year || next.month != month.month) {
        onMonthChanged(DateTime(next.year, next.month));
      }
      onSelected(next);
    }
    return KeyEventResult.handled;
  }

  Widget _grid(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final days = DateTime(month.year, month.month + 1, 0).day;
    final offset = first.weekday - 1;
    final design = SoftDesign.of(context);
    return Column(
      key: ValueKey('${month.year}-${month.month}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (final d in ['一', '二', '三', '四', '五', '六', '日'])
              Expanded(
                child: Center(
                  child: Text(
                    softText(context, d),
                    style: TextStyle(
                      fontSize: 11,
                      color: SoftDesign.of(context).muted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        for (var row = 0; row < 6; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final day = row * 7 + col - offset + 1;
                      if (day < 1 || day > days) {
                        return const SizedBox(height: 48);
                      }
                      final date = DateTime(month.year, month.month, day);
                      final enabled =
                          (minDate == null ||
                              !date.isBefore(DateUtils.dateOnly(minDate!))) &&
                          (maxDate == null ||
                              !date.isAfter(DateUtils.dateOnly(maxDate!)));
                      final chosen =
                          selected != null && _sameDay(selected!, date);
                      final inRange =
                          range != null &&
                          !date.isBefore(DateUtils.dateOnly(range!.start)) &&
                          !date.isAfter(DateUtils.dateOnly(range!.end));
                      return Semantics(
                        selected: chosen,
                        label: '${month.year}-${month.month}-$day',
                        child: AnimatedContainer(
                          duration: SoftMotion.duration(context),
                          height: 48,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: chosen
                                ? design.accent
                                : inRange
                                ? design.tint
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(design.radius),
                          ),
                          child: TextButton(
                            onPressed: enabled ? () => onSelected(date) : null,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: chosen
                                  ? design.onAccent
                                  : design.ink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  design.radius,
                                ),
                              ),
                            ),
                            child: Text(softText(context, '$day')),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class SoftWeekStrip extends StatelessWidget {
  const SoftWeekStrip({
    super.key,
    required this.start,
    required this.selected,
    required this.onSelected,
  });
  final DateTime start, selected;
  final ValueChanged<DateTime> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(7, (i) {
        final date = start.add(Duration(days: i));
        final active = _sameDay(date, selected);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SoftPress(
            child: SizedBox(
              width: 52,
              height: 72,
              child: Material(
                color: active
                    ? SoftDesign.of(context).tint
                    : Colors.white.withValues(alpha: .65),
                borderRadius: BorderRadius.circular(
                  SoftDesign.of(context).radius,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    SoftDesign.of(context).radius,
                  ),
                  onTap: () => onSelected(date),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        softText(
                          context,
                          [
                            'weekstrip.mon',
                            'weekstrip.tue',
                            'weekstrip.wed',
                            'weekstrip.thu',
                            'weekstrip.fri',
                            'weekstrip.sat',
                            'weekstrip.sun',
                          ][date.weekday - 1],
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: SoftDesign.of(context).muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );
}

class SoftMonthPicker extends StatelessWidget {
  const SoftMonthPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(
      12,
      (i) => SoftButton(
        label: '${i + 1} 月',
        primary: value.month == i + 1,
        onPressed: () => onChanged(DateTime(value.year, i + 1)),
      ),
    ),
  );
}

class SoftYearPicker extends StatelessWidget {
  const SoftYearPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstYear = 2000,
    this.lastYear = 2040,
  });
  final DateTime value;
  final int firstYear, lastYear;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 240,
    child: YearPicker(
      firstDate: DateTime(firstYear),
      lastDate: DateTime(lastYear),
      selectedDate: value,
      onChanged: onChanged,
    ),
  );
}

class SoftDateRangeCalendar extends StatelessWidget {
  const SoftDateRangeCalendar({
    super.key,
    required this.month,
    required this.onMonthChanged,
    required this.onChanged,
    this.value,
  });
  final DateTime month;
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange> onChanged;
  final ValueChanged<DateTime> onMonthChanged;
  @override
  Widget build(BuildContext context) => SoftCalendar(
    month: month,
    onMonthChanged: onMonthChanged,
    range: value,
    selected: value?.end,
    onSelected: (d) {
      final old = value;
      if (old == null ||
          !_sameDay(old.start, old.end) ||
          d.isBefore(old.start)) {
        onChanged(DateTimeRange(start: d, end: d));
      } else {
        onChanged(DateTimeRange(start: old.start, end: d));
      }
    },
  );
}

class SoftAgenda extends StatelessWidget {
  const SoftAgenda({super.key, required this.events});
  final Map<String, String> events;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: events.entries
        .map(
          (e) => SoftListTile(
            title: e.value,
            leading: Text(
              e.key,
              style: TextStyle(
                fontSize: 12,
                color: SoftDesign.of(context).muted,
              ),
            ),
            trailing: const SoftIcon(Icons.chevron_right, size: 18),
          ),
        )
        .toList(),
  );
}

class SoftAppointmentCard extends StatelessWidget {
  const SoftAppointmentCard({
    super.key,
    required this.title,
    required this.time,
    required this.attendees,
    this.onJoin,
  });
  final String title, time;
  final List<String> attendees;
  final VoidCallback? onJoin;
  @override
  Widget build(BuildContext context) => SoftSurface(
    tinted: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(time, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 12),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: attendees
              .map((a) => SoftAvatar(label: a, size: 32))
              .toList(),
        ),
        const SizedBox(height: 20),
        SoftButton(
          label: softText(context, 'Join meeting'),
          icon: Icons.videocam_outlined,
          onPressed: onJoin,
        ),
      ],
    ),
  );
}
