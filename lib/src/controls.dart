import 'strings.dart';
import 'icons.dart';

import 'package:flutter/material.dart';

import 'components.dart';
import 'calendar.dart';
import 'design.dart';
import 'motion.dart';

class SoftTextField extends StatelessWidget {
  const SoftTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.loading = false,
    this.errorText,
    this.helperText,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
  });
  final String label;
  final String? hint, errorText, helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged, onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureText, enabled, autofocus, readOnly, loading;
  final int maxLines;
  final IconData? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    focusNode: focusNode,
    autofocus: autofocus,
    onChanged: onChanged,
    onFieldSubmitted: onSubmitted,
    validator: validator,
    obscureText: obscureText,
    enabled: enabled,
    readOnly: readOnly || loading,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    maxLines: obscureText ? 1 : maxLines,
    decoration: InputDecoration(
      labelText: softText(context, label),
      hintText: hint == null ? null : softText(context, hint!),
      errorText: errorText,
      helperText: helperText,
      prefixIcon: prefixIcon == null ? null : SoftIcon(prefixIcon),
      suffixIcon: loading
          ? Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  value: MediaQuery.disableAnimationsOf(context) ? 1 : null,
                  strokeWidth: 2,
                  semanticsLabel: softText(context, 'Loading'),
                ),
              ),
            )
          : null,
    ),
  );
}

class SoftSelect<T> extends StatelessWidget {
  const SoftSelect({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.errorText,
  });
  final String label;
  final Map<T, String> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final FocusNode? focusNode;
  final String? errorText;
  @override
  Widget build(BuildContext context) => FormField<T>(
    initialValue: value,
    enabled: enabled && onChanged != null,
    validator: (_) => validator?.call(value),
    builder: (field) => Focus(
      canRequestFocus: false,
      child: Builder(
        builder: (context) => InputDecorator(
          isFocused: Focus.of(context).hasFocus,
          isEmpty: value == null,
          decoration: InputDecoration(
            labelText: softText(context, label),
            errorText: errorText ?? field.errorText,
            enabled: enabled && onChanged != null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              focusNode: focusNode,
              isExpanded: true,
              isDense: true,
              borderRadius: BorderRadius.circular(
                SoftDesign.of(context).radius,
              ),
              items: items.entries
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e.key,
                      child: Text(
                        e.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: !enabled || onChanged == null
                  ? null
                  : (v) {
                      field.didChange(v);
                      onChanged!(v);
                    },
            ),
          ),
        ),
      ),
    ),
  );
}

class SoftSwitch extends StatelessWidget {
  const SoftSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(softText(context, label)),
    value: value,
    activeThumbColor: SoftDesign.of(context).onAccent,
    activeTrackColor: SoftDesign.of(context).accent,
    onChanged: onChanged,
  );
}

class SoftCheckbox extends StatelessWidget {
  const SoftCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  @override
  Widget build(BuildContext context) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(softText(context, label)),
    value: value,
    activeColor: SoftDesign.of(context).ink,
    checkColor: SoftDesign.of(context).surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    onChanged: onChanged,
  );
}

class SoftSlider extends StatelessWidget {
  const SoftSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });
  final String label;
  final double value, min, max;
  final ValueChanged<double>? onChanged;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(softText(context, '$label · ${value.toStringAsFixed(0)}')),
      Slider(
        value: value,
        min: min,
        max: max,
        activeColor: SoftDesign.of(context).ink,
        secondaryActiveColor: SoftDesign.of(context).accent,
        onChanged: onChanged,
      ),
    ],
  );
}

class SoftAlert extends StatelessWidget {
  const SoftAlert({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.onDismiss,
    this.tone = SoftTone.info,
  });
  final String title, message;
  final IconData icon;
  final SoftTone tone;
  final VoidCallback? onDismiss;
  @override
  Widget build(BuildContext context) => SoftSurface(
    inset: true,
    tone: tone,
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftIcon(icon, size: 22, color: SoftDesign.of(context).color(tone)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(message),
            ],
          ),
        ),
        if (onDismiss != null)
          IconButton(
            onPressed: onDismiss,
            tooltip: softText(context, 'Dismiss'),
            icon: const SoftIcon(Icons.close, size: 18),
          ),
      ],
    ),
  );
}

class SoftAvatar extends StatelessWidget {
  const SoftAvatar({
    super.key,
    required this.label,
    this.image,
    this.size = 48,
  });
  final String label;
  final ImageProvider? image;
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: CircleAvatar(
      radius: size / 2,
      backgroundColor: SoftDesign.of(context).tint,
      backgroundImage: image,
      child: image == null
          ? Text(
              label.isEmpty ? '?' : label.characters.first.toUpperCase(),
              style: TextStyle(
                color: SoftDesign.of(context).ink,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    ),
  );
}

class SoftBadge extends StatelessWidget {
  const SoftBadge({super.key, required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Badge(
    label: Text(softText(context, label)),
    backgroundColor: SoftDesign.of(context).ink,
    textColor: Colors.white,
    child: child,
  );
}

class SoftListTile extends StatelessWidget {
  const SoftListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });
  final String title;
  final String? subtitle;
  final Widget? leading, trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SoftDesign.of(context).controlRadius,
        ),
      ),
      leading: leading,
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: trailing == null
          ? null
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 96),
              child: trailing,
            ),
      onTap: onTap,
    ),
  );
}

class SoftAccordion extends StatelessWidget {
  const SoftAccordion({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => ExpansionTile(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    title: Text(title),
    childrenPadding: const EdgeInsets.all(16),
    children: [child],
  );
}

class SoftProgress extends StatelessWidget {
  const SoftProgress({super.key, this.value});
  final double? value;
  Widget bar(BuildContext context, double? progress) => ClipRRect(
    borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    child: LinearProgressIndicator(
      value: progress,
      minHeight: 6,
      color: SoftDesign.of(context).accent,
      backgroundColor: SoftDesign.of(context).background,
    ),
  );
  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return bar(context, MediaQuery.disableAnimationsOf(context) ? .5 : null);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value!),
      duration: SoftMotion.duration(context, 300),
      curve: SoftMotion.curve,
      builder: (context, progress, _) => bar(context, progress),
    );
  }
}

class SoftSkeleton extends StatelessWidget {
  const SoftSkeleton({super.key, this.height = 20, this.width});
  final double height;
  final double? width;
  @override
  Widget build(BuildContext context) => Semantics(
    label: softText(context, 'Loading'),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: SoftDesign.of(context).background,
        borderRadius: BorderRadius.circular(
          SoftDesign.of(context).controlRadius,
        ),
      ),
    ),
  );
}

class SoftPagination extends StatelessWidget {
  const SoftPagination({
    super.key,
    required this.page,
    required this.pages,
    required this.onChanged,
  }) : assert(pages > 0),
       assert(page >= 1 && page <= pages);
  final int page, pages;
  final ValueChanged<int>? onChanged;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: page > 1 && onChanged != null
            ? () => onChanged!(page - 1)
            : null,
        tooltip: softText(context, 'Previous page'),
        icon: const SoftIcon(Icons.chevron_left),
      ),
      Text(softText(context, '$page / $pages')),
      IconButton(
        onPressed: page < pages && onChanged != null
            ? () => onChanged!(page + 1)
            : null,
        tooltip: softText(context, 'Next page'),
        icon: const SoftIcon(Icons.chevron_right),
      ),
    ],
  );
}

class SoftTabs extends StatelessWidget {
  const SoftTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) =>
      SoftSegmented(labels: labels, selected: selected, onChanged: onChanged);
}

class SoftBreadcrumbs extends StatelessWidget {
  const SoftBreadcrumbs({
    super.key,
    required this.labels,
    required this.onSelected,
  });
  final List<String> labels;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (var i = 0; i < labels.length; i++) ...[
        if (i > 0) const SoftIcon(Icons.chevron_right, size: 16),
        TextButton(
          onPressed: i == labels.length - 1 ? null : () => onSelected(i),
          child: Text(labels[i]),
        ),
      ],
    ],
  );
}

Future<T?> showSoftDialog<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  List<Widget> actions = const [],
}) {
  final design = SoftDesign.of(context);
  return showDialog<T>(
    context: context,
    builder: (context) => SoftDesign(
      accent: design.accent,
      radius: design.radius,
      spacing: design.spacing,
      shadow: design.shadow,
      controlHeight: design.controlHeight,
      child: AlertDialog(
        backgroundColor: SoftDesign.of(context).background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.radius),
        ),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        content: content,
        actions: actions,
      ),
    ),
  );
}

Future<T?> showSoftSheet<T>(BuildContext context, {required Widget child}) {
  final design = SoftDesign.of(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SoftDesign.of(context).background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(design.radius)),
    ),
    builder: (context) => SoftDesign(
      accent: design.accent,
      radius: design.radius,
      spacing: design.spacing,
      shadow: design.shadow,
      controlHeight: design.controlHeight,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(design.spacing), child: child),
        ),
      ),
    ),
  );
}

class SoftRadioGroup<T> extends StatelessWidget {
  const SoftRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });
  final Map<T, String> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  @override
  Widget build(BuildContext context) => RadioGroup<T>(
    groupValue: value,
    onChanged: onChanged ?? (_) {},
    child: Column(
      children: items.entries
          .map(
            (e) => RadioListTile<T>(
              contentPadding: EdgeInsets.zero,
              enabled: onChanged != null,
              title: Text(e.value),
              value: e.key,
              activeColor: SoftDesign.of(context).ink,
            ),
          )
          .toList(),
    ),
  );
}

class SoftTooltip extends StatelessWidget {
  const SoftTooltip({super.key, required this.message, required this.child});
  final String message;
  final Widget child;
  @override
  Widget build(BuildContext context) => Tooltip(
    message: message,
    decoration: BoxDecoration(
      color: SoftDesign.of(context).ink,
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    padding: const EdgeInsets.all(12),
    child: child,
  );
}

class SoftMenu extends StatelessWidget {
  const SoftMenu({super.key, required this.items, required this.onSelected});
  final List<String> items;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: softText(context, 'Open menu'),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SoftDesign.of(context).controlRadius),
    ),
    color: SoftDesign.of(context).surface,
    onSelected: onSelected,
    itemBuilder: (_) =>
        items.map((s) => PopupMenuItem(value: s, child: Text(s))).toList(),
  );
}

class SoftDateField extends StatelessWidget {
  const SoftDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Date',
  });
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final String label;
  @override
  Widget build(BuildContext context) => SoftButton(
    label:
        '${softText(context, label)} · ${value.year}/${value.month}/${value.day}',
    icon: Icons.calendar_today_outlined,
    onPressed: () async {
      var selected = value;
      var month = DateTime(value.year, value.month);
      final date = await _showFieldPicker<DateTime>(
        context,
        (dialogContext) => StatefulBuilder(
          builder: (context, update) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                softText(context, '选择日期'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SoftCalendar(
                month: month,
                selected: selected,
                minDate: DateTime(1900),
                maxDate: DateTime(2200, 12, 31),
                onMonthChanged: (date) => update(() => month = date),
                onSelected: (date) => update(() => selected = date),
              ),
              const SizedBox(height: 20),
              _pickerActions(
                context,
                () => Navigator.pop(dialogContext, selected),
              ),
            ],
          ),
        ),
      );
      if (date != null) {
        onChanged(date);
      }
    },
  );
}

class SoftTimeField extends StatelessWidget {
  const SoftTimeField({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;
  @override
  Widget build(BuildContext context) => SoftButton(
    label: value.format(context),
    icon: Icons.schedule,
    onPressed: () async {
      var hour = value.hour, minute = value.minute;
      final time = await _showFieldPicker<TimeOfDay>(
        context,
        (dialogContext) => StatefulBuilder(
          builder: (context, update) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                softText(context, '选择时间'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                softText(context, '24 小时制'),
                style: TextStyle(color: SoftDesign.of(context).muted),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _timeColumn(
                      context,
                      softText(context, '小时'),
                      hour,
                      (delta) => update(() => hour = (hour + delta) % 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      softText(context, ':'),
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  Expanded(
                    child: _timeColumn(
                      context,
                      softText(context, '分钟'),
                      minute,
                      (delta) => update(() => minute = (minute + delta) % 60),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _pickerActions(
                context,
                () => Navigator.pop(
                  dialogContext,
                  TimeOfDay(hour: hour, minute: minute),
                ),
              ),
            ],
          ),
        ),
      );
      if (time != null) {
        onChanged(time);
      }
    },
  );
}

class SoftTable extends StatelessWidget {
  const SoftTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.selectedRows = const {},
    this.onSelectionChanged,
    this.onRowTap,
    this.loading = false,
    this.errorText,
    this.onRetry,
    this.page = 1,
    this.pageSize,
    this.onPageChanged,
    this.maxHeight = 360,
    this.maxCellWidth = 240,
  }) : assert(page >= 1),
       assert(pageSize == null || pageSize > 0),
       assert(maxHeight > 0),
       assert(maxCellWidth > 0);
  final List<String> columns;
  final List<List<String>> rows;
  final int? sortColumnIndex, pageSize;
  final int page;
  final bool sortAscending, loading;
  final void Function(int, bool)? onSort;
  final Set<int> selectedRows;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final ValueChanged<int>? onRowTap, onPageChanged;
  final String? errorText;
  final VoidCallback? onRetry;
  final double maxHeight, maxCellWidth;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Semantics(
        liveRegion: true,
        label: softText(context, 'Loading table'),
        child: SoftSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: MediaQuery.disableAnimationsOf(context) ? 1 : null,
              ),
              const SizedBox(height: 16),
              Text(softText(context, 'Loading…')),
            ],
          ),
        ),
      );
    }
    if (errorText != null) {
      return SoftSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              child: SoftAlert(
                title: softText(context, 'Unable to load table'),
                tone: SoftTone.error,
                message: errorText!,
              ),
            ),
            if (onRetry != null)
              SoftButton(label: softText(context, 'Retry'), onPressed: onRetry),
          ],
        ),
      );
    }
    if (rows.isEmpty || columns.isEmpty) {
      return SoftEmptyState(
        title: softText(context, 'No rows'),
        description: softText(context, 'Change filters or add a record.'),
      );
    }
    assert(
      sortColumnIndex == null ||
          (sortColumnIndex! >= 0 && sortColumnIndex! < columns.length),
    );
    final pages = pageSize == null ? 1 : (rows.length / pageSize!).ceil();
    final current = page.clamp(1, pages);
    final begin = pageSize == null ? 0 : (current - 1) * pageSize!;
    final end = pageSize == null
        ? rows.length
        : (begin + pageSize!).clamp(0, rows.length);
    final visible = [for (var i = begin; i < end; i++) i];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                headingRowColor: WidgetStatePropertyAll(
                  SoftDesign.of(context).tint,
                ),
                showCheckboxColumn: onSelectionChanged != null,
                onSelectAll: onSelectionChanged == null
                    ? null
                    : (v) {
                        final next = Set<int>.of(selectedRows);
                        v == true
                            ? next.addAll(visible)
                            : next.removeAll(visible);
                        onSelectionChanged!(next);
                      },
                columns: [
                  for (var i = 0; i < columns.length; i++)
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxCellWidth),
                        child: Text(
                          columns[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onSort: onSort,
                    ),
                ],
                rows: [
                  for (final i in visible)
                    DataRow.byIndex(
                      index: i,
                      selected: selectedRows.contains(i),
                      onSelectChanged:
                          onSelectionChanged == null && onRowTap == null
                          ? null
                          : (v) {
                              if (onSelectionChanged != null) {
                                final next = Set<int>.of(selectedRows);
                                v == true ? next.add(i) : next.remove(i);
                                onSelectionChanged!(next);
                              }
                              onRowTap?.call(i);
                            },
                      cells: [
                        for (var c = 0; c < columns.length; c++)
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: maxCellWidth,
                              ),
                              child: Text(
                                c < rows[i].length ? rows[i][c] : '—',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (pageSize != null && pages > 1) ...[
          const SizedBox(height: 12),
          SoftPagination(page: current, pages: pages, onChanged: onPageChanged),
        ],
      ],
    );
  }
}

class SoftSteps extends StatelessWidget {
  const SoftSteps({
    super.key,
    required this.labels,
    required this.current,
    required this.onSelected,
  });
  final List<String> labels;
  final int current;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      labels.length,
      (i) => SoftListTile(
        title: labels[i],
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: i <= current
              ? SoftDesign.of(context).tint
              : SoftDesign.of(context).background,
          child: i < current
              ? const SoftIcon(Icons.check, size: 16)
              : Text(
                  softText(context, '${i + 1}'),
                  style: const TextStyle(fontSize: 12),
                ),
        ),
        onTap: () => onSelected(i),
      ),
    ),
  );
}

Future<T?> _showFieldPicker<T>(
  BuildContext context,
  Widget Function(BuildContext) builder,
) {
  final design = SoftDesign.of(context);
  return showDialog<T>(
    context: context,
    builder: (context) => design.copyWith(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            child: SoftSurface(
              padding: const EdgeInsets.all(20),
              child: Builder(builder: builder),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _pickerActions(BuildContext context, VoidCallback confirm) => Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    SoftButton(
      label: softText(context, '取消'),
      onPressed: () => Navigator.pop(context),
    ),
    const SizedBox(width: 12),
    SoftButton(
      label: softText(context, '确定'),
      primary: true,
      onPressed: confirm,
    ),
  ],
);

Widget _timeColumn(
  BuildContext context,
  String label,
  int value,
  ValueChanged<int> change,
) => SoftSurface(
  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  tone: SoftTone.primary,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        softText(context, label),
        style: Theme.of(context).textTheme.labelMedium,
      ),
      IconButton(
        tooltip: softText(context, '增加{label}', {
          'label': softText(context, label),
        }),
        onPressed: () => change(1),
        icon: const SoftIcon(Icons.keyboard_arrow_up_rounded),
      ),
      Semantics(
        liveRegion: true,
        label: '$label $value',
        child: ExcludeSemantics(
          child: AnimatedSwitcher(
            duration: SoftMotion.duration(context, 150),
            child: Text(
              value.toString().padLeft(2, '0'),
              key: ValueKey(value),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamily: SoftTokens.monoFontFamily,
                fontFamilyFallback: const ['monospace'],
                fontSize: 36,
              ),
            ),
          ),
        ),
      ),
      IconButton(
        tooltip: softText(context, '减少{label}', {
          'label': softText(context, label),
        }),
        onPressed: () => change(-1),
        icon: const SoftIcon(Icons.keyboard_arrow_down_rounded),
      ),
    ],
  ),
);
