import 'package:flutter/material.dart';

import '../../legal/legal_texts.dart';
import 'contact_support_screen.dart';
import 'faq_screen.dart';

class ZodionaAboutScreen extends StatelessWidget {
  const ZodionaAboutScreen({super.key});

  static const String _appVersion = '2.0.3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66051025), Color(0xCC051025)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFF2E9CF),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Zodiona Hakkında',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFFF2D28E),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _AboutRow(label: 'Uygulama Versiyonu', value: _appVersion),
                  _AboutRow(
                    label: 'Bize Ulaşın',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ContactSupportScreen(
                          entryPoint: 'about_screen',
                        ),
                      ),
                    ),
                  ),
                  _AboutRow(
                    label: 'Uygulamayı Değerlendirin',
                    onTap: () =>
                        _showComingSoon(context, 'Uygulamayı Değerlendirin'),
                  ),
                  _AboutRow(
                    label: 'Kullanıcı Sözleşmesi',
                    onTap: () => _showAgreementDialog(
                      context,
                      title: 'Kullanıcı Sözleşmesi',
                      content: userAgreementContent,
                    ),
                  ),
                  _AboutRow(
                    label: 'Gizlilik Politikası',
                    onTap: () => _showAgreementDialog(
                      context,
                      title: 'Gizlilik Politikası',
                      content: privacyPolicyContent,
                    ),
                  ),
                  _AboutRow(
                    label: 'S.S.S',
                    isLast: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FaqScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title yakında eklenecek.')));
  }

  void _showAgreementDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1F3B),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(child: Text(content)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF2C98A),
              ),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.label,
    this.value,
    this.onTap,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final clickable = onTap != null;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 82,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : Colors.white70,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFF2D28E),
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (clickable)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFF2D28E),
                size: 34,
              ),
          ],
        ),
      ),
    );
  }
}
