import 'dart:async';

import 'studio.dart';
import 'palette.dart';
import 'refinements.dart';
import 'collection.dart';
import 'state_lab.dart';
import 'gradient_lab.dart';
import 'showcase_header.dart';

import 'package:flutter/material.dart';
import 'package:luma_ui/luma_ui.dart';

void main() => runApp(
  ListenableBuilder(
    listenable: Listenable.merge([galleryAccent, galleryThemeMode]),
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: galleryThemeMode.value,
      theme: SoftTokens.theme(
        fontFamily: SoftTokens.fontFamily,
        accentColor: galleryAccent.value,
      ),
      darkTheme: SoftTokens.theme(
        fontFamily: SoftTokens.fontFamily,
        accentColor: galleryAccent.value,
        brightness: Brightness.dark,
      ),
      home: const Gallery(),
    ),
  ),
);

class Gallery extends StatefulWidget {
  const Gallery({super.key});
  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int segment = 0, nav = 0;
  bool saved = false, notifications = false;
  String? file;
  double progress = 0;
  Timer? timer;
  final messages = <String>[];
  void notice(String text) => showSoftToast(context, text);
  void upload() {
    timer?.cancel();
    setState(() {
      file = 'Design system.fig';
      progress = 0;
    });
    timer = Timer.periodic(const Duration(milliseconds: 180), (t) {
      setState(() {
        progress = (progress + .1).clamp(0, 1);
      });
      if (progress >= 1) {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget specimen(String number, String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 16),
        child: Row(
          children: [
            Text(
              number,
              style: TextStyle(
                color: SoftDesign.of(context).muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      child,
    ],
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShowcaseHeader(),
                  const GradientLab(),
                  const NewCollection(),
                  const RefinedComponents(),
                  const StateLab(),
                  const ComponentStudio(),
                  const SizedBox(height: 56),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 1050
                          ? 3
                          : constraints.maxWidth >= 680
                          ? 2
                          : 1;
                      final width =
                          (constraints.maxWidth - (columns - 1) * 28) / columns;
                      final cards = [
                        specimen(
                          '01',
                          'PROFILE',
                          ProfileCard(
                            name: 'Chloe Harrison',
                            role: 'Product designer',
                            tags: const ['Figma', 'UX Design'],
                            bookmarked: saved,
                            onBookmark: () => setState(() => saved = !saved),
                            onContact: () => notice(
                              'Contact action · connect your own callback',
                            ),
                          ),
                        ),
                        specimen(
                          '02',
                          'ANALYTICS',
                          AnalyticsCard(
                            title: 'Members',
                            value: ['1,930', '1,204', '726'][segment],
                            selected: segment,
                            onChanged: (i) => setState(() => segment = i),
                            values: <List<double>>[
                              [15.0, 24, 22, 36, 31, 49, 58, 56, 68],
                              [12.0, 20, 32, 26, 41, 48, 39, 60, 65],
                              [8.0, 12, 11, 22, 32, 29, 43, 52, 56],
                            ][segment],
                          ),
                        ),
                        specimen(
                          '03',
                          'UPLOAD / SIMULATION',
                          UploadCard(
                            fileName: file,
                            progress: progress,
                            onSelect: upload,
                            onCancel: file == null
                                ? null
                                : () {
                                    timer?.cancel();
                                    setState(() {
                                      file = null;
                                      progress = 0;
                                    });
                                  },
                          ),
                        ),
                        specimen(
                          '04',
                          'CONVERSATION',
                          SoftSurface(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'A little conversation',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 24),
                                const ChatBubble(
                                  message: 'Hi! Shall we keep the whole library in the same visual language?',
                                  outgoing: true,
                                ),
                                const ChatBubble(
                                  message: 'Absolutely. One palette, one corner system, and a softer touch.',
                                ),
                                ...messages.map(
                                  (m) => ChatBubble(message: m, outgoing: true),
                                ),
                                const SizedBox(height: 8),
                                SoftComposer(
                                  onSend: (m) =>
                                      setState(() => messages.add(m)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        specimen(
                          '05',
                          'NAVIGATION & CONTROLS',
                          Column(
                            children: [
                              SoftNavigation(
                                selected: nav,
                                onChanged: (i) => setState(() => nav = i),
                              ),
                              const SizedBox(height: 24),
                              SoftSurface(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ['Home', 'Chat', 'Team', 'Tasks'][nav],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'The same details, at every scale.',
                                    ),
                                    const SizedBox(height: 24),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SoftButton(
                                          label: 'Primary',
                                          primary: true,
                                          onPressed: () =>
                                              notice('Primary action'),
                                        ),
                                        SoftButton(
                                          label: 'Secondary',
                                          onPressed: () =>
                                              notice('Secondary action'),
                                        ),
                                        const SoftButton(label: 'Disabled'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        specimen(
                          '06',
                          'EMPTY STATE',
                          SoftEmptyState(
                            title: notifications
                                ? 'You’re all set'
                                : 'A quieter kind of update',
                            description: notifications
                                ? 'Notification preference saved for this demo.'
                                : 'Keep the updates you care about\nclose at hand.',
                            actionLabel: notifications
                                ? 'Reset'
                                : 'Set up updates',
                            onAction: () =>
                                setState(() => notifications = !notifications),
                          ),
                        ),
                      ];
                      return Wrap(
                        spacing: 28,
                        runSpacing: 36,
                        children: cards
                            .map((c) => SizedBox(width: width, child: c))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 64),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'SOFT GLASS  /  01     ·     All content and data shown here are demo examples.',
                    style: TextStyle(
                      fontSize: 11,
                      color: SoftDesign.of(context).muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
