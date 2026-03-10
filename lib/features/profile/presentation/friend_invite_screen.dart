import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FriendInviteScreen extends StatelessWidget {
  const FriendInviteScreen({super.key});

  // Fill this value when the final download URL is ready.
  static const String inviteDownloadLink = '';

  void _onShareLinkTap(BuildContext context) {
    if (inviteDownloadLink.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'İndirme linkini daha sonra ekleyebilirsin. inviteDownloadLink değerini güncellemen yeterli.',
          ),
        ),
      );
      return;
    }

    Clipboard.setData(const ClipboardData(text: inviteDownloadLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Davet bağlantısı panoya kopyalandı.')),
    );
  }

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
                  colors: [Color(0x7A051025), Color(0xE6051025)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
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
                          'Arkadaşlarını Davet Et',
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF5A4E7B), Color(0xFF332F63)],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 216,
                              width: 216,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0x66FFFFFF),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/zodiona_logo_menu.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF27315A),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.groups_rounded,
                                        color: Color(0xFFF2D28E),
                                        size: 54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'Yıldızlarını sevdiklerinle büyüt.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: const Color(0xFFEFF1FF),
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Zodiona deneyimini tek başına yaşamak güzel; ancak bir arkadaşın da katıldığında sohbetler, yorumlar ve keşif yolculuğu çok daha anlamlı oluyor. Davet bağlantını paylaş, onlar da kendi doğum haritasını açsın ve birlikte aynı gökyüzüne farklı açılardan bakın.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    height: 1.45,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _onShareLinkTap(context),
                                icon: const Icon(Icons.link_rounded),
                                label: const Text('Bağlantıyı Paylaş'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0DDAE),
                                  foregroundColor: const Color(0xFF1E1B3D),
                                  minimumSize: const Size.fromHeight(58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  elevation: 0,
                                ),
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
          ),
        ],
      ),
    );
  }
}
