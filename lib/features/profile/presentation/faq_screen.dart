import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? _expandedIndex;

  static const List<_FaqItem> _items = [
    _FaqItem(
      question: 'Zodiona Nedir?',
      answer:
          'Zodiona, doğum anındaki gökyüzü haritanı yapay zeka destekli astroloji yorumlarıyla birleştiren kişisel bir rehberdir. Sadece burç göstermekle kalmaz; ilişkiler, kariyer ve günlük kararlarında daha net bir bakış açısı kazanman için sana özel içerikler sunar.',
    ),
    _FaqItem(
      question: 'Zodiona Nasıl Çalışır?',
      answer: '''
    Zodiona, doğum tarihi, doğum saati ve doğum konumu bilgilerini bir araya getirerek kişisel gökyüzü haritanı oluşturur. Bu verilerden Güneş, Ay, yükselen ve temel yerleşimlerin hesaplanır.

    Sonrasında Zodiona, bu teknik verileri anlaşılır bir dile çevirir ve sana özel içgörüler üretir. Böylece sadece “hangi burçsun” sorusuna değil; ilişkiler, kariyer, zamanlama ve kişisel farkındalık gibi günlük hayattaki konulara da daha net bir bakış kazanırsın.

    Kısacası Zodiona, klasik astrolojiyi modern teknolojiyle birleştirerek kendini daha iyi tanıman için kişiselleştirilmiş bir rehberlik deneyimi sunar.
    ''',
    ),
    _FaqItem(
      question: 'Güneş Burcu, Yükselen Burç ve Ay Burcu Nedir?',
      answer: '''
    Güneş Burcu: Temel karakterini, yaşam enerjini ve kimliğini anlatır. Hayata nasıl yön verdiğini, hangi motivasyonlarla hareket ettiğini anlamada güçlü bir referanstır.

    Ay Burcu: Duygusal dünyanı, içten verdiğin tepkileri ve güven ihtiyacını temsil eder. Zor anlarda nasıl hissettiğini ve içsel olarak neye ihtiyaç duyduğunu anlamana yardımcı olur.

    Yükselen Burç: Dış dünyaya yansıttığın ilk izlenimi, duruşunu ve hayata yaklaşım tarzını gösterir. İnsanlarla kurduğun ilk temasın tonunu ve olaylara reflekslerini şekillendiren önemli bir etkidir.
    ''',
    ),
    _FaqItem(
      question: 'Doğum Saatim Neden Önemli?',
      answer: '''
    Doğum saati, haritanın en kritik anahtarlarından biridir. Özellikle yükselen burcun ve ev yerleşimlerinin doğru hesaplanması doğrudan bu bilgiye bağlıdır.

    Saat bilgisindeki küçük bir fark bile yükselen burcu veya bazı ev konumlarını değiştirebilir. Bu da yorumların odağını etkileyebilir.

    Bu yüzden Zodiona’da doğum saatini ne kadar doğru girersen, sana sunulan kişisel analizler de o kadar isabetli ve sana özel olur.
    ''',
    ),
    _FaqItem(
      question:
          'Uygulamada burcum bildiğimden farklı görünüyor, neden olabilir?',
      answer: '''
    Bu durumun en yaygın nedeni, doğum bilgilerine ait küçük farklardır. Doğum saati, konum veya saat dilimi bilgisindeki kısa bir kayma bile hesaplama sonucunu etkileyebilir.

    Ayrıca astrolojide kullanılan sistem farkları da sonuçları değiştirebilir. Bazı kaynaklar sidereal yaklaşımı, bazıları tropikal yaklaşımı temel alır. Zodiona, kendi hesaplama altyapısı ve yorum modeliyle çalıştığı için gördüğün sonuç, daha önce farklı bir kaynaktan öğrendiğin burçla birebir örtüşmeyebilir.

    En doğru sonuç için doğum tarihini, saatini ve doğum yerini profilinden tekrar kontrol etmeni öneririz. Dilersen destek ekibine yazarak birlikte detaylı inceleme de yapabiliriz.
    ''',
    ),
    _FaqItem(
      question: 'Doğum Tarihimi Nasıl Düzenleyebilirim?',
      answer: '''
    Doğum tarihi, doğum saati ve doğum yeri bilgilerini profil alanından kolayca güncelleyebilirsin. Bu bilgiler astrolojik hesaplamaların temelini oluşturduğu için doğru girilmesi çok önemlidir.

    Adım adım güncelleme:

    - Zodiona uygulamasında Profilim ekranına gir.
    - Hesap Ayarları bölümünü aç.
    - Doğum bilgileri alanından tarih, saat ve konum bilgilerini düzenle.
    - Değişiklikleri kaydedip profiline geri dön.

    Güncellemeden sonra sonuçlarda hâlâ bir tutarsızlık görürsen, destek ekibine `kanovasoft@gmail.com` adresinden yazabilirsin. Ekibimiz en kısa sürede yardımcı olur.
    ''',
    ),
    _FaqItem(
      question: 'Astrologlara Nasıl Soru Sorabilirim?',
      answer: '''
    Danışmanlık almak için uygulama içindeki ilgili astrolog alanına girip sorunu doğrudan iletebilirsin. Net bir yanıt almak için sorunu kısa ama bağlamı güçlü şekilde yazmanı öneririz.

    Daha verimli soru sormak için:

    - Önce konunu seç: ilişki, kariyer, zamanlama veya kişisel gelişim.
    - Kısa bir arka plan ver: “Son 2 aydır iş değişikliği düşünüyorum” gibi.
    - Beklentini açık yaz: “Bu dönem yeni başlangıç için uygun mu?” gibi.
    - Tek mesajda çok farklı konu açmak yerine önceliğini belirt.

    Bu yaklaşım, astrologların sana daha odaklı ve daha işe yarar bir yorum sunmasını sağlar. Gerekli durumlarda ek detay istenebilir; bu normaldir ve yorumun kalitesini artırır.
    ''',
    ),
    _FaqItem(
      question: 'Astrologlara Ne Sorabilirim?',
      answer: '''
    Astrologlara; ilişki dinamikleri, kariyer yönü, taşınma/yenilik dönemleri, duygusal dalgalanmalar ve kişisel farkındalık gibi başlıklarda soru sorabilirsin.

    Örnek soru biçimleri:

    - “Önümüzdeki aylarda kariyerimde hangi alana odaklanmam daha doğru olur?”
    - “İlişkimde tekrar eden sorunların astrolojik teması ne olabilir?”
    - “Bu dönemde risk almak mı, planı korumak mı benim için daha uygun?”

    Soruların ne kadar açık ve somut olursa, alacağın yorum da o kadar güçlü olur. Zodiona’da amaç; seni korkutan genellemeler değil, hayatına uygulanabilir ve yol gösterici içgörüler sunmaktır.
    ''',
    ),
    _FaqItem(
      question: 'Ücretsiz Kullanım ve Premium Paketler Arasındaki Fark Nedir?',
      answer: '''
    Zodiona’da ücretsiz kullanım, uygulamayı deneyimleyebilmen için temel içeriklere erişim sunar. Burç temelli ana akışlar, genel yorumlar ve başlangıç seviyesinde rehberlik bu katmanda yer alır.

    Premium kullanım ise deneyimi daha kişisel ve daha derin hale getirir. İçerikler daha kapsamlıdır, analizler daha detaylıdır ve sana özel yorum akışları daha sık güncellenir.

    Kısaca:

    - Ücretsiz: Temel keşif ve başlangıç içgörüleri.
    - Premium: Daha fazla kişiselleştirme, daha güçlü yorum derinliği ve genişletilmiş astrolojik içerik erişimi.

    Hedefimiz her iki seviyede de fayda sunmak; premium tarafta ise Zodiona’yı senin yaşam ritmine daha yakın bir rehbere dönüştürmektir.
    ''',
    ),
    _FaqItem(
      question: 'Aboneliğimi Nasıl İptal Edebilirim?',
      answer: '''
    Zodiona Premium aboneliğini, satın alma yaptığın mağaza hesabının abonelik ayarlarından iptal edebilirsin. Uygulamayı silmek, aboneliği tek başına sonlandırmaz.

    Google Play üzerinden aldıysan:

    - Google Play Store uygulamasını aç.
    - Sağ üstteki profil simgesine dokun.
    - “Ödemeler ve abonelikler” > “Abonelikler” yolunu izle.
    - Zodiona aboneliğini seçip iptal adımlarını tamamla.

    App Store üzerinden aldıysan:

    - iPhone’da Ayarlar uygulamasını aç.
    - Adına dokun ve “Abonelikler” bölümüne gir.
    - Zodiona aboneliğini seç.
    - “Aboneliği İptal Et” adımını onayla.

    Aboneliğin, mevcut fatura döneminin sonuna kadar aktif kalır; bir sonraki yenilemede ücret alınmaz. Takıldığın bir noktada `kanovasoft@gmail.com` adresinden bize yazabilirsin.
    ''',
    ),
  ];

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
                        'S.S.S',
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isExpanded = _expandedIndex == index;
                      return _FaqAccordionItem(
                        question: item.question,
                        answer: item.answer,
                        expanded: isExpanded,
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                      );
                    },
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

class _FaqAccordionItem extends StatelessWidget {
  const _FaqAccordionItem({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.75)),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFFF2D28E),
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 8, 20),
              child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.45,
                ),
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
