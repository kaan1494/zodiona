import 'package:flutter/material.dart';

import 'contact_support_screen.dart';

class ZodionaAboutScreen extends StatelessWidget {
  const ZodionaAboutScreen({super.key});

  static const String _appVersion = '1.0';

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
                    label: 'Kullanıcı Sözleşmesi & Gizlilik Politikası',
                    onTap: () => _showComingSoon(
                      context,
                      'Kullanıcı Sözleşmesi & Gizlilik Politikası',
                    ),
                  ),
                  _AboutRow(
                    label: 'S.S.S',
                    isLast: true,
                    onTap: () => _showComingSoon(context, 'S.S.S'),
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
