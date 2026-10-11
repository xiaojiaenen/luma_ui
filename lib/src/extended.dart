import 'package:flutter/material.dart';

import 'components.dart';
import 'controls.dart';
import 'design.dart';
import 'motion.dart';
import 'charts.dart';
import 'layouts.dart';

class SoftSearchField extends StatelessWidget {
  const SoftSearchField({
    super.key,
    required this.onChanged,
    this.hint = 'Search components',
    this.controller,
  });
  final ValueChanged<String> onChanged;
  final String hint;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) => SoftTextField(
    label: hint,
    controller: controller,
    prefixIcon: Icons.search_rounded,
    onChanged: onChanged,
  );
}

class SoftNumberField extends StatelessWidget {
  const SoftNumberField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });
  final int value, min, max;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Decrease',
        onPressed: value > min ? () => onChanged(value - 1) : null,
        icon: const Icon(Icons.remove),
      ),
      Expanded(
        child: AnimatedSwitcher(
          duration: SoftMotion.duration(context),
          child: Text(
            '$value',
            key: ValueKey(value),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      IconButton(
        tooltip: 'Increase',
        onPressed: value < max ? () => onChanged(value + 1) : null,
        icon: const Icon(Icons.add),
      ),
    ],
  );
}

class SoftOtpField extends StatefulWidget {
  const SoftOtpField({super.key, required this.onCompleted, this.length = 6});
  final int length;
  final ValueChanged<String> onCompleted;
  @override
  State<SoftOtpField> createState() => _SoftOtpFieldState();
}

class _SoftOtpFieldState extends State<SoftOtpField> {
  String value = '';
  @override
  Widget build(BuildContext context) => TextField(
    keyboardType: TextInputType.number,
    maxLength: widget.length,
    onChanged: (v) {
      setState(() => value = v);
      if (v.length == widget.length && RegExp(r'^\d+$').hasMatch(v)) {
        widget.onCompleted(v);
      }
    },
    decoration: InputDecoration(
      labelText: 'Verification code',
      counterText: '${value.length} / ${widget.length}',
      filled: true,
      fillColor: SoftDesign.of(context).surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
        borderSide: BorderSide.none,
      ),
    ),
    style: const TextStyle(letterSpacing: 8, fontSize: 22),
  );
}

class SoftRating extends StatelessWidget {
  const SoftRating({super.key, required this.value, this.onChanged});
  final int value;
  final ValueChanged<int>? onChanged;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => IconButton(
          tooltip: 'Rate ${i + 1}',
          onPressed: onChanged == null ? null : () => onChanged!(i + 1),
          icon: Icon(
            i < value ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < value
                ? SoftDesign.of(context).ink
                : SoftDesign.of(context).muted,
          ),
        ),
      ),
    ),
  );
}

class SoftRangeSlider extends StatelessWidget {
  const SoftRangeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });
  final RangeValues value;
  final double min, max;
  final ValueChanged<RangeValues> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('${value.start.round()} — ${value.end.round()}'),
      RangeSlider(
        values: value,
        min: min,
        max: max,
        activeColor: SoftDesign.of(context).accent,
        inactiveColor: SoftDesign.of(context).background,
        onChanged: onChanged,
      ),
    ],
  );
}

class SoftColorPicker extends StatelessWidget {
  const SoftColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.colors,
  });
  final Color value;
  final List<Color> colors;
  final ValueChanged<Color> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: colors
        .map(
          (c) => IconButton(
            tooltip: 'Color ${c.toARGB32().toRadixString(16)}',
            onPressed: () => onChanged(c),
            style: IconButton.styleFrom(
              backgroundColor: c,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SoftDesign.of(context).radius,
                ),
              ),
            ),
            icon: Icon(
              c == value ? Icons.check : Icons.circle_outlined,
              color: SoftDesign.of(context).ink,
              size: 18,
            ),
          ),
        )
        .toList(),
  );
}

class SoftChipGroup extends StatelessWidget {
  const SoftChipGroup({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(
      labels.length,
      (i) => FilterChip(
        label: Text(labels[i], maxLines: 1, overflow: TextOverflow.ellipsis),
        selected: selected.contains(i),
        selectedColor: SoftDesign.of(context).tint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
        ),
        onSelected: (v) {
          final next = {...selected};
          v ? next.add(i) : next.remove(i);
          onChanged(next);
        },
      ),
    ),
  );
}

class SoftFilterBar extends StatelessWidget {
  const SoftFilterBar({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SoftButton(
            label: labels[i],
            primary: selected == i,
            onPressed: () => onChanged(i),
          ),
        ),
      ),
    ),
  );
}

class SoftIcon extends StatelessWidget {
  const SoftIcon(this.icon, {super.key, this.size = 24});
  final IconData icon;
  final double size;
  @override
  Widget build(BuildContext context) =>
      Icon(icon, size: size, color: SoftDesign.of(context).ink);
}

class SoftIconGrid extends StatelessWidget {
  const SoftIconGrid({super.key, required this.icons, this.onSelected});
  final Map<String, IconData> icons;
  final ValueChanged<String>? onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: icons.entries
        .map(
          (e) => IconButton(
            tooltip: e.key,
            onPressed: onSelected == null ? null : () => onSelected!(e.key),
            icon: SoftIcon(e.value),
            style: IconButton.styleFrom(
              backgroundColor: SoftDesign.of(context).tint,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SoftDesign.of(context).radius,
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}

class SoftAvatarGroup extends StatelessWidget {
  const SoftAvatarGroup({super.key, required this.names, this.maxVisible = 4});
  final List<String> names;
  final int maxVisible;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      ...names.take(maxVisible).map((n) => SoftAvatar(label: n, size: 36)),
      if (names.length > maxVisible) SoftTag('+${names.length - maxVisible}'),
    ],
  );
}

class SoftStatusDot extends StatelessWidget {
  const SoftStatusDot({super.key, required this.label, this.active = true});
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AnimatedContainer(
        duration: SoftMotion.duration(context),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: active
              ? SoftDesign.of(context).accent
              : SoftDesign.of(context).muted,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ],
  );
}

class SoftDivider extends StatelessWidget {
  const SoftDivider({super.key, this.label});
  final String? label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      if (label != null) ...[
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    ],
  );
}

class SoftKbd extends StatelessWidget {
  const SoftKbd(this.keys, {super.key});
  final String keys;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: SoftDesign.of(context).surface,
      border: Border.all(color: SoftDesign.of(context).background),
      borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
    ),
    child: Text(
      keys,
      style: const TextStyle(
        fontFamily: SoftTokens.monoFontFamily,
        fontFamilyFallback: [SoftTokens.fontFamily, 'monospace'],
        fontSize: 12,
      ),
    ),
  );
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.child,
    this.action,
  });
  final String title, subtitle;
  final IconData icon;
  final Widget? child, action;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: SoftDesign.of(context).ink),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
        if (child != null) ...[const SizedBox(height: 20), child!],
        if (action != null) ...[const SizedBox(height: 20), action!],
      ],
    ),
  );
}

class SoftFileTile extends StatelessWidget {
  const SoftFileTile({
    super.key,
    required this.name,
    required this.details,
    this.onRemove,
  });
  final String name, details;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) => SoftListTile(
    title: name,
    subtitle: details,
    leading: const Icon(Icons.description_outlined),
    trailing: onRemove == null
        ? null
        : IconButton(
            tooltip: 'Remove file',
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
          ),
  );
}

class SoftImageTile extends StatelessWidget {
  const SoftImageTile({super.key, required this.caption, this.image});
  final String caption;
  final ImageProvider? image;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
        child: AspectRatio(
          aspectRatio: 1.618,
          child: image == null
              ? ColoredBox(
                  color: SoftDesign.of(context).tint,
                  child: const Icon(Icons.landscape_outlined, size: 48),
                )
              : Image(image: image!, fit: BoxFit.cover),
        ),
      ),
      const SizedBox(height: 12),
      Text(caption, maxLines: 2, overflow: TextOverflow.ellipsis),
    ],
  );
}

class SoftAudioPlayer extends StatelessWidget {
  const SoftAudioPlayer({
    super.key,
    required this.title,
    required this.artist,
    required this.playing,
    required this.onToggle,
    this.progress = 0,
    this.onNext,
  });
  final String title, artist;
  final bool playing;
  final VoidCallback onToggle;
  final VoidCallback? onNext;
  final double progress;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 88,
          alignment: Alignment.center,
          child: Icon(
            Icons.graphic_eq_rounded,
            size: 56,
            color: Color.lerp(
              SoftDesign.of(context).accent,
              SoftDesign.of(context).ink,
              .3,
            ),
          ),
        ),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(artist, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 16),
        SoftProgress(value: progress),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: playing ? 'Pause' : 'Play',
              onPressed: onToggle,
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
            IconButton(
              tooltip: 'Next track',
              onPressed: onNext,
              icon: const Icon(Icons.skip_next_rounded),
            ),
          ],
        ),
      ],
    ),
  );
}

class SoftVideoTile extends StatelessWidget {
  const SoftVideoTile({
    super.key,
    required this.title,
    required this.duration,
    required this.onPlay,
  });
  final String title, duration;
  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context) => _Summary(
    title: title,
    subtitle: duration,
    icon: Icons.videocam_outlined,
    child: AspectRatio(
      aspectRatio: 1.618,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: SoftDesign.of(context).tint,
          borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
        ),
        child: Center(
          child: IconButton(
            tooltip: 'Play video',
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded, size: 36),
          ),
        ),
      ),
    ),
  );
}

class SoftWeatherCard extends StatelessWidget {
  const SoftWeatherCard({
    super.key,
    this.gradient,
    this.gradientPreset = SoftGradientPreset.lagoon,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });
  final String city, temperature, condition, humidity;
  final Gradient? gradient;
  final SoftGradientPreset gradientPreset;
  @override
  Widget build(BuildContext context) => SoftSurface(
    tone: SoftTone.secondary,
    gradientPreset: gradientPreset,
    gradient: gradient,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(city, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  temperature,
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w300,
                    color: SoftDesign.of(context).ink,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.wb_sunny_outlined,
              size: 48,
              color: Color.lerp(
                SoftDesign.of(context).roles.tertiary,
                SoftDesign.of(context).ink,
                .3,
              ),
            ),
          ],
        ),
        Text(condition, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 24),
        SoftDetailRows(
          values: {'Humidity': humidity, 'Forecast': 'Local demo'},
        ),
      ],
    ),
  );
}

class SoftFlightTicket extends StatelessWidget {
  const SoftFlightTicket({
    super.key,
    this.gradient,
    this.gradientPreset = SoftGradientPreset.peach,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.gate,
  });
  final String from, to, departure, arrival, gate;
  final Gradient? gradient;
  final SoftGradientPreset gradientPreset;
  @override
  Widget build(BuildContext context) => SoftSurface(
    tone: SoftTone.tertiary,
    gradientPreset: gradientPreset,
    gradient: gradient,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                from,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.flight_takeoff_rounded),
            ),
            Expanded(
              child: Text(
                to,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SoftDivider(label: 'BOARDING PASS'),
        SoftDetailRows(
          values: {'Departure': departure, 'Arrival': arrival, 'Gate': gate},
        ),
      ],
    ),
  );
}

class SoftHealthCard extends StatelessWidget {
  const SoftHealthCard({
    super.key,
    required this.heartRate,
    required this.distance,
    required this.calories,
    required this.hours,
  });
  final String heartRate, distance, calories, hours;
  @override
  Widget build(BuildContext context) => _Summary(
    title: '$heartRate BPM',
    subtitle: 'Heart rate · demo data',
    icon: Icons.favorite_border_rounded,
    child: Column(
      children: [
        const SoftLineChart(values: [.2, .4, .35, .8, .3, .5, .4]),
        SoftDetailRows(
          values: {
            'Distance': distance,
            'Calories': calories,
            'Stand hours': hours,
          },
        ),
      ],
    ),
  );
}

class SoftProductCard extends StatelessWidget {
  const SoftProductCard({
    super.key,
    required this.title,
    required this.price,
    this.onAdd,
  });
  final String title, price;
  final VoidCallback? onAdd;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.618,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: SoftDesign.of(context).tint,
              borderRadius: BorderRadius.circular(
                SoftDesign.of(context).radius,
              ),
            ),
            child: const Icon(Icons.checkroom_outlined, size: 52),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(price, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            IconButton(
              tooltip: 'Add to cart',
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    ),
  );
}

class SoftPriceCard extends StatelessWidget {
  const SoftPriceCard({
    super.key,
    required this.plan,
    required this.price,
    required this.features,
    this.onChoose,
  });
  final String plan, price;
  final List<String> features;
  final VoidCallback? onChoose;
  @override
  Widget build(BuildContext context) => _Summary(
    title: plan,
    subtitle: price,
    icon: Icons.workspace_premium_outlined,
    action: SoftButton(
      label: 'Choose plan',
      primary: true,
      onPressed: onChoose,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}

class SoftOrderCard extends StatelessWidget {
  const SoftOrderCard({
    super.key,
    required this.number,
    required this.status,
    required this.total,
  });
  final String number, status, total;
  @override
  Widget build(BuildContext context) => _Summary(
    title: number,
    subtitle: status,
    icon: Icons.shopping_bag_outlined,
    child: SoftDetailRows(values: {'Total': total, 'Status': status}),
  );
}

class SoftCouponCard extends StatelessWidget {
  const SoftCouponCard({
    super.key,
    required this.code,
    required this.description,
    this.onApply,
  });
  final String code, description;
  final VoidCallback? onApply;
  @override
  Widget build(BuildContext context) => _Summary(
    title: code,
    subtitle: description,
    icon: Icons.local_offer_outlined,
    action: SoftButton(label: 'Apply coupon', onPressed: onApply),
  );
}

class SoftAddressCard extends StatelessWidget {
  const SoftAddressCard({
    super.key,
    required this.name,
    required this.address,
    this.onEdit,
  });
  final String name, address;
  final VoidCallback? onEdit;
  @override
  Widget build(BuildContext context) => _Summary(
    title: name,
    subtitle: address,
    icon: Icons.location_on_outlined,
    action: SoftButton(label: 'Edit address', onPressed: onEdit),
  );
}

class SoftContactCard extends StatelessWidget {
  const SoftContactCard({
    super.key,
    required this.name,
    required this.role,
    this.onMessage,
    this.onCall,
  });
  final String name, role;
  final VoidCallback? onMessage, onCall;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SoftAvatar(label: name, size: 64),
        const SizedBox(height: 16),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(role, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SoftButton(
              label: 'Message',
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: onMessage,
            ),
            SoftButton(
              label: 'Call',
              icon: Icons.call_outlined,
              onPressed: onCall,
            ),
          ],
        ),
      ],
    ),
  );
}

class SoftNotificationCard extends StatelessWidget {
  const SoftNotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.onRead,
  });
  final String title, message, time;
  final VoidCallback? onRead;
  @override
  Widget build(BuildContext context) => _Summary(
    title: title,
    subtitle: message,
    icon: Icons.notifications_none_rounded,
    action: onRead == null
        ? null
        : SoftButton(label: 'Mark as read', onPressed: onRead),
    child: Text(time, style: const TextStyle(fontSize: 11)),
  );
}

class SoftStorageCard extends StatelessWidget {
  const SoftStorageCard({
    super.key,
    required this.used,
    required this.capacity,
    required this.fraction,
  });
  final String used, capacity;
  final double fraction;
  @override
  Widget build(BuildContext context) => _Summary(
    title: 'Storage',
    subtitle: '$used / $capacity',
    icon: Icons.cloud_outlined,
    child: SoftProgress(value: fraction),
  );
}

class SoftDownloadCard extends StatelessWidget {
  const SoftDownloadCard({
    super.key,
    required this.name,
    required this.progress,
    this.onCancel,
  });
  final String name;
  final double progress;
  final VoidCallback? onCancel;
  @override
  Widget build(BuildContext context) => _Summary(
    title: name,
    subtitle: '${(progress * 100).round()}% downloaded',
    icon: Icons.download_outlined,
    action: SoftButton(label: 'Cancel download', onPressed: onCancel),
    child: SoftProgress(value: progress),
  );
}

class SoftTaskCard extends StatelessWidget {
  const SoftTaskCard({
    super.key,
    required this.title,
    required this.due,
    required this.done,
    required this.onChanged,
  });
  final String title, due;
  final bool done;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SoftCheckbox(
          label: title,
          value: done,
          onChanged: (v) => onChanged(v!),
        ),
        SoftStatusDot(label: due, active: !done),
      ],
    ),
  );
}

class SoftChecklist extends StatelessWidget {
  const SoftChecklist({
    super.key,
    required this.items,
    required this.checked,
    required this.onChanged,
  });
  final List<String> items;
  final Set<int> checked;
  final ValueChanged<Set<int>> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      items.length,
      (i) => SoftCheckbox(
        label: items[i],
        value: checked.contains(i),
        onChanged: (v) {
          final next = {...checked};
          v! ? next.add(i) : next.remove(i);
          onChanged(next);
        },
      ),
    ),
  );
}

class SoftKanbanColumn extends StatelessWidget {
  const SoftKanbanColumn({super.key, required this.title, required this.tasks});
  final String title;
  final List<Widget> tasks;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SoftTag('${tasks.length}'),
          ],
        ),
        const SizedBox(height: 16),
        ...tasks.map(
          (t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: t),
        ),
      ],
    ),
  );
}

class SoftActivityFeed extends StatelessWidget {
  const SoftActivityFeed({super.key, required this.events});
  final Map<String, String> events;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: events.entries
        .map(
          (e) => SoftListTile(
            title: e.value,
            subtitle: e.key,
            leading: const Icon(Icons.history_rounded),
          ),
        )
        .toList(),
  );
}

class SoftCommentCard extends StatelessWidget {
  const SoftCommentCard({
    super.key,
    required this.author,
    required this.text,
    required this.time,
    this.onReply,
  });
  final String author, text, time;
  final VoidCallback? onReply;
  @override
  Widget build(BuildContext context) => _Summary(
    title: author,
    subtitle: text,
    icon: Icons.chat_bubble_outline_rounded,
    action: onReply == null
        ? null
        : SoftButton(label: 'Reply', onPressed: onReply),
    child: Text(time, style: const TextStyle(fontSize: 11)),
  );
}

class SoftEmptySearch extends StatelessWidget {
  const SoftEmptySearch({super.key, required this.query, this.onClear});
  final String query;
  final VoidCallback? onClear;
  @override
  Widget build(BuildContext context) => SoftEmptyState(
    title: 'No results',
    description:
        'No matches for ${query.length > 80 ? '${query.substring(0, 80)}…' : query}',
    actionLabel: 'Clear search',
    onAction: onClear,
  );
}

class SoftErrorState extends StatelessWidget {
  const SoftErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => SoftEmptyState(
    title: 'Something needs attention',
    description: message,
    actionLabel: 'Try again',
    onAction: onRetry,
  );
}

class SoftOfflineBanner extends StatelessWidget {
  const SoftOfflineBanner({super.key, this.onReconnect});
  final VoidCallback? onReconnect;
  @override
  Widget build(BuildContext context) => _Summary(
    title: 'You are offline',
    subtitle: 'Changes will sync when you reconnect.',
    icon: Icons.wifi_off_rounded,
    action: SoftButton(label: 'Reconnect', onPressed: onReconnect),
  );
}

class SoftConnectionCard extends StatelessWidget {
  const SoftConnectionCard({
    super.key,
    required this.name,
    required this.connected,
    required this.onChanged,
  });
  final String name;
  final bool connected;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => _Summary(
    title: name,
    subtitle: connected ? 'Connected' : 'Disconnected',
    icon: Icons.bluetooth_rounded,
    child: SoftSwitch(
      label: 'Connection',
      value: connected,
      onChanged: onChanged,
    ),
  );
}

class SoftPermissionCard extends StatelessWidget {
  const SoftPermissionCard({
    super.key,
    required this.title,
    required this.description,
    this.onAllow,
    this.onDecline,
  });
  final String title, description;
  final VoidCallback? onAllow, onDecline;
  @override
  Widget build(BuildContext context) => _Summary(
    title: title,
    subtitle: description,
    icon: Icons.shield_outlined,
    action: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SoftButton(label: 'Not now', onPressed: onDecline),
        SoftButton(label: 'Allow', primary: true, onPressed: onAllow),
      ],
    ),
  );
}

class SoftAIToolCall extends StatelessWidget {
  const SoftAIToolCall({
    super.key,
    required this.tool,
    required this.detail,
    required this.running,
  });
  final String tool, detail;
  final bool running;
  @override
  Widget build(BuildContext context) => SoftAlert(
    tone: running ? SoftTone.ai : SoftTone.success,
    title: tool,
    message: detail,
    icon: running
        ? Icons.hourglass_top_rounded
        : Icons.check_circle_outline_rounded,
  );
}

class SoftAISourceCard extends StatelessWidget {
  const SoftAISourceCard({
    super.key,
    required this.title,
    required this.source,
    required this.onOpen,
  });
  final String title, source;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => SoftListTile(
    title: title,
    subtitle: source,
    leading: const Icon(Icons.link_rounded),
    trailing: const Icon(Icons.arrow_outward, size: 18),
    onTap: onOpen,
  );
}

class SoftAIModelSelect extends StatelessWidget {
  const SoftAIModelSelect({
    super.key,
    required this.models,
    required this.value,
    required this.onChanged,
  });
  final Map<String, String> models;
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => SoftSelect<String>(
    label: 'AI model',
    items: models,
    value: value,
    onChanged: (v) {
      if (v != null) {
        onChanged(v);
      }
    },
  );
}

class SoftTokenUsage extends StatelessWidget {
  const SoftTokenUsage({super.key, required this.used, required this.limit});
  final int used, limit;
  @override
  Widget build(BuildContext context) => _Summary(
    title: 'Context usage',
    subtitle: '$used / $limit tokens',
    icon: Icons.data_usage_rounded,
    child: SoftProgress(value: limit <= 0 ? 0 : (used / limit).clamp(0, 1)),
  );
}

class SoftAILoadingCard extends StatelessWidget {
  const SoftAILoadingCard({super.key});
  @override
  Widget build(BuildContext context) => SoftSurface(
    tone: SoftTone.ai,
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SoftSkeleton(height: 18, width: 140),
        SizedBox(height: 16),
        SoftSkeleton(height: 12),
        SizedBox(height: 10),
        SoftSkeleton(height: 12),
        SizedBox(height: 10),
        SoftSkeleton(height: 12, width: 180),
      ],
    ),
  );
}

class SoftReviewCard extends StatelessWidget {
  const SoftReviewCard({
    super.key,
    required this.author,
    required this.text,
    required this.rating,
  });
  final String author, text;
  final int rating;
  @override
  Widget build(BuildContext context) => _Summary(
    title: author,
    subtitle: text,
    icon: Icons.rate_review_outlined,
    child: SoftRating(value: rating),
  );
}

class SoftQuote extends StatelessWidget {
  const SoftQuote({super.key, required this.text, required this.author});
  final String text, author;
  @override
  Widget build(BuildContext context) =>
      _Summary(title: text, subtitle: author, icon: Icons.format_quote_rounded);
}

class SoftMetricCard extends StatelessWidget {
  const SoftMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    required this.trend,
  });
  final String label, value, change;
  final List<double> trend;
  @override
  Widget build(BuildContext context) => SoftSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(change, maxLines: 1, overflow: TextOverflow.ellipsis),
        SoftLineChart(values: trend),
      ],
    ),
  );
}

class SoftPasswordStrength extends StatelessWidget {
  const SoftPasswordStrength({super.key, required this.password});
  final String password;
  int get score => [
    password.length >= 8,
    RegExp(r'[A-Z]').hasMatch(password),
    RegExp(r'\d').hasMatch(password),
    RegExp(r'[^\w]').hasMatch(password),
  ].where((v) => v).length;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      SoftProgress(value: score / 4),
      const SizedBox(height: 8),
      Text(
        ['Add a password', 'Weak', 'Fair', 'Good', 'Strong'][score],
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

class SoftSegmentedProgress extends StatelessWidget {
  const SoftSegmentedProgress({
    super.key,
    required this.steps,
    required this.current,
  });
  final int steps, current;
  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      steps,
      (i) => Expanded(
        child: AnimatedContainer(
          duration: SoftMotion.duration(context),
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: i < current
                ? SoftDesign.of(context).accent
                : SoftDesign.of(context).background,
            borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
          ),
        ),
      ),
    ),
  );
}

class SoftNotificationPreference extends StatelessWidget {
  const SoftNotificationPreference({
    super.key,
    required this.email,
    required this.push,
    required this.onEmailChanged,
    required this.onPushChanged,
  });
  final bool email, push;
  final ValueChanged<bool> onEmailChanged, onPushChanged;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SoftSwitch(
        label: 'Email updates',
        value: email,
        onChanged: onEmailChanged,
      ),
      SoftSwitch(
        label: 'Push notifications',
        value: push,
        onChanged: onPushChanged,
      ),
    ],
  );
}

class SoftCommandItem extends StatelessWidget {
  const SoftCommandItem({
    super.key,
    required this.label,
    required this.shortcut,
    required this.onTap,
  });
  final String label, shortcut;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SoftListTile(
    title: label,
    leading: const Icon(Icons.terminal_rounded),
    trailing: SoftKbd(shortcut),
    onTap: onTap,
  );
}

class SoftUploadZone extends StatelessWidget {
  const SoftUploadZone({
    super.key,
    required this.onSelect,
    this.label = 'Choose a file',
  });
  final VoidCallback onSelect;
  final String label;
  @override
  Widget build(BuildContext context) => SoftPress(
    child: Material(
      color: SoftDesign.of(context).tint,
      borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(SoftDesign.of(context).radius),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 36),
              const SizedBox(height: 16),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
