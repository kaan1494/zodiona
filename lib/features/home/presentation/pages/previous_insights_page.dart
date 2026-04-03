import 'package:flutter/material.dart';

import '../../../../services/tarot_selection_service.dart';
import 'kozmik_rehber_tarot_chat_page.dart';

class PreviousInsightsPage extends StatefulWidget {
  const PreviousInsightsPage({super.key});

  @override
  State<PreviousInsightsPage> createState() => _PreviousInsightsPageState();
}

class _PreviousInsightsPageState extends State<PreviousInsightsPage> {
  List<TarotSelectedCard> _cards = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cards = await TarotSelectionService.getPreviousSelection();
    if (mounted) {
      setState(() {
        _cards = cards;
        _loaded = true;
      });
    }
  }

  void _showDetail(TarotSelectedCard card) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, _, _) => _InsightDetailDialog(card: card),
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0520),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xBB1A0848), Color(0xDD130535)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Göksel İçgörülerin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF2D9A6),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Seçtiğin yıldızların sana sunduğu mesajlar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _loaded
                      ? _cards.isEmpty
                            ? Center(
                                child: Text(
                                  'Henüz yıldız seçmedin.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.55),
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  0,
                                  14,
                                  16,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.55,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemCount: _cards.length,
                                itemBuilder: (context, index) {
                                  return _InsightCard(
                                    card: _cards[index],
                                    onTap: () => _showDetail(_cards[index]),
                                  );
                                },
                              )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF2D9A6),
                          ),
                        ),
                ),
                if (_loaded && _cards.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const KozmikRehberTarotChatPage(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF7B52C1), Color(0xFF3D1E7A)],
                          ),
                          border: Border.all(
                            color: const Color(
                              0xFFF2D293,
                            ).withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF7B52C1,
                              ).withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFF2D293),
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Kozmik Rehber\'de Yorumla',
                              style: TextStyle(
                                color: Color(0xFFF2D293),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Individual insight card in the grid
// ──────────────────────────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.card, required this.onTap});

  final TarotSelectedCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF0A0D2E).withValues(alpha: 0.55),
        border: Border.all(
          color: const Color(0xFFF2D9A6).withValues(alpha: 0.20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card image
            Expanded(
              flex: 5,
              child: Image.asset(card.asset, fit: BoxFit.cover),
            ),
            // Name
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 3),
              child: Text(
                card.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFF2D9A6),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Description snippet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                card.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 9,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Detail button
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF2D9A6).withValues(alpha: 0.45),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Detay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF2D9A6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Full detail dialog (same style as the original card dialog)
// ──────────────────────────────────────────────────────────────

class _InsightDetailDialog extends StatefulWidget {
  const _InsightDetailDialog({required this.card});

  final TarotSelectedCard card;

  @override
  State<_InsightDetailDialog> createState() => _InsightDetailDialogState();
}

class _InsightDetailDialogState extends State<_InsightDetailDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1050).withValues(alpha: 0.93),
                      const Color(0xFF0D0830).withValues(alpha: 0.93),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFF2D9A6).withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _glowAnim,
                      builder: (_, _) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFF2D9A6,
                                ).withValues(alpha: _glowAnim.value * 0.55),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFF9B59F5,
                                ).withValues(alpha: _glowAnim.value * 0.35),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              widget.card.asset,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.card.name,
                      style: const TextStyle(
                        color: Color(0xFFF2D9A6),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.card.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
