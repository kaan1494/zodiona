import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/advisor_chat_service.dart';
import 'advisor_chat_page.dart';

class AdvisorPage extends StatefulWidget {
  const AdvisorPage({
    super.key,
    required this.header,
    this.initialTabIndex = 0,
  });

  final Widget header;
  final int initialTabIndex;

  @override
  State<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends State<AdvisorPage> {
  int _selectedTabIndex = 0;

  static const List<String> _tabs = ['Danışmanlık', 'Raporlar', 'Mesajlarım'];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = _normalizeTabIndex(widget.initialTabIndex);
  }

  @override
  void didUpdateWidget(covariant AdvisorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _selectedTabIndex = _normalizeTabIndex(widget.initialTabIndex);
    }
  }

  int _normalizeTabIndex(int value) {
    if (value < 0) {
      return 0;
    }
    if (value >= _tabs.length) {
      return _tabs.length - 1;
    }
    return value;
  }

  static const List<_AdvisorData> _defaultAdvisors = [
    _AdvisorData(
      name: 'Ece Bingör',
      priceText: '₺4.799,99',
      bio:
          'Ece Bingör 11 Ekim 1989 istanbul doğumludur. Çocukluk yıllarından itibaren evrenin sistemine olan  ilgisini Ziraat mühendisi olarak doğaya katkı sağladıktan sonra okült ilimlerle birleştirmiştir. İnsanı ve Yaratılan herşeyin düzenini anlamaya çalışırken Astrolojide Uzmanlaşmıştır. 2016 senesinden beri bu alanda kendini geliştirip insanlara kendi hayatlarında bilinç sıçraması yaptırmayı amaç edinmiştir. Astroloji danışmanlığı ile beraber ruhsal dönüşüme katkı sağlamaktadır.',
      imagePath: 'assets/danısman/ecebingör.jpg',
    ),
    _AdvisorData(
      name: 'Ebru Yıldırım',
      priceText: '₺4.799,99',
      bio:
          'Ebru Yıldırım, Eskişehir doğumludur. Yazılım alanındaki profesyonel kariyerini, çocukluk yıllarından gelen astroloji ilgisiyle harmanlayarak danışmanlık hizmetine taşımıştır. Analitik zekâ ve güçlü sezgileri bir araya getiren yaklaşımıyla, bireylere yaşam yolculuklarında netlik ve farkındalık kazandırmayı amaçlar.',
      imagePath: 'assets/danısman/ebruyıldıırm.jpg',
    ),
  ];

  static const List<_AdvisorData> _horaryAdvisors = [
    _AdvisorData(
      name: 'Ece Bingör',
      priceText: '₺899,99',
      bio:
          'Ece Bingör 11 Ekim 1989 istanbul doğumludur. Çocukluk yıllarından itibaren evrenin sistemine olan  ilgisini Ziraat mühendisi olarak doğaya katkı sağladıktan sonra okült ilimlerle birleştirmiştir. İnsanı ve Yaratılan herşeyin düzenini anlamaya çalışırken Astrolojide Uzmanlaşmıştır. 2016 senesinden beri bu alanda kendini geliştirip insanlara kendi hayatlarında bilinç sıçraması yaptırmayı amaç edinmiştir. Astroloji danışmanlığı ile beraber ruhsal dönüşüme katkı sağlamaktadır.',
      imagePath: 'assets/danısman/ecebingör.jpg',
    ),
    _AdvisorData(
      name: 'Ebru Yıldırım',
      priceText: '₺899,99',
      bio:
          'Ebru Yıldırım, Eskişehir doğumludur. Yazılım alanındaki profesyonel kariyerini, çocukluk yıllarından gelen astroloji ilgisiyle harmanlayarak danışmanlık hizmetine taşımıştır. Analitik zekâ ve güçlü sezgileri bir araya getiren yaklaşımıyla, bireylere yaşam yolculuklarında netlik ve farkındalık kazandırmayı amaçlar.',
      imagePath: 'assets/danısman/ebruyıldıırm.jpg',
    ),
  ];

  static const List<_AdvisorData> _birthChartAdvisors = [
    _AdvisorData(
      name: 'Ece Bingör',
      priceText: '₺1.799,99',
      bio:
          'Ece Bingör 11 Ekim 1989 istanbul doğumludur. Çocukluk yıllarından itibaren evrenin sistemine olan  ilgisini Ziraat mühendisi olarak doğaya katkı sağladıktan sonra okült ilimlerle birleştirmiştir. İnsanı ve Yaratılan herşeyin düzenini anlamaya çalışırken Astrolojide Uzmanlaşmıştır. 2016 senesinden beri bu alanda kendini geliştirip insanlara kendi hayatlarında bilinç sıçraması yaptırmayı amaç edinmiştir. Astroloji danışmanlığı ile beraber ruhsal dönüşüme katkı sağlamaktadır.',
      imagePath: 'assets/danısman/ecebingör.jpg',
    ),
    _AdvisorData(
      name: 'Ebru Yıldırım',
      priceText: '₺1.799,99',
      bio:
          'Ebru Yıldırım, Eskişehir doğumludur. Yazılım alanındaki profesyonel kariyerini, çocukluk yıllarından gelen astroloji ilgisiyle harmanlayarak danışmanlık hizmetine taşımıştır. Analitik zekâ ve güçlü sezgileri bir araya getiren yaklaşımıyla, bireylere yaşam yolculuklarında netlik ve farkındalık kazandırmayı amaçlar.',
      imagePath: 'assets/danısman/ebruyıldıırm.jpg',
    ),
  ];

  static const List<_AdvisorData> _astrocartographyAdvisors = [
    _AdvisorData(
      name: 'Ece Bingör',
      priceText: '₺1.399,00',
      bio:
          'Ece Bingör 11 Ekim 1989 istanbul doğumludur. Çocukluk yıllarından itibaren evrenin sistemine olan  ilgisini Ziraat mühendisi olarak doğaya katkı sağladıktan sonra okült ilimlerle birleştirmiştir. İnsanı ve Yaratılan herşeyin düzenini anlamaya çalışırken Astrolojide Uzmanlaşmıştır. 2016 senesinden beri bu alanda kendini geliştirip insanlara kendi hayatlarında bilinç sıçraması yaptırmayı amaç edinmiştir. Astroloji danışmanlığı ile beraber ruhsal dönüşüme katkı sağlamaktadır.',
      imagePath: 'assets/danısman/ecebingör.jpg',
    ),
    _AdvisorData(
      name: 'Ebru Yıldırım',
      priceText: '₺1.399,00',
      bio:
          'Ebru Yıldırım, Eskişehir doğumludur. Yazılım alanındaki profesyonel kariyerini, çocukluk yıllarından gelen astroloji ilgisiyle harmanlayarak danışmanlık hizmetine taşımıştır. Analitik zekâ ve güçlü sezgileri bir araya getiren yaklaşımıyla, bireylere yaşam yolculuklarında netlik ve farkındalık kazandırmayı amaçlar.',
      imagePath: 'assets/danısman/ebruyıldıırm.jpg',
    ),
  ];

  static const List<_AdvisorData> _electionAdvisors = [
    _AdvisorData(
      name: 'Ece Bingör',
      priceText: '₺1.399,00',
      bio:
          'Ece Bingör 11 Ekim 1989 istanbul doğumludur. Çocukluk yıllarından itibaren evrenin sistemine olan  ilgisini Ziraat mühendisi olarak doğaya katkı sağladıktan sonra okült ilimlerle birleştirmiştir. İnsanı ve Yaratılan herşeyin düzenini anlamaya çalışırken Astrolojide Uzmanlaşmıştır. 2016 senesinden beri bu alanda kendini geliştirip insanlara kendi hayatlarında bilinç sıçraması yaptırmayı amaç edinmiştir. Astroloji danışmanlığı ile beraber ruhsal dönüşüme katkı sağlamaktadır.',
      imagePath: 'assets/danısman/ecebingör.jpg',
    ),
    _AdvisorData(
      name: 'Ebru Yıldırım',
      priceText: '₺1.399,00',
      bio:
          'Ebru Yıldırım, Eskişehir doğumludur. Yazılım alanındaki profesyonel kariyerini, çocukluk yıllarından gelen astroloji ilgisiyle harmanlayarak danışmanlık hizmetine taşımıştır. Analitik zekâ ve güçlü sezgileri bir araya getiren yaklaşımıyla, bireylere yaşam yolculuklarında netlik ve farkındalık kazandırmayı amaçlar.',
      imagePath: 'assets/danısman/ebruyıldıırm.jpg',
    ),
  ];

  static const List<_ConsultationCardData> _consultationCards = [
    _ConsultationCardData(
      title: 'Yıllık Öngörü',
      description:
          'Önündeki 12 ayın ana temalarını, fırsat pencerelerini ve dikkat gerektiren eşikleri birlikte yorumlarız. Böylece yılını daha planlı ve bilinçli yönetebilirsin.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      extraCount: 1,
      detailDescription:
          'Doğum haritandan yola çıkarak bir yıl boyunca öne çıkacak dönemleri; başlangıç, tamamlanma ve dönüşüm başlıklarıyla netleştirir. Bu çalışma, zamanlamayı doğru kurmak ve enerjini doğru alana yönlendirmek için kişisel bir rota sunar.',
      detailAdvisors: _defaultAdvisors,
    ),
    _ConsultationCardData(
      title: 'İlişki Uyumu',
      description:
          'Seninle seçtiğin kişinin harita dinamiklerini karşılaştırarak güçlü bağları, zorlanma noktalarını ve ilişkiyi büyütecek iletişim anahtarlarını görünür kılar.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      detailDescription:
          'İki haritanın birbirini nasıl tamamladığını; duygusal ihtiyaçlar, beklentiler ve çatışma alanları üzerinden ele alır. Amaç, ilişkiyi daha sağlıklı bir ritimde ilerletebilmen için farkındalık ve yön kazandırmaktır.',
      detailAdvisors: _defaultAdvisors,
    ),
    _ConsultationCardData(
      title: 'Danışmana Sor - Horary',
      description:
          'Zamanı kritik bir soruya odaklanıp sorunun sorulduğu ana ait harita ile kısa vadede en net yönü bulmaya yardımcı olan özel bir analiz sunar.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      extraCount: 1,
      detailDescription:
          'Horary Astrolojisi, net cevaplar aradığın evet-hayır sorularına ışık tutmak için kullanılır. Sorunun sorulduğu anın haritası üzerinden yapılan bu yorumlama; aşk, kariyer, eğitim, sağlık, finans ve aile kararlarında kısa vadede daha net bir yön görmeni sağlar.',
      detailAdvisors: _horaryAdvisors,
    ),
    _ConsultationCardData(
      title: 'Doğum Haritası Analizi',
      description:
          'Potansiyelini, güçlü taraflarını ve gelişim alanlarını kişisel harita yerleşimlerin üzerinden okuyarak daha net bir öz farkındalık sağlar.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      extraCount: 1,
      detailDescription:
          'Doğduğun anda gökyüzünün sana çizdiği kişisel haritayı inceleyerek seni sen yapan dinamikleri ortaya koyar. Potansiyellerin, gelişim alanların, içsel gücün ve yaşamındaki olası dönüm noktaları bu analizle görünür hâle gelir.',
      detailAdvisors: _birthChartAdvisors,
    ),
    _ConsultationCardData(
      title: 'Eleksiyon Astrolojisi',
      description:
          'Yeni adımlar için en uygun zaman aralıklarını seçmene yardımcı olur; taşınma, iş değişimi ya da resmi başlangıçlarda doğru ritmi yakalamanı destekler.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      detailDescription:
          'Hayatındaki önemli adımlar için en doğru anı bulmana yardımcı olur. Yeni bir işe başlamak, taşınmak, bir ilişkiyi başlatmak ya da önemli kararlar almak istiyorsan; gökyüzünün desteğini yanında hissetmek için bu analiz ideal bir zamanlama rehberi sunar.',
      detailAdvisors: _electionAdvisors,
    ),
    _ConsultationCardData(
      title: 'Astrokartografi',
      description:
          'Haritandaki gezegen etkilerini coğrafi hatlarla eşleştirerek yaşam, kariyer ve ilişki temalarında hangi bölgelerin seni daha fazla desteklediğini gösterir.',
      avatars: [
        'assets/danısman/ecebingör.jpg',
        'assets/danısman/ebruyıldıırm.jpg',
      ],
      detailDescription:
          'Doğum haritandaki gezegen hatlarını dünyanın farklı coğrafyalarıyla eşleştirerek, hangi yerlerin senin için daha şanslı, destekleyici ya da dönüştürücü olduğunu ortaya koyar. Kariyer fırsatları, yaşam amacı, ruhsal büyüme ve ilişkiler için güçlü bir konum rehberi sağlar.',
      detailAdvisors: _astrocartographyAdvisors,
    ),
  ];

  void _openConsultationDetail(_ConsultationCardData card) {
    if (card.detailDescription == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ConsultationDetailPage(
          title: card.title,
          description: card.detailDescription!,
          advisors: card.detailAdvisors ?? _defaultAdvisors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/onboarding/home_page.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x220B1026),
                  Color(0x880B1026),
                  Color(0xFF1B1F3B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 104),
            child: Column(
              children: [
                widget.header,
                const SizedBox(height: 14),
                _AdvisorTabs(
                  tabs: _tabs,
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) =>
                      setState(() => _selectedTabIndex = index),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) ...[currentChild],
                        ],
                      );
                    },
                    child: switch (_selectedTabIndex) {
                      0 => _ConsultationTab(
                        key: const ValueKey<int>(0),
                        cards: _consultationCards,
                        onCardTap: _openConsultationDetail,
                      ),
                      1 => const _ReportsTab(key: ValueKey<int>(1)),
                      _ => _MyChatsTab(key: const ValueKey<int>(2)),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdvisorTabs extends StatelessWidget {
  const _AdvisorTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF5E1B9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? const Color(0xFF2E3B67) : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ConsultationTab extends StatelessWidget {
  const _ConsultationTab({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  final List<_ConsultationCardData> cards;
  final ValueChanged<_ConsultationCardData> onCardTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final card = cards[index];
        final isClickable = card.detailDescription != null;
        return InkWell(
          onTap: isClickable ? () => onCardTap(card) : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            decoration: BoxDecoration(
              color: const Color(0xFF494E85).withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x40AAB4E7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFE9CF8D),
                    fontWeight: FontWeight.w600,
                    fontSize: 36 / 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.34,
                    fontSize: 31 / 2,
                  ),
                ),
                const SizedBox(height: 12),
                _AvatarRow(avatars: card.avatars, extraCount: card.extraCount),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF454B86).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x68B6C0EB)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF7D8AE3),
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: Text(
                'Yakında',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 222,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ebeveynlik Rehberi: Çocuğunun Potansiyelini Yıldızlarla Keşfet',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '✦ Doğum haritası üzerinden karakter eğilimlerini daha iyi anla.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    height: 1.24,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '✦ Aile içi iletişimde denge kurmana yardımcı olacak kişisel öneriler al.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    height: 1.24,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 145,
                    child: Image.asset(
                      'assets/admin_story_presets/story_10.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyChatsTab extends StatelessWidget {
  const _MyChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(
        child: Text(
          'Oturum açılmamış.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return StreamBuilder<List<AdvisorChatSummary>>(
      stream: AdvisorChatService().userChatsStream(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFD700)),
          );
        }
        if (snap.hasError) {
          return Center(
            child: Text(
              'Hata: ${snap.error}',
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          );
        }
        final chats = snap.data ?? [];
        if (chats.isEmpty) {
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF454B86).withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x80C6CEEF)),
              ),
              child: Text(
                'Henüz bir danışmanla iletişim kurmadınız.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  height: 1.26,
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          itemBuilder: (context, i) {
            final chat = chats[i];
            return _ChatSummaryCard(chat: chat);
          },
        );
      },
    );
  }
}

class _ChatSummaryCard extends StatelessWidget {
  const _ChatSummaryCard({required this.chat});
  final AdvisorChatSummary chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdvisorChatPage(
              chatId: chat.id,
              advisorName: chat.advisorName,
              consultationType: chat.consultationType,
              advisorImagePath: 'assets/admin_story_presets/story_05.png',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1650).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: chat.unreadByUser
                ? const Color(0xFFFFD700)
                : const Color(0x509B7FD4),
            width: chat.unreadByUser ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF6B2FA0).withValues(alpha: 0.55),
              child: Icon(
                chat.unreadByUser
                    ? Icons.mark_email_unread
                    : Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.advisorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chat.consultationType,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                  if (chat.lastMessage.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (chat.unreadByUser)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow({required this.avatars, required this.extraCount});

  final List<String> avatars;
  final int? extraCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          ...avatars.asMap().entries.map(
            (entry) => Transform.translate(
              offset: Offset(
                entry.key == 0 ? 0 : -10 * entry.key.toDouble(),
                0,
              ),
              child: _AdvisorAvatar(imagePath: entry.value, size: 34),
            ),
          ),
          if (extraCount != null && extraCount! > 0)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                '+$extraCount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ConsultationDetailPage extends StatefulWidget {
  const _ConsultationDetailPage({
    required this.title,
    required this.description,
    required this.advisors,
  });

  final String title;
  final String description;
  final List<_AdvisorData> advisors;

  @override
  State<_ConsultationDetailPage> createState() =>
      _ConsultationDetailPageState();
}

class _ConsultationDetailPageState extends State<_ConsultationDetailPage> {
  bool _isLoadingChat = false;

  Future<void> _onSelectAdvisor(_AdvisorData advisor) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoadingChat = true);
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = userDoc.data() ?? {};
      final isPremium = data['isPremium'] as bool? ?? false;

      if (!mounted) return;

      if (!isPremium) {
        _showPremiumRequiredDialog();
        return;
      }

      final service = AdvisorChatService();
      final chatId = await service.getOrCreateChat(
        advisorName: advisor.name,
        consultationType: widget.title,
        userProfile: data,
      );

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AdvisorChatPage(
            chatId: chatId,
            advisorName: advisor.name,
            consultationType: widget.title,
            advisorImagePath: advisor.imagePath,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingChat = false);
    }
  }

  void _showPremiumRequiredDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1E5A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x55F2D9A6)),
        ),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Color(0xFFF2D9A6)),
            SizedBox(width: 8),
            Text(
              'Premium Üyelik Gerekli',
              style: TextStyle(
                color: Color(0xFFF2D9A6),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Danışmana soru sorabilmek için premium üyeliğe sahip olman gerekiyor.\n\nProfil > Promosyon Kodu Kullan bölümünden bir kod girerek premium erişim kazanabilirsin.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Tamam',
              style: TextStyle(color: Color(0xFFF2D9A6)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x280B1026),
                    Color(0x920B1026),
                    Color(0xE01B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          if (_isLoadingChat)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x88000000),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFF2D9A6)),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(24),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFFE7D8AF),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFFE9CF8D),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.34,
                                ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            color: Color(0xC6C9CDE4),
                            thickness: 1.1,
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Danışmanlarımız',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: const Color(0xFFE9CF8D),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...widget.advisors.map(
                            (advisor) => _AdvisorDetailCard(
                              advisor: advisor,
                              onSelect: () => _onSelectAdvisor(advisor),
                            ),
                          ),
                        ],
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

class _AdvisorDetailCard extends StatelessWidget {
  const _AdvisorDetailCard({required this.advisor, required this.onSelect});

  final _AdvisorData advisor;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4F87).withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x44BCC5EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AdvisorAvatar(imagePath: advisor.imagePath, size: 78),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advisor.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFE9CF8D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      advisor.priceText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFF3DFB0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advisor.bio,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSelect,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF5E1B9),
                foregroundColor: const Color(0xFF2E3B67),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Danışmanı Seç'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvisorAvatar extends StatelessWidget {
  const _AdvisorAvatar({required this.imagePath, this.size = 40});

  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEAD8AE), width: 1.4),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF2D3566),
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                size: size * 0.56,
                color: const Color(0xFFEAD8AE),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ConsultationCardData {
  const _ConsultationCardData({
    required this.title,
    required this.description,
    required this.avatars,
    this.extraCount,
    this.detailDescription,
    this.detailAdvisors,
  });

  final String title;
  final String description;
  final List<String> avatars;
  final int? extraCount;
  final String? detailDescription;
  final List<_AdvisorData>? detailAdvisors;
}

class _AdvisorData {
  const _AdvisorData({
    required this.name,
    required this.priceText,
    required this.bio,
    required this.imagePath,
  });

  final String name;
  final String priceText;
  final String bio;
  final String imagePath;
}
