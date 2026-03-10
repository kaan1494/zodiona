import 'package:flutter/material.dart';

class NeUzerineCalisiyoruzScreen extends StatelessWidget {
  const NeUzerineCalisiyoruzScreen({super.key});

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                  child: Row(
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
                          'Ne Üzerine Çalışıyoruz',
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E3A62),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF2D28E)),
                      ),
                      child: Text(
                        _content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                          height: 1.45,
                        ),
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

const String _content =
    'Seninle paylaşmaktan mutluluk duyuyoruz.\n\n'
    'Sevgili Ruh,\n\n'
    'Gökyüzü her gün değişiyor ve biz bu değişimi senin hayatına daha net, daha kullanışlı ve daha kişisel bir dille taşımak için çalışıyoruz. '
    'Hedefimiz yalnızca günlük yorum vermek değil; doğum haritanı gerçek hayattaki kararlarınla birleştiren bir rehber sunmak.\n\n'
    'Bu dönemde Zodiona için en çok odaklandığımız alanlardan biri uzun vadeli gökyüzü planı. '
    'Yani sadece bugünü değil; önündeki haftaları ve ayları da kapsayan, sana özel bir yol haritası hazırlıyoruz. '
    'Böylece önemli dönemleri önceden görebilir, hazırlık yapabilir ve fırsatları daha doğru zamanda değerlendirebilirsin.\n\n'
    'Aynı zamanda ilişki, kariyer, para, sağlık ve kişisel gelişim gibi başlıklarda daha hedefli yorumlar geliştiriyoruz. '
    'Her kullanıcının önceliği farklı olduğu için, yorumların da tek tip değil; senin ritmine, haritana ve gündemine uygun olması için sistemi adım adım yeniliyoruz.\n\n'
    'Takvim tarafında da daha güçlü bir deneyim geliyor. '
    'Gezegen hareketlerini sadece teknik bilgi olarak değil, "bugün neye odaklanmalıyım" sorusuna cevap veren sade bir akışla sunacağız. '
    'Böylece uygulamaya girdiğinde hem resmi görecek hem de aksiyona geçecek net adımı bulabileceksin.\n\n'
    'Senin geri bildirimlerin bizim için çok değerli. '
    'Hangi konularda daha fazla içerik istediğini, hangi özelliklerin hayatını kolaylaştıracağını ve neleri değiştirmemizi istediğini duymak istiyoruz.\n\n'
    'Bu yolculuğu birlikte, daha güçlü ve daha anlamlı hale getiriyoruz.\n\n'
    'Sevgiyle,\n'
    'Zodiona Ekibi';
