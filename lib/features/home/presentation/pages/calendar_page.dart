import 'dart:math' as math;

import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.header});

  final Widget header;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const _categories = [
    '🪐  Gökyüzü',
    '🪷  Güzellik ve Bakım',
    '🌙  Rüya',
    '💰  Para',
    '💞  Yakınlık',
    '🩺  Sağlık',
    '💼  Kariyer',
  ];

  late DateTime _visibleMonth;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  bool get _canGoPrev => _visibleMonth.month > 1;
  bool get _canGoNext => _visibleMonth.month < 12;

  void _goPrevMonth() {
    if (!_canGoPrev) {
      return;
    }
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goNextMonth() {
    if (!_canGoNext) {
      return;
    }
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  void _openDayDetail(DateTime date) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _DailyMoonDetailPage(initialDate: date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        '${_monthName(_visibleMonth.month)} ${_visibleMonth.year}';
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final leadingEmpty = firstDay.weekday - 1;

    final cells = <Widget>[];
    for (var i = 0; i < leadingEmpty; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
      final phase = _moonPhaseInfo(date);
      final isToday = _isSameDate(date, DateTime.now());
      final marker = _selectedCategoryIndex == 0
          ? _DayMarker.none
          : _markerForDate(date, _selectedCategoryIndex);
      final showSkyDetail =
          _selectedCategoryIndex == 0 && _shouldShowSkyDetail(date);
      cells.add(
        _CalendarDayCell(
          day: day,
          phaseEmoji: phase.emoji,
          detailText: _phaseDetail(date, phase),
          isToday: isToday,
          marker: marker,
          showDetailText: showSkyDetail,
          onTap: () => _openDayDetail(date),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.header,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == _selectedCategoryIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selected
                            ? const Color(0xFFF3DAA2)
                            : const Color(0x14122A5C),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFF3DAA2)
                              : const Color(0xFFB58A5A),
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected
                              ? const Color(0xFF1B1F3B)
                              : const Color(0xFFECDCC0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x540B0F2A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          monthLabel,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _canGoPrev ? _goPrevMonth : null,
                          icon: const Icon(Icons.chevron_left),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: _canGoNext ? _goNextMonth : null,
                          icon: const Icon(Icons.chevron_right),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        children: [
                          _WeekdayHeader('P'),
                          _WeekdayHeader('S'),
                          _WeekdayHeader('Ç'),
                          _WeekdayHeader('P'),
                          _WeekdayHeader('C'),
                          _WeekdayHeader('C'),
                          _WeekdayHeader('P'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxHeight < 430;
                          final rows = (cells.length / 7).ceil();
                          final mainSpacing = compact ? 2.0 : 4.0;
                          final crossSpacing = compact ? 2.0 : 4.0;
                          final mainExtent =
                              (constraints.maxHeight -
                                  (rows - 1) * mainSpacing) /
                              rows;

                          return GridView.builder(
                            itemCount: cells.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: mainSpacing,
                                  crossAxisSpacing: crossSpacing,
                                  mainAxisExtent: mainExtent,
                                ),
                            itemBuilder: (context, index) {
                              final cell = cells[index];
                              if (cell is _CalendarDayCell) {
                                return _CalendarDayCell(
                                  day: cell.day,
                                  phaseEmoji: cell.phaseEmoji,
                                  detailText: cell.detailText,
                                  isToday: cell.isToday,
                                  marker: cell.marker,
                                  showDetailText: cell.showDetailText,
                                  compact: compact,
                                  onTap: cell.onTap,
                                );
                              }
                              return cell;
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x44051534),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _selectedCategoryIndex == 0
                          ? Row(
                              children: [
                                Text(
                                  '* Ay fazı verisi (yaklaşık)',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                Text(
                                  _moonPhaseInfo(DateTime.now()).name,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFFF3DAA2),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                _LegendItem(
                                  color: const Color(0xFF7CF6B2),
                                  label: 'Olumlu Günler',
                                ),
                                const SizedBox(width: 18),
                                _LegendItem(
                                  color: const Color(0xFFFF6B7A),
                                  label: 'Zorlayıcı Etki',
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 108),
          ],
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.phaseEmoji,
    required this.detailText,
    required this.isToday,
    required this.marker,
    required this.showDetailText,
    this.onTap,
    this.compact = false,
  });

  final int day;
  final String phaseEmoji;
  final String detailText;
  final bool isToday;
  final _DayMarker marker;
  final bool showDetailText;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showDetail =
            showDetailText && constraints.maxHeight >= (compact ? 40 : 56);
        final showMarker = marker != _DayMarker.none;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isToday
                    ? Border.all(color: const Color(0xFFF3DAA2), width: 1.2)
                    : null,
                color: isToday ? const Color(0x2AF3DAA2) : Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(
                vertical: compact ? 1 : 2,
                horizontal: compact ? 1 : 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$day',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: compact ? 10.5 : 13,
                    ),
                  ),
                  SizedBox(height: compact ? 0.5 : 1),
                  Text(
                    phaseEmoji,
                    style: TextStyle(fontSize: compact ? 13 : 15),
                  ),
                  if (showDetail || showMarker)
                    SizedBox(height: compact ? 0.5 : 2),
                  if (showDetail) ...[
                    SizedBox(height: compact ? 0.4 : 1.0),
                    SizedBox(
                      height: compact ? 8 : 10,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          detailText,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white70,
                                fontSize: compact ? 6.2 : 7.2,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ],
                  if (showMarker) ...[
                    SizedBox(height: compact ? 0.4 : 1.0),
                    Icon(
                      Icons.diamond,
                      size: compact ? 5 : 6,
                      color: marker == _DayMarker.positive
                          ? const Color(0xFF7CF6B2)
                          : const Color(0xFFFF6B7A),
                    ),
                  ],
                  if (showDetail || showMarker)
                    SizedBox(height: compact ? 0.3 : 0.8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DailyMoonDetailPage extends StatefulWidget {
  const _DailyMoonDetailPage({required this.initialDate});

  final DateTime initialDate;

  @override
  State<_DailyMoonDetailPage> createState() => _DailyMoonDetailPageState();
}

class _DailyMoonDetailPageState extends State<_DailyMoonDetailPage> {
  late DateTime _selectedDate;
  final Set<_DetailCategory> _expanded = <_DetailCategory>{};
  final PageController _beautyPageController = PageController();
  int _beautyPageIndex = 0;

  static const List<_DetailCategory> _orderedCategories = [
    _DetailCategory.beauty,
    _DetailCategory.dream,
    _DetailCategory.career,
    _DetailCategory.money,
    _DetailCategory.health,
    _DetailCategory.intimacy,
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
  }

  @override
  void dispose() {
    _beautyPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phase = _moonPhaseInfo(_selectedDate);
    final phaseTitle = phase.name;
    final subtitle = _dailyMoonSubtitle(_selectedDate);
    final dayData = _buildDailyTexts(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0B2A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1040), Color(0xFF130D35), Color(0xFF0D0B2A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phaseTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: const Color(0xFFE8D3B0),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: _TopMoonDaySelector(
                  selectedDate: _selectedDate,
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                      _beautyPageIndex = 0;
                    });
                    _beautyPageController.jumpToPage(0);
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  children: [
                    for (final category in _orderedCategories) ...[
                      if (category == _DetailCategory.career) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Doğum Haritana Özel Etkiler',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      _InsightExpandableCard(
                        category: category,
                        pages: dayData[category] ?? const [],
                        expanded: _expanded.contains(category),
                        beautyPageController: _beautyPageController,
                        beautyPageIndex: _beautyPageIndex,
                        onBeautyPageChanged: (index) {
                          setState(() => _beautyPageIndex = index);
                        },
                        onTap: () {
                          setState(() {
                            if (_expanded.contains(category)) {
                              _expanded.remove(category);
                            } else {
                              _expanded.add(category);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopMoonDaySelector extends StatefulWidget {
  const _TopMoonDaySelector({
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<_TopMoonDaySelector> createState() => _TopMoonDaySelectorState();
}

class _TopMoonDaySelectorState extends State<_TopMoonDaySelector> {
  static const int _kInitialPage = 10000;

  late final PageController _controller;
  late int _anchorPage;
  late DateTime _anchorDate;

  @override
  void initState() {
    super.initState();
    _anchorPage = _kInitialPage;
    _anchorDate = widget.selectedDate;
    _controller = PageController(
      initialPage: _anchorPage,
      viewportFraction: 0.34,
    );
  }

  @override
  void didUpdateWidget(covariant _TopMoonDaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDate(widget.selectedDate, _anchorDate)) {
      _anchorDate = widget.selectedDate;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    final delta = page - _anchorPage;
    if (delta == 0) {
      return;
    }

    final newDate = _anchorDate.add(Duration(days: delta));
    setState(() {
      _anchorPage = page;
      _anchorDate = newDate;
    });
    widget.onDateChanged(newDate);
  }

  DateTime _dateForIndex(int index) {
    return _anchorDate.add(Duration(days: index - _anchorPage));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _MoonArcPainter()),
            ),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: 200000,
            onPageChanged: _handlePageChanged,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final date = _dateForIndex(index);

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  var pageValue = _anchorPage.toDouble();
                  if (_controller.hasClients &&
                      _controller.position.hasContentDimensions) {
                    pageValue = _controller.page ?? _anchorPage.toDouble();
                  }

                  final signed = (index - pageValue).clamp(-1.6, 1.6);
                  final normalized = (signed / 1.6).toDouble();
                  final arcLift = (1 - (normalized * normalized)).clamp(
                    0.0,
                    1.0,
                  );
                  final moonSize = 82 + (30 * arcLift);
                  final isCenter = signed.abs() < 0.45;
                  final yOffset = 42 - (22 * arcLift);

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Column(
                      children: [
                        _MoonDisk(
                          date: date,
                          size: moonSize,
                          highlighted: isCenter,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _dateLabel(date),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: isCenter
                                    ? const Color(0xFFEFD39A)
                                    : Colors.white70,
                                fontWeight: isCenter
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoonArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.68)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.48,
        size.width,
        size.height * 0.68,
      );

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..color = Colors.white.withValues(alpha: 0.14);
    canvas.drawPath(path, glow);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.28);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoonDisk extends StatelessWidget {
  const _MoonDisk({
    required this.date,
    required this.size,
    this.highlighted = false,
  });

  final DateTime date;
  final double size;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final phase = _moonPhaseInfo(date);
    final illumination = phase.illumination.clamp(0.0, 1.0).toDouble();
    final waxing = phase.fraction < 0.5;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: highlighted ? 20 : 10,
            spreadRadius: highlighted ? 1 : 0,
            color: Colors.white.withValues(alpha: highlighted ? 0.24 : 0.12),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          painter: _MoonDiskPainter(illumination: illumination, waxing: waxing),
        ),
      ),
    );
  }
}

class _MoonDiskPainter extends CustomPainter {
  const _MoonDiskPainter({required this.illumination, required this.waxing});

  final double illumination;
  final bool waxing;

  /// Ay'ın aydınlanmayan (karanlık) tarafının yolunu oluşturur.
  /// Daire yayı + terminatör elips yayı birleşiminden oluşur.
  Path _buildDarkPath(Offset center, double radius) {
    final circleRect = Rect.fromCircle(center: center, radius: radius);
    // Terminatör elipsinin yatay yarı ekseni; hilal→0.5→dolunay arası değişir
    final a = math.max(0.5, radius * (1.0 - 2.0 * illumination).abs());
    final terminatorRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy),
      width: a * 2,
      height: radius * 2.04,
    );

    final path = Path();
    if (waxing) {
      // Karanlık taraf SOL — dairenin sol yayı (saat yönü tersine, -π)
      path.arcTo(circleRect, -math.pi / 2, -math.pi, false);
      if (illumination <= 0.5) {
        // Hilal: terminatör sağa kıvrılır (saç yayı saat yönü tersine)
        path.arcTo(terminatorRect, math.pi / 2, -math.pi, false);
      } else {
        // Şişkin: terminatör sola kıvrılır (saat yönüyle)
        path.arcTo(terminatorRect, math.pi / 2, math.pi, false);
      }
    } else {
      // Karanlık taraf SAĞ (küçülen) — dairenin sağ yayı (saat yönünde, +π)
      path.arcTo(circleRect, -math.pi / 2, math.pi, false);
      if (illumination <= 0.5) {
        // Hilal: terminatör sola kıvrılır (saat yönüyle)
        path.arcTo(terminatorRect, math.pi / 2, math.pi, false);
      } else {
        // Şişkin: terminatör sağa kıvrılır (saat yönü tersine)
        path.arcTo(terminatorRect, math.pi / 2, -math.pi, false);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2;

    // BlendMode.clear'ın çalışabilmesi için ayrı bir katman açıyoruz
    canvas.saveLayer(rect, Paint());

    // Ay yüzey dokusu
    final base = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.28, -0.22),
        radius: 1.08,
        colors: [Color(0xFFF4F4F4), Color(0xFFB8B8B8), Color(0xFF6C6C6C)],
        stops: [0.0, 0.68, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, base);

    // Kraterler
    final craterRandom = math.Random(9327);
    for (var i = 0; i < 64; i++) {
      final angle = craterRandom.nextDouble() * 2 * math.pi;
      final distance = math.sqrt(craterRandom.nextDouble()) * radius * 0.92;
      final craterCenter = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      final craterR = radius * (0.025 + craterRandom.nextDouble() * 0.085);

      final crater = Paint()
        ..color = Color.lerp(
          const Color(0xFF848484),
          const Color(0xFFD5D5D5),
          craterRandom.nextDouble(),
        )!.withValues(alpha: 0.20 + craterRandom.nextDouble() * 0.20)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(craterCenter, craterR, crater);

      final rim = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = craterR * 0.16
        ..color = Colors.white.withValues(alpha: 0.06);
      canvas.drawCircle(craterCenter, craterR * 0.95, rim);
    }

    // Kenar karartma (limb darkening)
    final limbDarkening = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.1, 0.1),
        radius: 1.0,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.28)],
        stops: const [0.68, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, limbDarkening);

    // Karanlık tarafı şeffaf yaparak arka planın görünmesini sağla
    if (illumination < 0.001) {
      // Yeni Ay: tüm disk karanlık
      canvas.drawCircle(center, radius, Paint()..blendMode = BlendMode.clear);
    } else if (illumination < 0.999) {
      final darkPath = _buildDarkPath(center, radius);
      canvas.drawPath(darkPath, Paint()..blendMode = BlendMode.clear);

      // Terminatör boyunca yumuşak parıltı (geçişi pürüzsüzleştirir)
      final a = math.max(0.5, radius * (1.0 - 2.0 * illumination).abs());
      final terminatorRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy),
        width: a * 2,
        height: radius * 2.04,
      );
      canvas.drawOval(
        terminatorRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.10
          ..color = Colors.white.withValues(alpha: 0.22)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.07),
      );
    }

    // Speküler parlaklık
    final specular = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.5, -0.5),
        radius: 0.85,
        colors: [Color(0x55FFFFFF), Color(0x00FFFFFF)],
      ).createShader(rect);
    canvas.drawCircle(center, radius, specular);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MoonDiskPainter oldDelegate) {
    return oldDelegate.illumination != illumination ||
        oldDelegate.waxing != waxing;
  }
}

enum _DetailCategory { beauty, dream, career, money, health, intimacy }

class _InsightExpandableCard extends StatelessWidget {
  const _InsightExpandableCard({
    required this.category,
    required this.pages,
    required this.expanded,
    required this.onTap,
    required this.beautyPageController,
    required this.beautyPageIndex,
    required this.onBeautyPageChanged,
  });

  final _DetailCategory category;
  final List<String> pages;
  final bool expanded;
  final VoidCallback onTap;
  final PageController beautyPageController;
  final int beautyPageIndex;
  final ValueChanged<int> onBeautyPageChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = _cardScheme(category);
    final title = _categoryTitle(category);
    final icon = _categoryIcon(category);
    final isBeauty = category == _DetailCategory.beauty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: scheme,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFECCB8E),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFECCB8E),
                      size: 34,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 10),
                  Container(height: 1.2, color: const Color(0xFFD5C099)),
                  const SizedBox(height: 14),
                  if (isBeauty && pages.length > 1)
                    SizedBox(
                      height: 256,
                      child: PageView.builder(
                        controller: beautyPageController,
                        itemCount: pages.length,
                        onPageChanged: onBeautyPageChanged,
                        itemBuilder: (context, index) => SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            pages[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      pages.isEmpty ? '' : pages.first,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (isBeauty && pages.length > 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < pages.length; i++)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: i == beautyPageIndex
                                  ? const Color(0xFFEFD39A)
                                  : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _categoryTitle(_DetailCategory category) {
  switch (category) {
    case _DetailCategory.beauty:
      return 'Güzellik ve Bakım';
    case _DetailCategory.dream:
      return 'Rüya';
    case _DetailCategory.career:
      return 'Kariyer';
    case _DetailCategory.money:
      return 'Para';
    case _DetailCategory.health:
      return 'Sağlık';
    case _DetailCategory.intimacy:
      return 'Yakınlık';
  }
}

String _categoryIcon(_DetailCategory category) {
  switch (category) {
    case _DetailCategory.beauty:
      return '🪷';
    case _DetailCategory.dream:
      return '🌙';
    case _DetailCategory.career:
      return '🪐';
    case _DetailCategory.money:
      return '💰';
    case _DetailCategory.health:
      return '🩺';
    case _DetailCategory.intimacy:
      return '💞';
  }
}

List<Color> _cardScheme(_DetailCategory category) {
  switch (category) {
    case _DetailCategory.beauty:
      return const [Color(0xCC3D2060), Color(0xBB2A1650), Color(0xAA1C1040)];
    case _DetailCategory.dream:
      return const [Color(0xCC5A1E7A), Color(0xBB421560), Color(0xAA2B0E45)];
    case _DetailCategory.career:
      return const [Color(0xCC1E2B6A), Color(0xBB162055), Color(0xAA0E1640)];
    case _DetailCategory.money:
      return const [Color(0xCC5E1A7A), Color(0xBB461260), Color(0xAA2E0D45)];
    case _DetailCategory.health:
      return const [Color(0xCC2A1E7A), Color(0xBB1E1660), Color(0xAA140E45)];
    case _DetailCategory.intimacy:
      return const [Color(0xCC6A1A5A), Color(0xBB501045), Color(0xAA350B32)];
  }
}

String _dailyMoonSubtitle(DateTime date) {
  const signs = [
    'Koç',
    'Boğa',
    'İkizler',
    'Yengeç',
    'Aslan',
    'Başak',
    'Terazi',
    'Akrep',
    'Yay',
    'Oğlak',
    'Kova',
    'Balık',
  ];
  final seed = date.year * 10000 + date.month * 100 + date.day;
  final sign = signs[seed % signs.length];
  final house = (seed % 12) + 1;
  return 'Ay $sign burcunda, senin $house. evinde.';
}

Map<_DetailCategory, List<String>> _buildDailyTexts(DateTime date) {
  // Birbirine yakın tarihlerin benzer içerik üretmemesi için seed'i
  // bit-karıştırma (avalanche) hash'inden geçiriyoruz.
  final rawSeed = date.year * 10000 + date.month * 100 + date.day;

  int hashSeed(int v, int salt) {
    var h = ((v ^ (salt * 2654435761)) & 0x7FFFFFFF);
    h ^= h >> 15;
    h = (h * 0x2c1b3c6d) & 0x7FFFFFFF;
    h ^= h >> 12;
    h = (h * 0x297a2d39) & 0x7FFFFFFF;
    h ^= h >> 15;
    return h.abs();
  }

  String buildParagraph(List<String> pool, int salt, {int sentenceCount = 5}) {
    final random = math.Random(hashSeed(rawSeed, salt));
    final indices = List<int>.generate(pool.length, (i) => i)..shuffle(random);
    final count = sentenceCount.clamp(1, pool.length);
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      if (i > 0) buffer.write(' ');
      buffer.write(pool[indices[i]]);
    }
    return buffer.toString();
  }

  const beautyPool = [
    'Cildin bugün ay ışığını daha iyi tutuyor; yumuşak dokunuşlar sana iyi gelir.',
    'Saç ve tırnak bakımında sade ürünler kullanmak enerjini dengeleyebilir.',
    'Ilık suyla yapılan kısa bir bakım rutini, yüz kaslarını gevşetip canlılık sağlar.',
    'Bugün ağır işlemler yerine nazik arındırma ve nem takviyesi daha verimli olur.',
    'Boyun ve omuz bölgesine yapacağın küçük bir masaj, yüzüne de parlaklık taşır.',
    'Ayna karşısında geçireceğin birkaç sakin dakika, öz bakım motivasyonunu artırır.',
    'Doğal yağlar (argan, jojoba) bu dönemde cildi besleyip parlatmak için etkilidir.',
    'Makyaj fırçalarını temizlemek cilt sağlığını doğrudan etkiler; bu adımı atlamak istemezsin.',
    'Gece uyumadan önce cildi nemlenme ve yenilenme sürecine hazırlamak sabah ışıltısını artırır.',
    'Göz altı şişliği için dinlendirici bir göz maskesi bu dönemde iyi hissettirir.',
    'Tırnak sağlığı için B7 vitamini (biyotin) zengini besinlere yönelmek destekleyicidir.',
    'Yanlardan değil uçtan uca saç fırçalamak kırılmayı önler ve saçı güçlendirir.',
    'Güneş kremi, hava bulutlu da olsa her gün takılması gereken bir bakım adımıdır.',
    'Mineral içeriği yüksek su içmek cildin nem bariyerini güçlendirir.',
    'Hafta bir kez derin saç maskesi uygulamak ısı hasarını onarır ve parlaklık katar.',
    'Retinol içeren ürünleri akşam uygulamak, gün içi güneş hassasiyetinden korur.',
    'Saç derisi masajı kan dolaşımını artırarak saç uzamasını destekler.',
    'Alerjik reaksiyon veren bir ürünü bırakmakta gecikmemek cilde yapılabilecek en iyi iyiliktir.',
    'Cilt bakım ürünlerini en basit haline indirgemek bazen en hızlı iyileşmeyi gösterir.',
    'A vitamini açısından yoğun turuncu sebzeler tüketmek cildin iç parlaklığını destekler.',
    'Boyama veya fön ısısı sonrası saça soğuk su uygulaması parlaklık sağlar.',
    'Uyurken ipek yastık kılıfı kullanmak yüz kırışıklıklarını ve saç kırıklarını azaltır.',
    'Şeker tüketimini kısmak akne ve cilt solgunluğunu birkaç haftada belirgin şekilde iyileştirir.',
    'Gül kuşburnu yağı leke ve ton eşitsizliğinin giderilmesinde destekleyici rol oynar.',
    'Tuz banyosu yapmak deriyi yumuşatırken ağrılı kasları da rahatlatır.',
    'Niasinamid içeren serumlar gözenek görünümünü ve yağlanmayı düzenler.',
    'C vitamini serumu sabah rutinine dahil etmek kolajen üretimini destekler.',
    'Cilt tipine uygun temizleyici seçmek diğer tüm adımların etkinliğini artırır.',
    'Yüz jimi egzersizleri çene ve yanak kaslarını tonlar ve hatları yumuşatır.',
    'Kaş sağlığı için hint yağı ya da E vitamini uygulamak büyümeyi teşvik eder.',
    'Dudak balsamı uygulamak için en doğru an uyku öncesi ve sabah uyanıştır.',
    'Ultra-işlenmiş gıdaları azaltmak ciltte iltihaplanmayı ve kızarıklığı azaltır.',
    'Parmak uçlarıyla yapılan hafif vurma teknikleri yüzde lenf dolaşımını uyarır.',
    'Temiz bir havlu kullanmak cilt bakımındaki en sık atlanan ama en etkili hijyen adımıdır.',
    'Aydınlatıcıyı burun köprüsüne ve elmaç kemiklerine uygulamak doğal bir ışık etkisi yaratır.',
    'Yumuşak peeling hareketleri döngüsel değil çizgisel yapılırsa cilt tahriş olmaz.',
    'Arındırıcı kil maskesi haftada bir uygulanırsa yüz yağını dengeler ve gözenekleri sıkılaştırır.',
    'Kuru fırçalama (dry brushing) cildi uyarır ve cilt dokusunu pürüzsüzleştirir.',
    'Boyalı saçta şelasyon içeren şampuan mineral birikimini gidererek rengi canlı tutar.',
    'Kafein içerikli göz kremleri sabah rutininde koyu halkalar ve şişlik için hızlı etki sağlar.',
    'Fondöten tutucular (setting spray) sıcak ya da nemli günlerde makyajı sabitle tutar.',
    'Kaş şekillenirken doğal hattı korumak yüze en uyumlu çerçeveyi kazandırır.',
    'Deodorant yerine doğal koku nötralleyicileri tercih etmek hassas cilt için daha iyi sonuç verir.',
    'Cilt bakım ürünlerini buzdolabında saklamak hem tazeliği hem de sürüldüğünde ferahlığı artırır.',
    'Düzenli manikür hem tırnak sağlığını hem de özgüven hissini güçlendirir.',
    'Saç uçlarını düzenli kesmek kırık uçların yukarı çıkmasını önler ve saçı sağlıklı tutar.',
    'Gece bakım rutinini bir ritüel olarak görmek, bunu sürdürülebilir vz keyifli kılar.',
    'İpek saç bandı kullanmak uyku sırasında saçın sürtünmesini azaltır.',
    'Boyunsuz bir peeling, deri yüzeyindeki donuk hücreleri kaldırarak ürün emilimini artırır.',
    'Sabah soğuk su ile yüz yıkamak gözenekleri sıkılaştırır ve uyanışı hızlandırır.',
  ];

  const dreamPool = [
    'Rüyaların bugün bilinçaltındaki yarım kalan konuları sembollerle tamamlamaya çalışabilir.',
    'Gece gördüğün imgeler ilk bakışta karışık olsa da sabah kısa notlar almak iyi gelir.',
    'Ay enerjisi zihnini daha duyarlı yaptığı için sezgilerin normalden güçlü çalışır.',
    'Rahatsız eden bir rüya görürsen onu bir mesaj gibi ele alıp korku yerine anlam arayabilirsin.',
    'Uyku öncesi ekran ışığını azaltmak ve nefes egzersizi yapmak daha berrak rüyalar getirir.',
    'Bugün görülen olumlu rüyalar, niyetlerini netleştirmen için sana küçük ipuçları verebilir.',
    'Tekrarlayan bir rüya görmek, zihninin çözüme kavuşturmak istediği bir konuyu işaret eder.',
    'Rüya günlüğü tutmak zamanla sembolik bir dil oluşturur ve sezgisel anlama kolaylaşır.',
    'Uyumadan önce rehberlik almak istediğini niyet etmek, rüyaları yönlendirdiği bilinmektedir.',
    'Su elementinin rüyalarda belirmesi duygusal bir akış ve değişimle ilgili mesaj taşıyabilir.',
    'Rüyada uçmak genellikle özgürlük hissi ve kısıtlardan sıyrılma arzusunu simgeler.',
    'Bilinçdışının bir mesajı olarak değerlendirilen rüyalar terapötik değer taşır.',
    'Korku temalı rüyalar güvenlik ve kontrol ihtiyacını yansıtıyor olabilir.',
    'Rüyalardaki eski ev ya da okul gibi aşina mekânlar kimlik ve kök duygusunu temsil edebilir.',
    'Canlı renkli rüyalar genellikle yoğun duygusal deneyimlerin ya da güçlü niyetlerin işareti olabilir.',
    'Bir duygusal kırılımı rüyada yeniden yaşamak, o olayın sinir sistemindeki izini hafifletir.',
    'Uyumadan önce lavanta aroması kullanmak daha huzurlu rüya örüntüleri oluşturabilir.',
    'Rüyalarda tanımadığın insanlar bazen gerçek hayatta bastırılan kişilik yönlerini temsil edebilir.',
    'Yetersiz uyku sonrası derin uyku evresinde yoğunlaşan rüyalar daha çarpıcı olur.',
    'Bir rüyanın ilk ve son karesini hatırlamak, ortadaki ayrıntıları da geri çağırmanı kolaylaştırır.',
    'Rüyalarda tekrarlayan hayvan imgeleri, içgüdüsel bir mesajı barındırıyor olabilir.',
    'Sabah saatlerinde (06-08) gerçekleşen REM döngüleri rüyaları daha uzun ve net hale getirir.',
    'Bilinçli rüya (lucid dreaming) pratiği yapmak, uyku sırasında yaratıcı problem çözme alanı sağlar.',
    'B6 vitamini bazı araştırmalarda rüyaların daha canlı ve anlaşılır hale gelmesini destekliyor.',
    'Ağlayarak uyanan kişiler, kabusların aslında duygusal arındırma işlevi gördüğünü öğrenebilir.',
    'Okyanus ya da geniş su kütleleri rüyada bilinçdışının derinliğini ve potansiyelini simgeler.',
    'Bir hayali ölüm ya da kayıp rüyası çoğunlukla gerçek bir kayıp değil, bir dönüşümü temsil eder.',
    'Öfke ile uyumak, rüya içeriğini olumsuz biçimlendirme eğilimini artırır.',
    'Zihinsel çözülme gerektiren kararlar bazen rüya sırasında daha berrak bir perspektif kazanır.',
    'Uyku sırasında işitilen sesler rüyaya entegre olabilir; bu beynin normalleştirme refleksidir.',
    'Rüya imgelerini sembolik değil literal yorumlamak çoğu zaman anlam kaybına yol açar.',
    'REM uykusu süresince beyin, gündüz öğrenilen bilgileri uzun süreli belleğe aktarır.',
    'Uyku öncesi yüksek şekerli gıdalar kan şekerindeki dalgalanma yüzünden gece uyanmaya yol açabilir.',
    'Rüyanda birinin sana sarılması bazen kendine şefkat ve güvenlik ihtiyacını yansıtıyor olabilir.',
    'Haiku ya da kısa şiirle rüyayı kayıt altına almak, dil ötesi katmanları da korur.',
    'Rüyalarda kapılar yeni fırsatlara ya da kapalı tutmak istediğin alanlara işaret edebilir.',
    'Yaratıcı insanların daha canlı rüya gördüğü bilinir; sanatsal aktivite bu kapıyı aralar.',
    'Bir rüyanın sana nasıl hissettirdiği, içeriğinden daha fazla anlam taşıyabilir.',
    'Sabah alarmını kademeli bir sesle kurmak, REM evresinden düzgün çıkmanı sağlar.',
    'Farkındalık meditasyonu düzenli yapıldığında rüya netliği ve hatırlama giderek artar.',
    'Karanlık ve sessiz uyku ortamı REM süresini ve kalitesini önemli ölçüde artırır.',
    'Hafıza pekişmesi REM\'de gerçekleştiğinden, uyku kesintisi bilgilerin kalıcılığını zayıflatır.',
    'Bir rüyayı başkasıyla paylaşmak farklı yorumlarla gizli sembolleri açığa çıkarabilir.',
    'Eski fotoğraflara ya da anı nesnelerine bakmak nostalji içerikli rüyaları tetikleyebilir.',
    'Güven temelli rüyalar (kahraman, rehber figür) iç güce duyulan ihtiyacı yansıtır.',
    'Taşıt kullanmak rüyalarda hayatın yönü ve kontrolünü sembolik olarak temsil edebilir.',
    'Yatmadan önce bir soruyu kafana taşımak bazen sabah beklenmedik bir cevap getirebilir.',
    'Rüyalarını merakla karşılamak, savunmacı değil keşifçi bir iç yolculuk sunar.',
    'Yoga nidra gibi derin gevşeme pratikleri bilinçli rüya eşiğini yakınlaştırır.',
    'Gündüz mini dinlenmeler (NREM şekerleme) hafızayı tazeleyip gece rüya kalitesini artırır.',
  ];

  const careerPool = [
    'İş tarafında bugün iletişim trafiği hızlanıyor; net cümleler kurmak avantaj sağlar.',
    'Planlarını küçük adımlara bölmek, yoğunluğu daha rahat yönetmene yardım eder.',
    'Kısa bir odak molası, günün ikinci yarısında üretkenliğini belirgin şekilde artırır.',
    'Yeni bir fikir paylaşmadan önce ana çerçeveyi yazıya dökmen ikna gücünü yükseltir.',
    'Toplantılarda sakin ama kararlı duruşun, sorumluluk alanını büyütebilir.',
    'Bugün aldığın geri bildirimleri savunmacı değil merakla dinlemek seni ileriye taşır.',
    'Erteleme eğilimini fark ettiğinde en küçük adımı atmak büyük tıkanıklıkları çözer.',
    'Ekibindeki birine söyleyeceğin içten bir teşekkür iş birliği enerjisini canlandırır.',
    'Zaman dilimleme yöntemi bugün odaklanmayı ve bitirilebilirlik hissini kolaylaştırabilir.',
    'Bir konuyu farklı bir bakış açısıyla yeniden çerçevelemek beklenmedik çözümler açar.',
    'Bugün güçlü sorular sormak, doğru cevaplardan daha değerli sonuçlar üretebilir.',
    'Öncelik sıralamanı gözden geçirmek, gün sonunda bitirme hissini artırır.',
    'Başkasından yardım istemek yetersizlik değil, farkındalık göstergesidir.',
    'Proje belgelerini düzenlemek, ileride saatlerini kurtaracak bir yatırımdır.',
    'Kısa ve net iletiler yazmak yanıt almanı hızlandırır ve yanlış anlaşılmayı önler.',
    'Belirsizlik içinde bile "şimdi ne adım atabilirim?" sorusu ilerlemeyi mümkün kılar.',
    'Farklı departmanlarla köprü kurmak bugün yeni fırsatlar doğurabilir.',
    'Toplantıdan önce iki dakika derin nefes almak zihnini netleştirir.',
    'Çalışma alanını toplamak, dikkat dağınıklığını önemli ölçüde azaltır.',
    'Bir görevi yetkilendirmek hem seni rahatlatır hem de ekibi geliştirir.',
    'Müşteri beklentilerini açıkça sormak, yanlış anlaşılmaları başından önler.',
    'Zor bir karar önünde yazarak düşünmek netlik ve objektivite sağlar.',
    'Kendi enerjini izleyerek en verimli saatlerini yüksek öncelikli işe ayır.',
    'Tamamladığın her küçük görevi kaydetmek motivasyonu canlı tutar.',
    'Kısa vadeli hedefle uzun vadeli vizyon arasındaki dengeyi gözden geçirmek değerlidir.',
    'Rakiplerin yerine kendi büyüme eğrine odaklanmak kalıcı başarı getirir.',
    'Konuşmadan önce bir saniye beklemek, söylediklerinin ağırlığını artırır.',
    'Yeni bir beceri kazanmaya bugün yalnızca on dakika ayırmak bile birikim yaratır.',
    'Rutinin dışına çıkan küçük bir değişiklik yaratıcı tıkanıklığı açabilir.',
    'Hedeflerini somutlaştırmak için sayısal ölçütler belirlemek odağı güçlendirir.',
    'Enerjin yüksekken en zor görevi yapmak, gün içi stresi azaltır.',
    'Bir sorunu çözmek yerine onu doğru tanımlamak çoğu zaman daha güçlü bir adımdır.',
    'İş listende "hayır" diyebileceğin bir madde var mı diye bakmak faydalı olabilir.',
    'Güven inşa etmek tutarlı küçük davranışların uzun vadeli birikiminden oluşur.',
    'Yanlış bir adımı kabul etmek güvenilirliğini düşürmez; aksine artırır.',
    'Motivasyonu beklemek yerine harekete geçmek, motivasyonu zaten doğurur.',
    'Kendi başarını duyurmayı öğrenmek kariyer görünürlüğü için kritiktir.',
    'Günü kapatırken yarınki en önce yapılacak bir işi seçmek sabahı kolaylaştırır.',
    'Zorlu bir konuşmayı yazılı taslakla hazırlamak duyguları sakinleştirir.',
    '"İyi yeter" eşiği "mükemmel" beklentisinden çoğu zaman daha işlevseldir.',
    'Kendi değerini somut örneklerle anlatmak soyut övgüden daha ikna edicidir.',
    'Olası sorunları önceden modellemek reaktif değil proaktif bir tutum kazandırır.',
    'Bugün "neden yapıyorum?" sorusu anlam duygusunu tazeler ve işi kolaylaştırır.',
    'Sessizlik toplantılarda güç göstergesi olabilir; her soruya hemen cevap vermek zorunda değilsin.',
    'Sözel iletişim yerine yazılı özet bırakmak ilerideki anlaşmazlıkları önler.',
    'Aynı masada farklı bakış açılarına sahip olmak problemi zenginleştirir ve çözümü hızlandırır.',
    'Bitirilen işlerin listesini tutmak "yeterince yapmadım" sesini susturur.',
    'Yetkinlik alanını genişletmek için düzenli okuma alışkanlığı sabırsızlığı azaltır.',
    'Günde bir kez birinin bir sorununu çözmek, seni de keyiflendiren bir etki yaratır.',
    'Çalışma temposunu ara sıra düşürmek uzun vadede verimliliği artıran stratejidir.',
    'Kişisel markana katkı yapan her küçük proje, ilerleyen dönemde birikmekte olduğunu hatırla.',
  ];

  const moneyPool = [
    'Maddi konularda bugün küçük ama düzenli adımlar büyük fark yaratabilir.',
    'Harcamalarını kategorilere ayırmak, gereksiz sızıntıları daha kolay görmeni sağlar.',
    'Anlık heves alışverişleri yerine bekleme süresi koymak bütçeyi korur.',
    'Gelir-gider notu tutmak finansal kararlarında daha özgüvenli hissettirir.',
    'Bugün uzun vadeli birikim hedefini güncellemek için uygun bir zaman.',
    'Küçük abonelikler zamanla büyük yükler oluşturur; bugün bir listeye dök.',
    'Acil durum fonu oluşturmak mali krizlerde stres düzeyini belirgin biçimde düşürür.',
    'Bir finansal hedef belirlemek her tasarruf kararında seni motive eder.',
    'Para harcamadan önce üç gün beklemek ihtiyaç-istek farkını netleştirir.',
    'Karşılaştırmalı alışveriş yapmak alışkanlık hale gelince tasarruf otomatikleşir.',
    'Bir harcama günlüğü tutmak farkındalığı artırır ve değişimi kolaylaştırır.',
    'Gelirine değil giderlerine hâkim olmak finansal özgürlüğün temel adımıdır.',
    'Düzenli küçük yatırımlar büyük miktarları birden yatırmaktan genellikle daha güvenlidir.',
    'Kredi kartı borcunu en yüksek faizliden ödemeye başlamak toplam maliyeti düşürür.',
    'Bugün bir maddi hedefi yazılı olarak belgelemek gerçekleşme ihtimalini artırır.',
    '"Kendine önce öde" prensibi tasarrufun öncelik hâline gelmesini sağlar.',
    'Fatura ödemelerini otomatikleştirmek hem geç ödeme ücretini hem stresi önler.',
    'İkinci el ya da takas seçeneklerini değerlendirmek bütçeyi esnetmenin akıllı yoludur.',
    'Vergi avantajlı hesapları erkenden açmak, uzun vadede ciddi bir fark yaratır.',
    'Finansal okuryazarlık için günde on dakika bir şey okumak disiplini besler.',
    'Para konusunda güvendiğin biriyle açık bir konuşma yapmak kör noktaları ortadan kaldırır.',
    'Emeklilik planlamasını ertelemek, her yıl bileşik faizin kaçmasına yol açar.',
    '"İhtiyacım mı var, istiyor muyum?" diye sormak alışverişi bilinçlileştirir.',
    'Hangi harcamaların gerçekten mutlu ettiğini sorgulamak bütçeyi değerlere göre düzenler.',
    'Borç yeniden yapılandırması bazen daha düşük faiz oranları elde etmeni sağlar.',
    'Gelirini tek kaynağa bağımlı bırakmak değişken dönemlerde kırılganlık yaratır.',
    'Küçük bir tutar olsa bile düzenli yatırım bileşik büyüme sayesinde zamanla katlanır.',
    'Finansal kaygı yaşandığında rakamları bir kâğıda dökmek belirsizliği azaltır.',
    'Eğlence bütçesi belirlemek suçluluk duymadan harcamana izin verir.',
    'Kriz dönemlerinde esnek bir bütçe şablonu önceden hazırlamak güvende tutar.',
    'Bir ayın en yüksek harcama kalemini bulmak genellikle büyük bir sürprize dönüşür.',
    'Yılda bir kez tüm sigorta poliçelerini gözden geçirmek gereksiz maliyetleri azaltır.',
    'Para kazandıkça harcamayı artırma eğilimini fark etmek finansal büyümeyi hızlandırır.',
    'Hediye almak için ayrı birikim hesabı açmak mevsimlik harcama şoklarını önler.',
    'İndirim avı alışveriş tuzağına dönüşmeden önce liste yapılmalıdır.',
    'Yakın çevreyle para konularında sınır koymayı öğrenmek finansal stresi azaltır.',
    'Beklenmedik gider çıkınca paniğe kapılmamak için acil fon asla ertelenmez.',
    'Ödeme planı yerine nakit fiyat teklifi almak çoğu zaman indirime kapı aralar.',
    'Sosyal medya harcamayı tetikliyorsa mola vermek sağlıklı bir sınırdır.',
    'Küçük bir bağış bile "bolluk zihniyeti" denen düşünce biçimini besler.',
    'Geçmiş hataların suçluluk yüküyle taşınması yerine çıkarılan ders ön plana alınmalıdır.',
    'Mevsimsel indirim dönemlerini önceden planlamak dürtüsel alışverişi engeller.',
    'Bir hizmetin kalitesini ücretiyle kıyaslamak, değer odaklı karar vermeyi sağlar.',
    'Para yönetimi bir yetenek değil, alışkanlık sorunudur; her gün küçük adım atılabilir.',
    'Pasif gelir kaynağı araştırmak bugün atılabilecek en ileri görüşlü adımlardan biridir.',
    'Net değerini (varlık eksi borç) hesaplamak motivasyon ve netlik sağlar.',
    'Bir işlem yaparken yasal sözleşmeleri yüzeysel okumak ilerleyen dönemde pahalıya patlar.',
    'Farklı finans kitapları okumak bakış açısını çeşitlendirir ve korku yerine strateji getirir.',
    'Yatırım getireceği düşünülen bir harcamayı gerçekten analiz etmek beklenti yönetimi sağlar.',
    'Nakit ödeme bazen sizi daha dikkatli harcamaya yönlendirdiği için karttan üstün olabilir.',
    'Birikim hesabını maaş hesabından ayırmak paraya "zaten orada" hissi vermez, korur.',
  ];

  const healthPool = [
    'Vücudun bugün ritim ve düzen istiyor; su tüketimini artırmak iyi gelebilir.',
    'Hafif tempolu yürüyüş ve esneme hareketleri enerjini dengelemene yardımcı olur.',
    'Sindirimini yormayan öğünler seçmek gün içinde zihinsel açıklık sağlar.',
    'Uyku saatini sabitlemek, hem ruh halini hem de bedensel toparlanmayı destekler.',
    'Omurga ve bel bölgesine dikkat ederek çalışmak gün sonu yorgunluğunu azaltır.',
    'Derin nefes egzersizleri anksiyete düzeyini birkaç dakika içinde düşürebilir.',
    'Öğün aralarında kısa hız kesme molaları sindirim sistemini destekler.',
    'Yoğun bir günde bile beş dakika hareket etmek uzun oturmanın etkisini kırar.',
    'Renkli sebze ve meyveleri tabağa eklemek mikro besin çeşitliliğini artırır.',
    'Kafein yerine bitki çayı tercih etmek öğleden sonra enerjini daha dengeli tutar.',
    'Gün içinde bileklerine kısa bir esneme yaptırmak eklem sağlığını korur.',
    'Ayakta çalışma ile oturarak çalışmayı dönüşümlü kullanmak bel ağrısını azaltır.',
    'İşlenmiş gıdanın bir parçasını ev yapımıyla değiştirmek beslenmeni iyileştirir.',
    'Çiğnerken hızını düşürmek hem sindirimi hem de tokluk hissini kolaylaştırır.',
    'Solunum ile uyumlu kısa bir meditasyon sempatik sinir sistemini sakinleştirir.',
    'Günde en az bir kez dışarı çıkmak D vitamini ve ruh hali dengesini destekler.',
    'Yemek saatlerini düzenlemek insülin duyarlılığını ve enerji dengesini güçlendirir.',
    'Gözlerin dijital ekrandan dinlenmesi için 20-20-20 kuralını uygulamak rahatlatır.',
    'Stres altında kasılan çene ve boyun kaslarına sahip çıkmak migreni önleyebilir.',
    'Elleri düzenli yıkamak enfeksiyon riskini azaltan en basit ve etkili alışkanlıktır.',
    'Protein ağırlıklı bir kahvaltı öğleden sonraki enerji düşüşünü belirgin biçimde azaltır.',
    'Düzenli kan tahlilleri, fark edilmeden ilerleyen eksiklikleri erken dönemde gösterir.',
    'Nefes tekniklerini öğrenmek, panik anında en hızlı ulaşılabilecek araçtır.',
    'Şeker içeriği yüksek atıştırmalıklar yerine ceviz ya da badem tercih etmek enerjiyi stabilize eder.',
    'Uyumadan önce ekranları kapatmak melatonin salgısını destekler ve uykuya dalmayı kolaylaştırır.',
    'Boyun kaslarını gevşeten kısa egzersizler ofis ortamında bile uygulanabilir.',
    'Yeterli magnezyum almak kas kramplarını ve gece uyanmalarını azaltır.',
    'Düzenli aerobik egzersiz beyin plastisitesini artıran hormonlar salgılatır.',
    'Güneş kremini yıl boyunca sürmek deri yaşlanmasını geciktiren en basit önlemdir.',
    'Bacaklarını sarkıtarak uzun süre oturmak yerine ayak desteği kullanmak dolaşımı artırır.',
    'Sabah rutinine kısa bir esneme eklemek gün içi hareket motivasyonunu artırır.',
    'Yürüyüşlerde telefona değil çevreye odaklanmak hem zihin hem göz sağlığını destekler.',
    'Doğa seslerini dinlemek stres hormonlarını düşüren etkin bir dinlenme yöntemidir.',
    'Çay, kahve gibi diüretiklerin ardından ekstra su içmek dehidrasyon riskini azaltır.',
    'Yaratıcı bir uğraşla zihni meşgul etmek bilişsel sağlığı ve psikolojik direnci destekler.',
    'Sırt ağrısı kronikleşmeden postür egzersizlerine başlamak uzun vadeli rahatlama sağlar.',
    'Sağlığa yatırım bugün küçük değişikliklerle başlar, büyük sonuçlar zamanla gelir.',
    'Düşük glisemik indeksli karbonhidratlar kan şekerini dengeli tutar ve tokluk süresini uzatır.',
    'Yılda bir tam sağlık taraması yaptırmak farkındalığı ve motivasyonu yeniler.',
    'Ev içinde bol yeşil bitki bulundurmak hava kalitesini ve ruh halini olumlu etkiler.',
    'Masaj veya kendine dokunuş kortizol düzeyini kısa sürede düşürür.',
    'Alerjik tepkileri not etmek, tetikleyicileri belirlemede doktora yardımcı olur.',
    'Öfke ve sinirliliği fark etmek, bunun arka planındaki fiziksel yorgunluğu sorgulatır.',
    'Mide yanması için asitli içeceklerden kaçınmak ilaçların önüne geçen basit bir çözümdür.',
    'Düzenli dışkılama alışkanlığını takip etmek bağırsak sağlığına dair erken sinyal verir.',
    'Beyin-beden bağını güçlendiren dans, yoga gibi aktiviteler genel refahı artırır.',
    'Soğuk hava değişimlerinde boyun ve göğsü kapalı tutmak bağışıklığı korur.',
    'Alkol tüketimini izlemek uyku kalitesini ve sabah enerjisini doğrudan etkiler.',
    'Hafta içi kısa yüzme ya da su sporları stresi fiziksel olarak boşaltır.',
    'Omega-3 zengini besinler kalp ve beyin sağlığını uzun vadede destekler.',
    'Kısa bir güneş banyosu melatonin ritmi için sirkadiyen saati ayarlamaya yardımcı olur.',
  ];

  const intimacyPool = [
    'Yakınlık alanında bugün açık ve nazik iletişim bağları güçlendirebilir.',
    'Duygularını ertelemeden ama yargılamadan ifade etmek güven hissini artırır.',
    'Birlikte geçirilen kısa ama kaliteli zaman ilişkinin tonunu yumuşatır.',
    'Beklenti yerine merakla yaklaşmak, karşılıklı anlayışı derinleştirir.',
    'Küçük bir teşekkür ya da içten bir mesaj günün enerjisini değiştirebilir.',
    'Karşındaki kişiyi gerçekten dinlemek en güçlü yakınlaştırma aracıdır.',
    'Söz vermek yerine harekete geçmek güveni inşa eder.',
    '"Nasılsın?" sorusunu ciddiye alarak sormak ilişkiyi derinleştirebilir.',
    'Anlaşmazlıkta kazanmaya değil, anlaşmaya odaklanmak bağı korur.',
    'Kısa bir kucaklaşma bile oksitosin düzeyini yükseltir ve bağı güçlendirir.',
    'Geçmiş kırgınlıkları tekrar gündeme getirmek yerine bugüne odaklanmak özgürleştirir.',
    'İlişkilerde sınır koymak uzaklaştırmaz; aksine sürdürülebilirliği artırır.',
    'Ortak bir hedef belirlemek iki kişi arasında paylaşılan anlam duygusu yaratır.',
    'Sessizce yan yana olmak da bir iletişim biçimidir ve bazen kelimelerden güçlüdür.',
    'Birinin çabasını fark edip söylemek göz ardı edilen değer duygusunu besler.',
    'Kendi ihtiyaçlarını bilmeden karşındakinin ihtiyaçlarını tahmin etmeye çalışmak yorar.',
    'Gülüşü paylaşmak, zor dönemlerde bile bağı canlı tutan en sade köprüdür.',
    'Özür dilemek güçlü bir eylemdir; yapıldığında ilişkiye taze bir sayfa açar.',
    'Empati kurmak mutlaka aynı fikirde olmak değildir; hissi anlamak yeterlidir.',
    'İlişkilerdeki tekrarlayan tartışma kalıplarını fark etmek çözümün ilk adımıdır.',
    'Bakım göstermek büyük jestler kadar küçük ve tutarlı jestlerle de olur.',
    'Duygusal kırılganlık paylaşımı güven ortamında derinlik yaratır.',
    'Birini teşvik etmek için yapabileceğin en küçük şeyi bugün yap.',
    'İlişkide sözsüz sinyalleri fark etmeyi öğrenmek anlaşılma hissini artırır.',
    'Ortak anıları hatırlamak bağı güçlendirir ve minnettarlık hissini canlandırır.',
    'Ayrı zaman geçirmek ilişkiye nefes aldırır; mesafe yakınlığı besleyebilir.',
    'Hayatının zor döneminde sana destek olan birine minnettarlığını ifade et.',
    'Duygusal güvenlik hissi insanların en dürüst hâllerinde davranmalarını sağlar.',
    'Bir arkadaşın başarısını gerçekten kutlamak hem onu hem seni büyütür.',
    'Beden dilini açık tutmak söylediklerinden bağımsız olarak sıcaklık iletir.',
    'İlişki körleştiğinde yeni bir deneyimi birlikte denemek hafızayı tazeler.',
    'Karşıdaki kişinin üzerindeki baskıyı fark etmek ve söylemek yük paylaşımı sağlar.',
    'Minnet günlüğüne bir kişiyle ilgili üç şey yazmak ilişkiyi yeni gözlerle görmeni sağlar.',
    'Anlayış arayışı yorgunken değil, dinlenmiş anında daha olumlu sonuç verir.',
    'Dürüstlük sevgi diliyle söylendiğinde ilişkiyi zedelemez; güçlendirir.',
    'Karşındaki kişi sana güveniyorsa bu güveni korumak uzun vadeli bir yatırımdır.',
    'Kişisel alana saygı duymak ilişkilerde sürdürülebilir bir bağın temelidir.',
    'Birlikte plan yapmak ortak bir gelecek hissi oluşturur ve motivasyon taşır.',
    '"Benim haklı olmam gerekmez" demek zaman zaman ilişkiye en büyük hediyedir.',
    'Tanık olmak yani birinin hikâyesini gerçekten duymak en derin bağlanma biçimlerinden biridir.',
    'Birlikte kahve ya da çay saati oluşturmak, günlük ritmin içine küçük bir bağ ritüeli katar.',
    'Karşındakinin gelecek planlarını sorup gerçekten dinlemek onun kendini değerli hissettirir.',
    'Uzun süredir küsmek yerine küçük bir hareketle ilk adımı atmak ilişkiyi iyileştirir.',
    'Çiftin ortak değerlerini konuşmak, çatışmalı anlarda ortak zemin bulunmasını kolaylaştırır.',
    'Birinin duygusunu yargılamadan geri yansıtmak (aktif dinleme) anlayışı derinleştirir.',
    'Hediye almak yerine zaman ayırmak çoğu zaman daha derin bir etki bırakır.',
    'Sosyal baskıya rağmen birinin yanında yer almak, bağın kalitesini sınar ve güçlendirir.',
    'Beraber yemek yapmak gibi sıradan paylaşımlar ilişkiye konuşma fırsatı ve sıcaklık katar.',
    '"Seni duyuyorum" demek bazen çözüm sunmaktan çok daha gerekendir.',
    'Küçük ritüeller (günaydın mesajı, gece selâmı) ilişkiyi tutarlı biçimde besler.',
    'Bir ilişkide gönüllü mi zorunlu mu tepki verdiğini fark etmek uzun vadeli kalıcılığı etkiler.',
  ];

  return {
    _DetailCategory.beauty: [
      buildParagraph(beautyPool, 11, sentenceCount: 4),
      buildParagraph(beautyPool, 37, sentenceCount: 4),
    ],
    _DetailCategory.dream: [buildParagraph(dreamPool, 59, sentenceCount: 6)],
    _DetailCategory.career: [buildParagraph(careerPool, 73, sentenceCount: 5)],
    _DetailCategory.money: [buildParagraph(moneyPool, 89, sentenceCount: 5)],
    _DetailCategory.health: [buildParagraph(healthPool, 101, sentenceCount: 5)],
    _DetailCategory.intimacy: [
      buildParagraph(intimacyPool, 131, sentenceCount: 5),
    ],
  };
}

String _dateLabel(DateTime date) {
  return '${date.day} ${_monthName(date.month)}';
}

bool _shouldShowSkyDetail(DateTime date) {
  if (date.day == 1) {
    return true;
  }
  // Örnek ekrandaki gibi her güne değil, seçili günlere detay ver.
  final seed = date.year * 10000 + date.month * 100 + date.day;
  final value = ((seed * 1103515245 + 12345) & 0x7fffffff) % 100;
  return value < 42;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.diamond, size: 8, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

enum _DayMarker { none, positive, challenging }

_DayMarker _markerForDate(DateTime date, int categoryIndex) {
  final seed =
      date.year * 10000 + date.month * 100 + date.day + (categoryIndex * 97);
  final value = ((seed * 9301 + 49297) % 233280) / 233280.0;

  // Aylar arasında farklı görünüm için deterministik-random dağılım.
  if (value < 0.34) {
    return _DayMarker.positive;
  }
  if (value < 0.58) {
    return _DayMarker.challenging;
  }
  return _DayMarker.none;
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _monthName(int month) {
  switch (month) {
    case 1:
      return 'Ocak';
    case 2:
      return 'Şubat';
    case 3:
      return 'Mart';
    case 4:
      return 'Nisan';
    case 5:
      return 'Mayıs';
    case 6:
      return 'Haziran';
    case 7:
      return 'Temmuz';
    case 8:
      return 'Ağustos';
    case 9:
      return 'Eylül';
    case 10:
      return 'Ekim';
    case 11:
      return 'Kasım';
    case 12:
      return 'Aralık';
    default:
      return '';
  }
}

String _phaseTime(DateTime date) {
  final startMinute = ((date.day * 111) + (date.month * 37)) % (24 * 60);
  String fmt(int value) {
    final h = (value ~/ 60).toString().padLeft(2, '0');
    final m = (value % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  return fmt(startMinute);
}

String _phaseDetail(DateTime date, _MoonPhaseInfo phase) {
  final hour = _phaseTime(date);
  final degree = (phase.illumination * 180).round().clamp(0, 180);
  return '$hour • $degree°';
}

_MoonPhaseInfo _moonPhaseInfo(DateTime date) {
  final baseNewMoon = DateTime.utc(2024, 1, 11, 11, 57);
  final target = DateTime.utc(date.year, date.month, date.day, 12);
  final diffDays = target.difference(baseNewMoon).inMinutes / (60 * 24);
  const cycle = 29.53058867;
  var phase = diffDays % cycle;
  if (phase < 0) {
    phase += cycle;
  }
  final fraction = phase / cycle;
  final illumination = (1 - math.cos(2 * math.pi * fraction)) / 2;

  if (fraction < 0.0625 || fraction >= 0.9375) {
    return _MoonPhaseInfo('🌑', 'Yeni Ay', illumination, fraction);
  }
  if (fraction < 0.1875) {
    return _MoonPhaseInfo('🌒', 'Büyüyen Hilal', illumination, fraction);
  }
  if (fraction < 0.3125) {
    return _MoonPhaseInfo('🌓', 'İlk Dördün', illumination, fraction);
  }
  if (fraction < 0.4375) {
    return _MoonPhaseInfo('🌔', 'Büyüyen Şişkin', illumination, fraction);
  }
  if (fraction < 0.5625) {
    return _MoonPhaseInfo('🌕', 'Dolunay', illumination, fraction);
  }
  if (fraction < 0.6875) {
    return _MoonPhaseInfo('🌖', 'Küçülen Şişkin', illumination, fraction);
  }
  if (fraction < 0.8125) {
    return _MoonPhaseInfo('🌗', 'Son Dördün', illumination, fraction);
  }
  return _MoonPhaseInfo('🌘', 'Küçülen Hilal', illumination, fraction);
}

class _MoonPhaseInfo {
  const _MoonPhaseInfo(this.emoji, this.name, this.illumination, this.fraction);

  final String emoji;
  final String name;
  final double illumination;
  final double fraction;
}
