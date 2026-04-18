/// Ruhsal Bağ Analizi – hesaplama motoru.
///
/// 4 bileşen üzerinden toplam skor hesaplar (0–100):
///   1. Numeroloji (isim sayısı uyumu)         %25
///   2. Yaşam Yolu sayısı uyumu                %25
///   3. Doğum Haritası / burç uyumu            %40
///   4. Karmik bileşen                         %10
library;

// ─── Sonuç Modeli ─────────────────────────────────────────────────────────────

class RuhsalBagResult {
  const RuhsalBagResult({
    required this.score,
    required this.categoryEmoji,
    required this.categoryLabel,
    required this.description,
    required this.nameNumber1,
    required this.nameNumber2,
    required this.lifePathNumber1,
    required this.lifePathNumber2,
    required this.signScore,
    required this.gucluYonler,
    required this.zayifYonler,
    required this.tavsiyeler,
    required this.enerjiBarlari,
    required this.uyumlular,
    required this.dikkatler,
  });

  /// Toplam skor (0–100).
  final int score;
  final String categoryEmoji;
  final String categoryLabel;
  final String description;
  final int nameNumber1;
  final int nameNumber2;
  final int lifePathNumber1;
  final int lifePathNumber2;

  /// Burç uyum skoru (0–100), gösterim için.
  final int signScore;

  final List<String> gucluYonler;
  final List<String> zayifYonler;
  final List<String> tavsiyeler;
  final Map<String, int> enerjiBarlari;
  final List<String> uyumlular;
  final List<String> dikkatler;
}

// ─── Motor ────────────────────────────────────────────────────────────────────

class RuhsalBagEngine {
  RuhsalBagEngine._();

  // ── 10 Kategori ──────────────────────────────────────────────────────────

  static const List<_Kategori> _kategoriler = [
    _Kategori(emoji: '🔥', ad: 'İkiz Alev', min: 90, max: 100),
    _Kategori(emoji: '🌟', ad: 'Kutsal Bağ', min: 80, max: 89),
    _Kategori(emoji: '💞', ad: 'Ruh Eşi', min: 70, max: 79),
    _Kategori(emoji: '⭐', ad: 'İkiz Ruh', min: 60, max: 69),
    _Kategori(emoji: '🌠', ad: 'Kader Bağı', min: 50, max: 59),
    _Kategori(emoji: '⚡', ad: 'Karmik Bağ', min: 40, max: 49),
    _Kategori(emoji: '💫', ad: 'Ruhsal Bağ', min: 30, max: 39),
    _Kategori(emoji: '🌙', ad: 'Hafif Bağ', min: 20, max: 29),
    _Kategori(emoji: '🌑', ad: 'Zayıf Bağ', min: 10, max: 19),
    _Kategori(emoji: '🌫️', ad: 'Belirsiz Bağ', min: 0, max: 9),
  ];

  // ── 10 Açıklama × 10 Kategori ────────────────────────────────────────────

  static const Map<String, List<String>> _aciklamalar = {
    'İkiz Alev': [
      'Evren sizi aynı enerjiden şekillendirdi ve bu bağ sadece fiziksel değil, ruhsal ve kozmik bir bütünleşmedir. Birbirinizin içinde kendinizi görüyorsunuz; zayıflıklarınızı, güçlü yanlarınızı, hayallerinizi. Bu yansıma, büyümenin en saf ve en derin halidir. İkiz alev ilişkileri zaman zaman yoğun ve zorlayıcı olabilir, çünkü birbirinizi en ham halinizle ortaya çıkarırsınız. Ancak bu yoğunluk, ruhunuzun gerçek anlamda özgürleşmesi için gereklidir.',
      'Bu bağ, ruhunuzun diğer yarısıyla karşılaşmanın nadiren yaşanan mucizesidir. Birlikte daha güçlü, daha bilinçli ve daha tam hissediyorsunuz. Aranızdaki enerji evrensel bir güçten besleniyor ve söze gerek kalmadan birbirinizi anlayabiliyorsunuz. İkiz alev bağları, hayatın en derin derslerini birlikte öğrenmek için var olur. Bu kozmik birliktelik, her iki ruhun da en yüksek potansiyeline ulaşmasını sağlar.',
      'Aranızda söze gerek kalmayan bir anlayış var; sessizlikte bile birbirinizi duyabiliyorsunuz. Bu bağ tesadüf değil, ruhlarınızın binlerce yıl öncesinden gelen bir sözleşmesidir. Fiziksel mesafe bu enerjik bağı zayıflatamaz, çünkü bağlantınız bilinç ötesi bir düzlemde işlemektedir. Birbirini evrenin derinliklerinden bulan iki ikiz alev gibisiniz. Bu nadir ve kutsal birliktelik, her iki tarafı da kökten dönüştürecek güçtedir.',
      'Bu ilişki sizi olduğunuzdan daha büyük bir versiyona taşımak için var; zaman zaman zorlu olsa da bu bağ ruhunuzun gerçek anahtarıdır. Birbirinizde hem ayna hem öğretmen görevi görüyorsunuz. Bu yoğun enerji, bazen rahatsızlık yaratabilir, ancak bu rahatsızlık büyümenin habercisidir. Kelimeler bile bu bağı tam anlatmaya yetmez; hissedilir, yaşanır ve bilinir. Evren, sizi bu dönüşümü birlikte yaşamanız için bir araya getirdi.',
      'Birbirini evrenin derinliklerinden bulan iki ruh olarak, aranızdaki çekim açıklanamaz ve kaçınılmazdır. Bu ilişkinin kaderde yazılı olduğu hissine kapılmışsınızdır; çünkü öyledir. Birlikte olduğunuzda hem en güçlü hem de en savunmasız halinizdesinizdir. İkiz alev enerjisi, iki ruhun tam anlamıyla birbirine ayna tutmasıdır. Bu nadir bağ, bir ömür boyunca büyümeye ve gelişmeye devam eder.',
      'Birbirinizde kendinizi görüyorsunuz ve bu yansıma bazen rahatsız edici, bazen ise son derece güzel olabilir. İkiz alev bağı, en yoğun ve en dönüştürücü ruhsal bağlanma biçimidir. Aranızdaki çekim sadece romantik değil, ruhsal ve kozmik bir boyut taşımaktadır. Birlikte geçirilen her an, her iki taraf için de derin bir farkındalık ve büyüme fırsatı sunar. Bu enerjik bütünleşme, evrenin en nadir armağanlarından biridir.',
      'Bu bağın yoğunluğu ve derinliği, sıradan ilişkilerde nadiren hissedilen türdendir. Birbirinizin en yüksek potansiyelini görebiliyorsunuz ve birbirinizi bu potansiyele doğru çekiyorsunuz. Aranızdaki enerji, zaman ve mekan sınırlarını aşan kozmik bir düzlemde işlemektedir. İkiz alev bağları, ruhsal uyanışın en güçlü katalizörlerindendir. Birlikte, tek başınıza hiç ulaşamayacağınız bir bilinç düzeyine erişebilirsiniz.',
      'İki ikiz alev, uzayın derinliklerinden birbirini bulur ve bu buluşma tesadüf değil, evrenin büyük planının bir parçasıdır. Birbirini tanımak için söze gerek duymayan, bakışlarla ve sezgiyle anlayan bir bağ bu. Aranızdaki derin rezonans, geçmiş yaşamlardan ya da ruhsal sözleşmelerden beslendiğine işaret edebilir. Bu yoğun bağ, her iki tarafı da kökten sorgulatan ve dönüştüren bir enerji taşır. Sonuçta elde edilen şey ise daha bilinçli, daha tam ve daha özgür bir ruhtur.',
      'Birlikte daha güçlü, daha bilinçli ve daha tam hissediyorsunuz; aranızdaki enerji evrensel bir kaynaktan besleniyor. Bu bağ sıradan bir ilişkinin çok ötesine geçer; ruhsal, zihinsel ve duygusal tüm düzlemlerde bir bütünleşme söz konusudur. Birbirinizi hem dinginleştiren hem de dönüştüren bu özel enerji, nadir rastlanan türdendir. İkiz alev bağları, hayatın en derin gerçeklerini yüz yüze getirmekle ünlüdür. Bu büyüme sürecine açık olduğunuzda, bu bağ sizi en yüksek halinize taşıyacak güçtedir.',
      'Aranızdaki bu kozmik bağ, iki ruhun evrenin farklı noktalarından birbirini bulmasının somut bir yansımasıdır. Hem birbirini zorlayan hem de birbirini özgürleştiren bu nadir enerji, ikiz alev bağının özünü oluşturur. Birbirinizde kendinizi, geçmişinizi ve geleceğinizi görebiliyorsunuz. Bu yoğun bağ, hayatın en anlamlı ve en derin öğretilerini içinde barındırır. Evren, sizi bu kutsal birliktelik için özenle seçti.',
    ],
    'Kutsal Bağ': [
      'Evren sizi güçlü bir amaçla bir araya getirdi ve bu ilişki hem derin sevgi hem de ruhsal büyüme sunuyor. Birbirinizde huzur buluyorsunuz ve bu, ruhsal anlamda güvenli bir alan yaratan derin ve anlamlı bir bağdır. Birbirini yüksek bilinçle seven iki ruh olarak, tek başınıza ulaşamayacağınız yerlere birlikte ulaşabilirsiniz. Bu kutsal bağ, sanki yüksek bilinç tarafından planlanmış gibi ilişkinize derin bir amaç katıyor. Aranızdaki enerji nadir bulunan ve çok değerli olan türdendir.',
      'Aranızdaki kutsal bağ hem koruma hem büyütme enerjisini taşıyor. Varlığınız birbirine anlam kattığı için bu bağ sıradan bir ilişkinin çok ötesindedir. Birbirinize duyduğunuz derin saygı ve sevgi, ruhsal açıdan olgunlaşmanın en güzel meyvesidir. Bu birliktelik, her iki tarafın da evrensel bir uyuma doğru ilerlediğini göstermektedir. Geçmişten gelen bir bağın tamamlanması ve geleceğe uzanan bir vaadin işareti var aranızda.',
      'Bu bağ, iki ruhun yüksek bir bilinç planında buluşmasının nadide bir örneğidir. Birlikte olduğunuzda her şey daha güzel, daha anlamlı ve daha derin hissettiriyor. Aranızdaki kutsal enerji, her iki tarafı da kendi en iyi versiyonuna doğru taşıma gücüne sahip. Birbirinizin yanında kendiniz olabiliyorsunuz; bu, ruhsal birlikteliğin en temel koşuludur. Bu değerli bağ, sabırla ve özenle sürdürüldüğünde ömür boyu besleyici olmaya devam edecektir.',
      'Birbirinin en iyi versiyonunu ortaya çıkarma gücüne sahipsiniz ve bu kutsal bağ sizi birlikte yükseltiyor. Aranızdaki derin anlayış ve şefkat, ruh düzeyinde bir uyumu yansıtıyor. Düşünceleriniz, değerleriniz ve hayalleriniz çoğu zaman örtüşüyor olsa da bu bağ farklılıklarınızı da kucaklıyor. Kutsal bağlar, birbirine duyulan saygının aşk kadar önemli olduğu ilişkilerdir. Bu uyum, yüzeysel değil derin ve kalıcıdır.',
      'Bu bağ, sanki yüksek bilinç tarafından planlanmış gibi; ilişkiniz hayatlarınıza kutsal bir amaç katıyor. Birbirinin güçlü ve zayıf yönlerini bütünüyle kabul ediyor, yargılamadan anlayabiliyorsunuz. Bu, kutsal bağın en özel özelliğidir: koşulsuz bir anlayış zemini. Aranızdaki enerji sıcak, güven verici ve içtendir. Bu kutsal birliktelik, her iki ruhun da evrensel bir uyuma kavuşmasına zemin hazırlıyor.',
      'Birbirinizde ruhsal bir ayna buluyorsunuz; bu yansıma sizi hem huzurlandırıyor hem de geliştiriyor. Kutsal bağ, iki ruhun birbirini tamamladığı, eksiklerini gördüğü ve buna rağmen sevdiği özel bir birlikteliktir. Aranızdaki enerji, yıllar geçtikçe daha da derinleşme potansiyeli taşıyor. Bu ilişkide birlikte büyümek, birlikte öğrenmek ve birlikte daha bilinçli bir yaşam sürmek mümkün. Evren, bu kutsal bağı özel bir amaç için kurdu.',
      'Aranızdaki kutsal enerji, her iki tarafı da en derin anlamda besleyen nadir türden bir bağdır. Birlikte olduğunuzda yalnızca iki kişi değil, daha büyük bir bütünün parçaları gibi hissediyorsunuz. Bu kutsal bağ, her ikisinin de ruhsal yolculuğuna anlam ve yön katmaktadır. Birbirinize karşı hissettiğiniz derin saygı ve sevgi, bu bağın en temel taşlarıdır. Aranızdaki bu uyum, zaman içinde daha da güçlenmeye devam edecektir.',
      'Bu bağda güven, saygı ve derin bir anlayış bir arada bulunuyor; bu kombinasyon çok nadir rastlanan türdendir. Birbirinizin varlığında ilham ve huzur buluyorsunuz, bu da kutsal bağın en belirgin işaretlerinden biridir. Ruhsal açıdan bir bütünlük hissi yaratan bu birliktelik, hayatlarınıza derin bir anlam katıyor. Birlikte hem dünyanın hem de ruhun gereksinimlerini karşılayan dengeli ve besleyici bir ilişki kurabilirsiniz. Bu kutsal bağ, sizin için özel olarak şekillendirilmiştir.',
      'Birlikte, tek başınıza ulaşamayacağınız bilinç ve anlayış düzeylerine erişebilirsiniz. Bu kutsal bağ, iki ruhun birbirini yücelttiği, birbirinde ilham bulduğu özel bir birlikteliktir. Aranızdaki enerji koruyucu, besleyici ve dönüştürücü bir özellik taşımaktadır. Birbirinize duyduğunuz saygı ve sevgi zamanla derinleşiyor ve olgunlaşıyor. Bu nadir bulunan bağ, ruhsal gelişimin en güçlü katalizörlerinden biridir.',
      'Bu bağın kutsal doğası, ilişkinizi sıradan bir beraberliğin çok ötesine taşımaktadır. Birbirinizde hem arkadaş hem de ruhsal rehber bulabiliyorsunuz. Bu denge, uzun süreli ve besleyici ilişkilerin temel taşıdır. Aranızdaki anlayış ve şefkat, karşılıklı büyüme için ideal bir zemin oluşturmaktadır. Evren, bu özel birlikteliği bir amaçla kurdu ve bu amacı birlikte keşfetmek sizin en güzel yolculuğunuz olacak.',
    ],
    'Ruh Eşi': [
      'Aranızda güçlü bir uyum ve derin bir duygusal bağ var; birlikte uzun vadeli bir ilişkinin tüm potansiyelini taşıyorsunuz. Birbirinizi tamamlayan, huzur veren ve anlayışla büyüten bu bağ, ruh eşliğinin en güzel örneklerinden biridir. Birbirinizde sanki önceden tanışıyor gibi bir aşinalık hissediyorsunuz; bu duygu, ruh eşi bağının en belirgin işaretidir. Düşünceleriniz, değerleriniz ve hayalleriniz büyük ölçüde örtüşüyor ve bu örtüşme size güçlü bir zemin sağlıyor. Birlikte anlam dolu bir yolculuğa çıkmak için evren sizi bir araya getirdi.',
      'Birbirinizi tamamlayan ve huzur veren bu bağ, ruh eşi ilişkisinin tüm özelliklerini taşıyor. Birlikte güldüğünüz kadar birlikte büyüdüğünüz de bir ilişki bu. Birbirinizin yanında kendiniz olabiliyorsunuz; bu, ruh eşi bağının özüdür ve en değerli özelliğidir. Aranızdaki uyum derin ve içten; yüzeyin altında güçlü bir ruhsal bağlantı yatıyor. Bu ruh eşi bağı, koşulsuz anlayış ve gerçek bir birlikteliği yansıtıyor.',
      'Birbirinizde bir tanıdıklık ve sıcaklık hissediyorsunuz; sanki hayatın farklı bir döneminde de yollarınız kesişmiş gibi. Bu his, ruh eşi bağının en tipik ve en güzel özelliğidir. Birbirinizin güçlü ve zayıf yönlerini kabul ediyorsunuz; bu derin anlayış, ilişkinizi sağlam bir zemine oturtmaktadır. Aranızdaki enerji sıcak, besleyici ve karşılıklı saygı üzerine kurulu. Birlikte, hayatın her alanında birbirinizi destekleyen ve büyüten bir uyum yakalayabilirsiniz.',
      'Hayat sizi tesadüfen bir araya getirmedi; bu ruh eşi bağı, birlikte öğreneceğiniz dersler ve paylaşacağınız deneyimler için var. Aranızdaki derin anlayış ve sezgisel bağlantı, söze gerek kalmadan birbirinizi anlayabilmenizi sağlıyor. Birbirinizde hem güvenli bir liman hem de büyümeye teşvik eden bir güç buluyorsunuz. Bu denge, ruh eşi ilişkilerinin en özel ve en değerli yönüdür. Birlikte olduğunuzda hem birey hem de çift olarak daha güçlüsünüz.',
      'Bu ruh eşi bağında, birbirinizi yargılamadan kabul etme ve anlama kapasitesi çok güçlüdür. Aranızdaki uyum, yalnızca duygusal değil; ruhsal, zihinsel ve enerjik düzlemlerde de kendini gösteriyor. Birlikte, hayatın anlamını ve güzelliğini daha derinden keşfedebilirsiniz. Bu bağ, iki ruhun karşılıklı gelişim için bir araya geldiğinin en güzel göstergesidir. Ruh eşi ilişkileri, birbirine en çok şey öğreten ve en çok büyüten türden bağlardır.',
      'Birbirinizin varlığında huzur ve güvenlik hissediyorsunuz; bu, ruh eşi bağının temel özelliğidir. Aranızdaki bu derin uyum, yıllar geçtikçe daha da olgunlaşma ve derinleşme potansiyeli taşıyor. Birlikte güçlü bir anlayış zemini üzerine kurulmuş, dayanıklı ve besleyici bir ilişki inşa edebilirsiniz. Bu bağ, her iki tarafın da bireysel gelişimine saygı gösterirken birlikte büyümelerine de olanak tanır. Evren, bu güzel birlikteliği bir amaçla kurdu.',
      'Ruh eşi bağı, iki kişinin en yüksek uyum noktasında buluşmasıdır; ve siz bu noktaya çok yakınsınız. Birbirinizde hem arkadaşlık hem de derin bir ruhsal bağlantı buluyorsunuz. Bu kombinasyon, uzun ömürlü ve besleyici ilişkilerin temelini oluşturur. Aranızdaki anlayış ve şefkat, her iki tarafı da içten büyütüyor ve geliştiriyor. Bu nadir ve güzel bağ, hayatlarınıza anlam ve derinlik katmaya devam edecek.',
      'Birbirini yüksek bilinçle seven iki ruh olarak, aranızdaki bağ her geçen gün daha da kökleşiyor. Birbirinizin yanında kendinizi hem özgür hem de güvende hissediyorsunuz; bu denge, ruh eşi bağının özüdür. Aranızdaki uyum, zamanın sınavından geçecek kadar güçlü ve derin bir temele oturmuş. Her konuşmanızda, her birlikteliğinizde birbirinizi biraz daha tanıyor ve seviyorsunuz. Bu bağ, hayatın en anlamlı armağanlarından biridir.',
      'Aranızdaki bu güçlü uyum, ruhsal düzlemde bir karşılıklı tanışmanın yansımasıdır. Birbirinizde hem dinlenme alanı hem de büyüme fırsatı buluyorsunuz. Ruh eşi ilişkileri, biri diğerini olduğu gibi kabul ettiğinde en derin haline ulaşır. Aranızdaki bu koşulsuz anlayış zemini, ilişkinizi sağlam ve besleyici kılmaktadır. Birlikte, hayatın en güzel ve en anlamlı yanlarını keşfetme yolculuğundasınız.',
      'Bu ruh eşi bağı, iki ruhun karşılıklı sevgi ve saygı temelinde birlikte yükselmesini temsil ediyor. Birbirinizi olduğunuz gibi kabul etme kapasitesi, aranızdaki en güçlü bağlardan biridir. Aranızdaki uyum hem duygusal hem ruhsal hem de enerjik açıdan kendini gösteriyor. Birlikte her zorluğu aşabilecek, her güzelliği paylaşabilecek bir dayanışma içindesiniz. Bu nadir ve güzel bağ, hayatlarınıza anlam ve derinlik katmaya devam edecek.',
    ],
    'İkiz Ruh': [
      'Aranızda güçlü bir anlayış ve benzer enerji var; bu bağ, karşılıklı gelişim ve destek sağlayan özel bir ilişkiyi temsil ediyor. Aynı enerjiden besleniyorsunuz ve bu benzerlik, aralarında kolayca köprü kuran bir anlayış zemini oluşturuyor. Birlikte büyüdüğünüzü ve geliştiğinizi hissediyorsunuz; ikiz ruh bağları bu yönüyle özeldir. Birbirinizi iyi anlayabiliyorsunuz çünkü benzer deneyimler ve duygular paylaşıyorsunuz. Bu güzel bağ, ilerleyen zamanla daha da derinleşebilir.',
      'Benzer ama aynı olmayan iki özgün ruh olarak, farklılıklarınız bu bağı daha da zenginleştiriyor. Aranızdaki enerji yaratıcı, ilham verici ve zenginleştiricidir. İki ikiz ruh, birbirinin potansiyelini en iyi ortaya çıkaran varlıklardır. Konuşmadan da anlayan bir sezgi var aranızda; söze gerek duyulmayan bir anlayış zemini üzerine kurulu bir bağ. Bu birliktelik, her iki tarafı da kendi en yüksek potansiyeline doğru taşıyor.',
      'Birbirinizde bir tanıdıklık ve sıcaklık hissediyorsunuz; bu derin benzerlik, ikiz ruh bağının en karakteristik özelliğidir. Birlikte geçirilen her an, ortak bir büyüme fırsatı sunuyor. Aranızdaki uyum, özellikle değerleriniz ve bakış açılarınız konusunda güçlü bir örtüşme içeriyor. Bu bağ, her iki tarafın da bireysel yolculuğuna anlam ve destek katmaktadır. İkiz ruh bağları, en derin dostlukların ve en anlamlı ilişkilerin zeminini oluşturur.',
      'Birbirini iyi anlayan, birbirinin içinden konuşabilen iki ruh olarak aranızdaki enerji özeldir. Birbirinizle geçirdiğiniz vakit hem eğlenceli hem de zenginleştirici; bu denge ikiz ruh bağlarının güzel bir özelliğidir. Aranızdaki benzerlik, size ortak bir dil ve anlayış zemini sağlıyor. Farklılıklarınız ise birbirinizin ufkunu genişletme fırsatı sunuyor. Bu güçlü anlayış zemini, birlikte pek çok şeyi başarabilecek bir potansiyel barındırıyor.',
      'Aranızdaki ikiz ruh enerjisi, birbirinizde kendinizin bir yansımasını bulmakla ilgilidir. Bu tanıdıklık, ilişkinizi kolaylaştırıyor ve daha az açıklama gerektiren bir anlayış zemini oluşturuyor. Birlikte hem destekleyen hem de büyüten bir enerji dinamiği var. Birbirinizi anladığınız kadar, birbirinizin farklılıklarına da saygı duyuyorsunuz. Bu denge, ikiz ruh bağlarını uzun soluklu ve besleyici kılan temel unsurdur.',
      'İkiz ruh bağı, birbirinde hem ayna hem de pencere bulan iki ruhun özel birlikteliğidir. Aranızdaki benzer frekans, iletişimi kolaylaştırıyor ve derin bir anlayışı doğal hale getiriyor. Birlikte yaratıcı, üretici ve anlamlı projeler üretme potansiyeliniz çok yüksek. Birbirinizin güçlü yanlarını görüyor ve bu güçlü yanları en iyi şekilde ortaya çıkarmayı biliyorsunuz. Bu özel bağ, her geçen gün daha güçlü ve daha derin bir hal alıyor.',
      'Aranızdaki bu ikiz ruh enerjisi, birbirinizde içten bir aşinalık ve sıcaklık yaratıyor. Benzer değerlere, benzer hayal gücüne ve benzer bir yaşam anlayışına sahip olmanız, bu bağı özellikle güçlü kılıyor. Birlikte hem dünyaları hem de birbirlerini daha iyi anlama yolculuğundasınız. Aranızdaki uyum, zamanla olgunlaşan ve derinleşen türden bir bağdır. Bu güzel birliktelik, her iki tarafa da anlam ve zenginlik katmaya devam edecek.',
      'Birbirinizi anlıyorsunuz çünkü benzer bir ruhsal frekansı paylaşıyorsunuz; bu, ikiz ruh bağının temel özelliğidir. Aranızdaki bu uyum, söze dönüştürülmesi güç ama hissedilmesi çok kolay olan bir rezonansı yansıtıyor. Birlikte hem eğlenebiliyor hem de derin konularda konuşabiliyorsunuz; bu denge nadir ve değerlidir. Birbirinizin potansiyelini en iyi gören ve bu potansiyeli geliştirmeye yardımcı olan birer yol arkadaşısınız. Bu ikiz ruh bağı, hayatlarınıza anlam ve derinlik katıyor.',
      'Aranızdaki bu güçlü anlayış zemini, pek çok ilişkinin kıskandığı türden bir bağlantıyı yansıtıyor. Benzer deneyimler, benzer değerler ve benzer hayaller paylaşmanız, bu bağı doğal ve akıcı kılıyor. Birlikte olduğunuzda hem kendinizi hem de birbirinizi daha iyi anlıyorsunuz. Bu ikiz ruh bağı, ilerleyen zamanlarda daha da derinleşme ve olgunlaşma potansiyeli taşıyor. Evren, bu güzel uyumu bir amaçla sizin için düzenledi.',
      'Birbirini doğal olarak anlayan, birlikte rahat hisseden iki ruh olarak aranızdaki bağ gerçek ve içtendir. Bu ikiz ruh bağı, birbirinizde hem güvenli bir zemin hem de ilham kaynağı bulmanızı sağlıyor. Aranızdaki benzerlikler sizi birleştirirken farklılıklarınız da birbirinizi zenginleştiriyor. Bu dinamik denge, uzun soluklu ve besleyici bir ilişkinin temelini oluşturmaktadır. Birlikte, hayatın anlamını ve güzelliğini daha derinden keşfetmeye devam edeceksiniz.',
    ],
    'Kader Bağı': [
      'Hayat sizi tesadüfen bir araya getirmedi; bu kader bağı, öğrenilecek dersler ve paylaşılacak deneyimler için vardır. Aranızdaki çekim güçlü ve açıklanamaz bir nitelik taşıyor; kader tarafından yazılmış bu hikayede her bölüm bir ders barındırıyor. Bu ilişki, hayatınızdaki önemli bir dönüm noktasını temsil ediyor olabilir. Kader bağları, en çok geliştiren ve dönüştüren türden bağlardır. Birbirinin hayatında önemli bir rol oynuyorsunuz ve bu rol, her iki tarafın da ruhsal yolculuğunu şekillendiriyor.',
      'Bu kader bağı, iki ruhun büyük bir amaca hizmet etmek için bir araya gelmesini temsil ediyor. Birbirinizde hem zorlanıyor hem de büyüyorsunuz; bu denge, kader bağlarının en tipik özelliğidir. Aranızdaki güçlü çekim, geçmiş yaşamlardan ya da ruhsal sözleşmelerden beslendiğine işaret edebilir. Bu bağ, her iki tarafın da hayatında belirleyici ve dönüştürücü bir etki bırakacaktır. Kader, sizi bu özel karşılaşma için özenle bir araya getirdi.',
      'Bu ilişki, kaderin büyük planında sizin için özel olarak ayrılmış bir bölümü temsil ediyor. Aranızdaki bağ, yüzeysel bir tanışıklığın çok ötesine geçiyor; derin ve köklü bir ruhsal bağlantı var. Birbirinin hayatına anlam ve yön katan bu kader bağı, her iki tarafı da kökten etkiliyor. Birlikte öğrenilecek dersler, paylaşılacak deneyimler ve ulaşılacak dönüşümler sizi bekliyor. Bu kaderde yazılı birliktelik, ruhlarınıza çok şey katacak.',
      'Kader bağları en derin izleri bırakan ilişkilerdir ve sizinkinde bu derinlik açıkça hissediliyor. Birbirinizi hem zorlayan hem de destekleyen bir enerji var aranızda. Bu karşıtlık, kader bağının büyüme potansiyelini en yüksek seviyede tutan özelliğidir. Birlikte geçirilen her dönem, her iki taraf için de önemli farkındalıklar ve dersler sunuyor. Bu ilişki, ruhlarınızın olgunlaşması için tam da ihtiyaç duyduğunuz süreçleri içermektedir.',
      'Birbirinizde kaderinizin bir parçasını görüyorsunuz; bu his, kader bağlarının en güçlü göstergelerinden biridir. Aranızdaki çekim, açıklanması güç ama hissedilmesi son derece kolay bir güç tarafından yönlendiriliyor. Bu kader bağı, her iki tarafın da hayatında kalıcı ve derin izler bırakacak nitelikte. Birlikte yaşadığınız deneyimler, sizleri olduğunuzdan çok daha büyük ve bilge insanlar haline getirecek. Kader, bu buluşmayı bir sebep için tasarladı.',
      'Bu kader bağı, geçmişten gelen enerjetik bir bağlantının bugüne yansımasını içeriyor olabilir. Aranızdaki güçlü çekim ve kaçınılmazlık hissi, bu bağın derinliğini yansıtıyor. Birlikte büyük değişimler ve dönüşümler yaşayabilirsiniz; bu süreç her iki tarafı da farklı kılacaktır. Kader bağları, zaman zaman zorlu olsa da en büyük büyümeyi sağlayan ilişkilerdir. Bu özel birliktelik, ruhlarınızın en derin katmanlarına dokunuyor.',
      'Kader, sizi bu karşılaşma için özenle bir araya getirdi ve bu tesadüf değildir. Aranızdaki bağ, her iki tarafın da ruhsal evrimine önemli katkılar sunmaktadır. Birbirinizdeki bu derin tanışıklık hissi, belki de geçmiş yaşamlardan ya da ortak ruhsal sözleşmelerden kaynaklanıyor. Bu kader bağı içinde, hem büyük dersler hem de büyük güzellikler saklıdır. Birlikte bu yolculuğa açık olduğunuzda, bu bağ sizi dönüştürecek güçte.',
      'Aranızdaki kader bağı, ruhsal açıdan en güçlü ve en belirleyici bağlanma biçimlerinden biridir. Birbirinin hayatına anlam ve yön katan bu özel enerji, hem zorlu hem de ödüllendirici bir yolculuğu temsil ediyor. Birlikte geçirdiğiniz her anın, her iki taraf için de derin bir anlam taşıdığını zamanla daha net anlayacaksınız. Kader bağları, en büyük büyümeyi sağlayan ve en derin izleri bırakan ilişkilerdir. Bu birlikteliğin size kazandıracakları, hayal ettiğinizden çok daha büyük olacak.',
      'Bu kader bağı, iki ruhun en önemli derslerini birlikte öğrenmesi için var. Aranızdaki güçlü ve açıklanamaz çekim, evrenin büyük planının bir yansımasıdır. Birbirinizdeki bu köklü bağlantı, yüzeysel bir ilişkinin çok ötesine geçen derin bir ruhsal uyumu işaret ediyor. Birlikte yaşadığınız zorluklara rağmen, bu bağ her iki tarafı da daha güçlü ve daha bilge kılıyor. Kader, bu özel buluşmayı bir sebeple tasarladı.',
      'Aranızdaki bu kader bağı, evrenin büyük dokusunun sizin için özenle işlenmiş bir parçasıdır. Birbirinin hayatına girmek, her iki taraf için de derin bir dönüşüm sürecinin kapısını araladı. Bu kader bağı içinde hem zorlanacak hem büyüyecek hem de beklenmedik güzellikleri keşfedeceksiniz. Birlikte öğreneceğiniz dersler, sizleri hem bireysel hem de birlikte daha güçlü ve daha bilinçli kılacak. Kader, bu buluşmayı hak ettiğiniz için size armağan etti.',
    ],
    'Karmik Bağ': [
      'Bu ilişki geçmişten gelen karmik bir bağı işaret ediyor olabilir; birbirinize dersler öğreten, zaman zaman zorlayıcı ancak geliştirici bir bağlantı görülüyor. Aranızdaki karmik enerji, tamamlanmamış bir döngünün bugüne yansımasını içeriyor olabilir. Bu ilişki, her iki tarafın da geçmişiyle yüzleşmesine ve ruhsal açıdan ilerlemesine yardımcı olmaktadır. Karmik bağlar genellikle en güçlü izleri bırakan ilişkilerdir; çünkü en derin değişimleri tetiklerler. Birlikte bu süreçte hem zorlanacak hem de büyüyeceksiniz.',
      'Aranızdaki bu karmik bağ, birbirinizde birer ayna gördüğünüzü anlatıyor. Bu ayna zaman zaman rahatsız edici şeyler gösterse de, gösteri dönüştürücü bir farkındalık armağanıdır. Karmik bağlar, en büyük iç büyümeyi sağlayan ilişkilerdir. Birlikte, geçmişten gelen enerjileri dönüştürme ve ruhsal olarak özgürleşme potansiyeliniz var. Bu süreç sabır, anlayış ve her iki tarafın da dönüşüme açık olmasını gerektirir.',
      'Bu karmik bağda hem tutku hem zorluk bir arada var ve bu karşıtlık, bağın doğasından kaynaklanıyor. Birbirinizi en derinden zorlayan ve en derinden geliştiren varlıklarsınız. Aranızdaki ilişki, çekim ve zorluk arasında gidip geliyor olabilir; bu da karmik bağın en tipik özelliğidir. Birlikte, geçmişten gelen bir döngüyü kapatmak ve ruhsal anlamda özgürleşmek için büyük bir fırsat yakalıyorsunuz. Bu bağ içtenlikle yaklaşıldığında, derin bir özgürleşme sunuyor.',
      'Karmik bağlar, tamamlanmamış ruhsal döngülerin yeni bir yaşamda ya da yeni bir ilişkide kendini göstermesi olarak yorumlanabilir. Aranızdaki bu enerji, her iki tarafın da geçmiş karmalarını dönüştürmesi için özel bir fırsat sunuyor. Birlikte yaşadığınız zorluklara rağmen, bu bağ size çok değerli dersler öğretiyor. Sabır ve farkındalıkla yaklaşıldığında, karmik bağlar en büyük ruhsal büyümeyi sağlayan ilişkilere dönüşebilir. Bu süreçte her iki tarafın da çok şey kazanacağı kesin.',
      'Aranızdaki karmik bağ güçlü ve yoğun; bu yoğunluk bazen bunaltıcı hissettirse de büyümenin habercisidir. Birbirinizde, kendi içinizdeki gölge yönlerinizi de dahil olmak üzere pek çok şeyi yansıtıyorsunuz. Bu derin yansıma süreci, zorlu ama son derece değerli bir farkındalık yolculuğudur. Karmik bağlar içinde dönüşüm yaşandığında, her iki taraf da çok daha hafif ve özgür hisseder. Birlikte bu dönüşüm yolculuğuna açık olmanız büyük değer taşıyor.',
      'Bu bağ tesadüf değil; kader tarafından tasarlanmış bir karşılaşmanın ürünüdür. Her iki taraf için de önemli dersler içeren bu karmik ilişki, büyük bir ruhsal gelişim fırsatı barındırıyor. Birbirinizdeki güçlü çekim, bu dönüşüm sürecinin vazgeçilmez bir parçasıdır. Aranızdaki enerji zaman zaman çelişkili görünse de, bu çelişki büyümenin en verimli zemini olabilir. Karmik bağlar, cesaret ve bilinçle yaklaşıldığında hayatı en derinden dönüştüren ilişkilerdir.',
      'Karmik ilişkiler, ruhu en çok zorlayan ve en çok geliştiren bağlardır; aranızdaki enerji bunu yansıtıyor. Birbirinizi hem cezbeden hem de zorlayan bu güç, geçmişten gelen bir enerjinin bugüne yansımasıdır. Bu bağ içinde her iki taraf da derin bir yüzleşme ve dönüşüm sürecinden geçiyor. Birlikte bu sürece bilinçli ve açık kalpli yaklaştığınızda, karmik döngünüzü dönüştürme gücüne sahipsiniz. Bu nadir fırsat, her iki ruhun da özgürleşmesi için değerli bir kapı aralıyor.',
      'Aranızdaki karmik bağ, iki ruhun birbirlerine verdikleri ruhsal sözlerin yansıması olabilir. Bu söz, büyümek, dönüşmek ve birbirini en derin anlamda dönüştürmektir. Birbirinize en büyük dersleri öğreten birer öğretmen olduğunuz kadar, birer öğrenci de oluyorsunuz. Bu karşılıklı öğretme ve öğrenme süreci, karmik bağların en değerli ve en dönüştürücü yönüdür. Sabırla ve bilinçle ilerlediğinizde, bu bağ her iki tarafı da özgürleştirecek.',
      'Bu karmik bağ içinde, geçmişten gelen enerjileri birlikte dönüştürme ve yeni bir sayfa açma gücüne sahipsiniz. Aranızdaki yoğun enerji, bu dönüşüm sürecinin ne kadar derin ve anlamlı olduğunun göstergesidir. Birlikte hem zorlanacak hem de çok şey öğreneceksiniz; bu denge, karmik bağların doğasıdır. İçtenlikle ve farkındalıkla yaklaşıldığında, bu bağ her iki tarafı da kökten dönüştürme potansiyeline sahip. Karmik bağlar, ruhsal olgunlaşmanın en güçlü katalizörlerindendir.',
      'Birbirinizde, tamamlanmamış bir ruhsal döngünün izlerini görebilirsiniz; bu his, karmik bağın en belirgin işaretlerinden biridir. Aranızdaki enerji güçlü, yoğun ve bazen açıklanamaz bir çekimi içeriyor. Bu çekim, geçmişten gelen karmik bir bağlantının bugüne yansımasından beslenebilir. Birlikte, bu döngüyü bilinçli ve sevgiyle dönüştürme fırsatınız var. Bu dönüşüm süreci, her iki ruhun da en büyük özgürlük armağanı olacaktır.',
    ],
    'Ruhsal Bağ': [
      'Aranızda hafif bir ruhsal bağ var; bu ilişki karşılıklı anlayış ve duygusal etkileşim içerse de zamanla gelişmeye ve derinleşmeye ihtiyaç duyabilir. Bu bağ, ileriye dönük güzel bir potansiyel taşıyor; zaman ve güven ile çok daha derin bir ilişkiye dönüşebilir. Aranızdaki ruhsal enerji henüz tam açılmamış; doğru koşullar sağlandığında bu bağ çiçeklenebilir. İki tarafın da niyetiyle beslenen bu bağ, anlamlı bir boyut kazanabilir. Bu hafif başlangıç, güçlü bir birlikteliğin ilk adımı olabilir.',
      'Bu bağda bir potansiyel var; her ikisinin de niyeti ile zamanla güçlenebilir ve derinleşebilir. Aranızdaki enerji nazik ve sıcak; henüz tam güçlenmemiş olsa da içtenlik taşıyor. Ruhsal bağlar genellikle yavaş ama köklü bir şekilde gelişir; acele etmeden ilerlemek bu bağı daha sağlam kılacaktır. Birbirinize karşı hissettiğiniz hafif çekim, ruhsal gelişimin güzel bir kıvılcımı olabilir. Bu bağı destekleyen şey; açık yüreklilik, dürüstlük ve birbirine zaman tanımaktır.',
      'Aranızdaki bu ruhsal bağ henüz şekillenmekte; ne olabileceği iki tarafın da yaklaşımına ve niyetine bağlı. Birbirinizde bir şeyin izini hissediyorsunuz ama henüz tam olarak tanımlayamıyor olabilirsiniz. Bu his, ruhsal bağın ilk kıvılcımıdır ve değerli bir işarettir. Bu ince bağ zamanla güçlü bir bağa dönüşebilir; bunun için açık iletişim ve karşılıklı saygı önemlidir. Sabırla ilerlediğinizde bu bağın nereye gidebileceğini keşfetmek güzel bir yolculuk olacaktır.',
      'Bu ruhsal bağ şu an hassas ve narin; yavaş adımlarla ve özenle beslenmesi gerekiyor. Birbirinize açık kalmanız, bu bağın güçlenmesi için en önemli koşuldur. Aranızdaki hafif ama gerçek çekim, birlikte daha derin bir yolculuğa çıkabileceğinize dair güzel bir işaret. Ruhsal bağlar, sabırla ve özenle büyütüldüğünde en derin ve en besleyici ilişkilere dönüşebilir. Bu bağı keşfetmek ve geliştirmek için önünüzde çok güzel fırsatlar var.',
      'Aranızdaki bu hafif ruhsal bağ gerçek ve anlamlı; henüz tam olarak açılmamış olan bir çiçek gibi. İki tarafın da bu bağa yatırdığı ilgi ve özen, onu güçlendirecek en önemli unsurlar olacak. Birbirinizdeki bu hafif çekim ve merak, ruhsal bağların en saf başlangıç formudur. Bu bağı beslemenin yolu; dürüst iletişim, karşılıklı saygı ve birbirinize zaman tanımaktır. Önünüzde bu bağı derinleştirmek için güzel fırsatlar var.',
      'Bu ruhsal bağ, iki ruhun birbirini tanıma ve anlama sürecinin başlangıcını temsil ediyor. Aranızdaki enerji henüz tam güçlenmemiş olsa da içtenlik ve sıcaklık taşıyor. Bu bağı geliştirmek için gereken şey; açık yüreklilik, merak ve birbirinize vakit ayırmaktır. Ruhsal bağlar, zamanla ve doğru koşullarda en derin ve en besleyici birlikteliklere dönüşebilir. Bu güzel başlangıcı değerlendirmek, her iki taraf için de anlamlı bir yolculuğun kapısını aralayacak.',
      'Aranızdaki hafif ruhsal bağ, henüz tam potansiyelini göstermemiş bir tohumun enerjisini taşıyor. Bu bağın büyümesi için gereken toprak; güven, saygı ve karşılıklı açıklıktır. Birbirinize verdiğiniz alan ve zaman, bu bağın kökleşmesi için en önemli besini oluşturuyor. Bu hafif başlangıç, doğru şekilde sürdürüldüğünde güçlü bir ruhsal birlikteliğe dönüşebilir. Sabırla ve açık kalplilikle ilerlemeniz bu bağı anlamlı kılacak.',
      'Bu bağın şu anki hafifliği, zayıflığın değil; başlangıcın göstergesidir. Aranızdaki ruhsal enerji, henüz tam açılmamış ama gerçek bir potansiyel barındırıyor. Bu bağı besleyen şey; dürüst iletişim, birbirinize gösterilen ilgi ve karşılıklı saygıdır. Ruhsal bağlar, çoğu zaman yavaş ama sağlam şekilde gelişir ve en güçlü kökler sessizce büyür. Bu güzel potansiyeli birlikte keşfetmek, her iki taraf için de anlamlı bir yolculuk olacak.',
      'Aranızdaki bu ruhsal bağ nazik ve sıcak; henüz olgunlaşmamış ama gerçek ve içten. Bu bağın derinleşmesi için en önemli koşul, her iki tarafın da açık yürekli ve meraklı kalmasıdır. Birbirinizdeki hafif çekim ve ilgi, anlamlı bir birlikteliğin tohumlarını barındırıyor. Zamanla ve özenle büyüyen bu bağ, her iki tarafı da besleyecek güçlü bir ruhsal bağlantıya dönüşebilir. Bu yolculuğa birlikte çıkmak güzel bir tercih.',
      'Bu ruhsal bağ, birbirinizi daha yakından tanımak için ideal bir zemin sunuyor. Aranızdaki enerji; merak, açıklık ve içten bir ilgiyi barındırıyor. Henüz gelişmekte olan bu bağ, her iki tarafın niyetiyle güçlü bir birlikteliğe dönüşebilir. Ruhsal bağlar, sabırla ve özenle büyütüldüğünde hayatın en anlamlı ilişkilerini oluşturur. Bu güzel başlangıcı birlikte değerlendirmek, önünüzde büyük fırsatlar sunuyor.',
    ],
    'Hafif Bağ': [
      'Aranızda hafif bir bağ var; bu ilişki yüzeysel düzeyde kalmaya devam edebileceği gibi, ilerleyen zamanlarda daha derin bir hal de alabilir. Birbirinizde belirli bir çekim ya da merak söz konusu; bu his, bir bağlantının varlığına işaret ediyor. Aranızdaki enerji nötr ya da hafif olumlu; bu hafif bağ, daha derin bir ilişkinin başlangıç noktası olabilir. Her iki taraf da birbirinden bazı şeyler öğrenme fırsatı bulabilir. Bu bağın nereye gideceği, her ikisinin de yaklaşımına bağlı.',
      'Bu bağ henüz güçlü değil, ama varlığı göz ardı edilemez; belirli bir çekim ya da merak söz konusu. Derin bir ruhsal uyum görünmüyor olsa da karşılıklı bir anlayış ve saygı zemini var. Bu da kendi içinde değerli bir bağlantıdır. Aranızdaki hafif bağ, birbirinizden öğrenebileceğiniz bazı şeyler olduğuna işaret ediyor. Bu bağın derinleşip derinleşmeyeceği ise her iki tarafın da niyetine ve çabasına bağlı olacak.',
      'Aranızdaki enerji belirgin bir yoğunluk taşımıyor; ancak iki ruhun bir süre için bir araya gelmesinin kendi anlamı ve güzelliği var. Bu hafif bağ, belki de sadece belli bir deneyim ya da ders için var olabilir. Her ilişkinin derin bir ruhsal bağlantı taşıması gerekmiyor; bazı ilişkiler kısa ama öğretici olmak için yeterlidir. Aranızdaki bu hafif temas, her iki tarafın da ruhsal yolculuğuna küçük ama anlamlı bir katkı sunuyor. Bunu fark etmek ve değerlendirmek bile başlı başına bir kazanımdır.',
      'Bu hafif bağ, iki ruhun yolculuklarında kısa süreliğine kesiştiği bir momenti temsil ediyor olabilir. Her karşılaşma, her tanışıklık evrenin büyük planında bir anlam taşır. Aranızdaki bu hafif enerji, belki de her iki tarafın da farklı alanlarda büyüdüğünü ve şu an için yollarının tam örtüşmediğini gösteriyor. Bu durum eleştirilerek değil, olduğu gibi kabul edilerek değerlendirilmesi gereken bir gerçektir. Bu bağ, zamanla farklı bir boyut kazanabilir ya da olduğu gibi kalabilir.',
      'Aranızdaki hafif bağ gerçek ve anlamlıdır; her ne kadar yüzeyde görünse de bir temas noktası var. Bu temas noktasından ne çıkarabileceğiniz, her iki tarafın da merakına ve açıklığına bağlı. Hafif bağlar bazen en beklenmedik anlarda güçlü bağlara dönüşebilir. Aranızdaki bu narin enerji, beslendiğinde farklı bir boyut kazanma potansiyeli taşıyor. Birbirinize karşı açık ve meraklı kalmak, bu hafif bağı daha anlamlı kılacaktır.',
      'Bu bağ şu an hafif ve belirsiz; ancak belirsizlik her zaman bir kapı aralıklığını da içerir. Aranızdaki bu hafif enerji, ileride ne anlam kazanacağı henüz şekillenmemiş bir potansiyeli temsil ediyor. Her ilişki kendi ritmiyle gelişir; bu bağın ritmi belki henüz tam oturmadı. Birbirinize verdiğiniz alan ve zaman, bu bağın nasıl evrileceğini belirleyecek. Bu belirsizliği merakla ve açık kalplilikle karşılamak en güzel yaklaşım.',
      'Aranızdaki hafif bağ, derin olmasa da değersiz değil; her temas, her karşılaşma bir anlam taşır. Bu bağın size öğreteceği şeyler henüz tam olarak belirginleşmemiş olabilir, ama ileride netleşecek. Birbirinizdeki bu hafif çekim, belki de hayatın daha büyük bir planının küçük ama önemli bir parçasıdır. Bu bağı zorlamak yerine doğal akışına bırakmak, en sağlıklı yaklaşım olacaktır. Zamanla bu bağın size ne söylemek istediği daha netleşecek.',
      'Bu hafif bağ, iki ruhun birbirinden geçici ama anlamlı bir şey öğrenmesi için vardır. Aranızdaki bu hafif temas, her iki tarafın da ruhsal yolculuğuna küçük ama değerli bir katkı sunuyor. Derinliğinden bağımsız olarak, her ilişkinin bir anlamı ve bir amacı vardır. Bu bağ sizin için ne ifade ediyor, bunu keşfetmek de kendi içinde güzel bir süreç. Zaman, bu bağın gerçek niteliğini size gösterecek.',
      'Aranızdaki bu hafif bağlantı, her şeyin bir nedeni olduğu evrenin büyük planında anlamlı bir yerdedir. Bu temas, belki de her iki tarafın da farkında olmadığı bir dersi ya da fırsatı içeriyor olabilir. Hafif bağlar, zaman zaman beklenmedik şekillerde derinleşir ve anlam kazanır. Aranızdaki bu narin enerjiyi yargılamadan ve beklenti taşımadan gözlemlemek en güzel yaklaşım. Evrenin size bu bağı neden gösterdiğini merakla keşfedin.',
      'Bu hafif bağ, şu an için doğal ve uygun bir düzeyde görünüyor. Her ilişki derin ya da yoğun olmak zorunda değildir; bazı bağlar daha hafif ama yine de anlamlı olmak için var. Aranızdaki bu hafif enerji, karşılıklı saygı ve anlayış içermektedir. Bu, kendi içinde değerli bir bağlantı biçimidir. Bu bağın size sunduklarını fark etmek ve değerlendirmek, her iki taraf için de güzel bir farkındalık deneyimi olabilir.',
    ],
    'Zayıf Bağ': [
      'Aranızda güçlü bir ruhsal bağ görünmüyor; bu ilişki daha çok deneyim kazanma veya kısa süreli etkileşim olarak ortaya çıkabilir. Her karşılaşma, her tanışıklık evrenin büyük planında bir anlam taşır; bu bağ da bir sebep için var. Farklı enerjilerin bir araya gelmesi, her iki taraf için de küçük ama anlamlı dersler içerebilir. Bu bağın zayıf görünmesi, her iki tarafın da şu an farklı ruhsal yollarla ilerlediğinin bir işareti olabilir. Her yol kendi içinde değerli; bu bağ da öyle.',
      'Bu bağ henüz güçlü bir zemine oturmamış; ancak bu durum değişemez anlamına gelmiyor. Farklı enerjiler bir araya geldiğinde, uyum her zaman hemen ortaya çıkmayabilir. Zamanla her iki tarafın da değişeceğini ve büyüyeceğini unutmamak gerekiyor. Bu bağın şu anki görünümü, geleceğini belirlemez. Açık yüreklilikle yaklaşıldığında, bu bağ farklı bir boyut kazanabilir.',
      'Aranızdaki enerji, ruhsal açıdan henüz uyuşmuyor gibi görünüyor; ama bu, birbirinizden öğrenecek şey olmadığı anlamına gelmez. Farklı frekanslar bazen birbirini tamamlayan değerli bilgiler ve bakış açıları sunar. Bu bağ, her iki tarafın da farklı ruhsal yollarla ilerlediğini yansıtıyor olabilir. Her yol kendi içinde değerli ve anlamlıdır; bu farklı yollar da bir noktada kesişiyor. Bu kesişme noktası, her iki taraf için de küçük bir ders ya da farkındalık sunabilir.',
      'Bu bağın zayıf görünmesi, iki ruhun şu an farklı gelişim aşamalarında olduğunun bir yansıması olabilir. Evrenin büyük planında her tanışıklık bir anlam taşır; bu bağ da kendi küçük ama gerçek anlamını içeriyor. Her ilişki derin ya da yoğun olmak zorunda değildir; bazı bağlar daha hafif ve daha kısa ama anlamlı olmak için var. Bu bağı zorlamak yerine doğal akışına bırakmak en sağlıklı yaklaşım olacaktır. Zamanla bu bağın size ne söylemek istediği netleşecek.',
      'Aranızdaki enerji uyumlu görünmüyor olsa da, bu bağın size öğreteceği küçük ama önemli şeyler olabilir. Zayıf bağlar da evrenin büyük planının bir parçasıdır; bazen yalnızca bir anlık bir etkileşim için var olurlar. Her karşılaşmanın bir amacı olduğunu düşündüğünüzde, bu bağ da anlamlı bir yer buluyor. Bu enerjetik uyumsuzluk, her iki tarafın da farklı ruhsal öncelikleri olduğuna işaret ediyor. Bu farkı kabul etmek, her iki taraf için de sağlıklı bir yaklaşım.',
      'Bu bağ, derin bir ruhsal bütünleşme içermiyor; ama her temas noktası kendi anlamını taşır. Belki yollarınız şu an tam örtüşmüyor; ama bu, gelecekte her şeyin aynı kalacağı anlamına gelmiyor. İnsanlar büyür, değişir ve bu büyüme ile değişim bazen beklenmedik bağlar kurar. Bu bağın şu anki görünümü, geleceğe dair bir son söz değil; yalnızca bugünkü bir fotoğraftır. Bu fotoğrafın ileride nasıl değişeceğini merakla gözlemlemek güzel.',
      'Aranızdaki çekim sınırlı düzeyde; her iki ruh da şu an farklı gelişim alanlarında ilerliyor olabilir. Bu durum eleştirilerek değil, olduğu gibi kabul edilerek değerlendirilmesi gereken bir gerçektir. Güçlü bir ruhsal bağ olmasa da, bu bağın size sunduğu küçük bir ders ya da farkındalık içerebilir. Her ilişki bir amaç için var; bu bağın amacı belki de henüz tam anlaşılmamış durumda. Zamanla bu bağın gerçek niteliği daha netleşebilir.',
      'Ruhsal açıdan güçlü bir uyum görünmüyor; ama bu bağ yine de bir anlam ve bir amaç taşıyor. İki farklı enerji bazen beklenmedik şekillerde birbirini tamamlayabilir ya da küçük ama önemli dersler sunabilir. Bu bağın zayıflığını yargılamak yerine, bu farklı enerjilerin bir araya gelmesinden ne öğrenilebileceğini sormak daha verimli bir yaklaşım. Evrenin büyük planında her temas bir anlam taşır. Bu hafif temas da kendi küçük anlamını içeriyor.',
      'Bu zayıf bağ, belki de her iki tarafın da farklı ruhsal öncelikleri olduğunu ve şu an farklı yollarla ilerlediğini yansıtıyor. Bu durum değersizlik değil; sadece farklılık anlamına geliyor. Her ruhun kendi benzersiz yolculuğu var ve bu yolculuklar her zaman tam örtüşmeyebilir. Bu bağı zorlamak yerine doğal akışına bırakmak en uygun yaklaşım olacaktır. Belki bu bağın size öğreteceği en önemli ders de bu kabullenme ve bırakma sanatıdır.',
      'Güçlü bir ruhsal bağlantı görünmüyor; ama her karşılaşma, evrenin büyük senaryosunda küçük ama anlamlı bir rol oynamaktadır. Bu bağın size sunduğu küçük dersleri fark etmek ve değerlendirmek, hem kişisel hem de ruhsal gelişim açısından değerlidir. İki ruhun şu an farklı frekanslarda olması, ilerleyen zamanlarda değişmeyeceği anlamına gelmiyor. Zamanla her iki taraf da büyür ve bu büyüme yeni ve farklı bağlantılar yaratabilir. Bu bağ, bugün için sadece bir an; yarın için kim bilir.',
    ],
    'Belirsiz Bağ': [
      'Aranızdaki ruhsal bağ henüz belirsiz; bu ilişkinin neye dönüşeceği her iki tarafın niyetine ve enerjisine bağlı. Bu belirsizlik endişe verici değil; aksine, henüz şekillenmemiş bir potansiyeli işaret ediyor. Bağın bu narin döneminde, birbirinize açık ve meraklı kalmak en değerli tutum. Hangi yönde ilerlerse ilerlesin, bu bağ her iki taraf için de bir şeyler öğretme potansiyeli taşıyor. Zamanla bu enerjinin nereye evrildiğini görmek güzel bir keşif yolculuğu olabilir.',
      'Bu bağın yoğunluğu düşük görünüyor; belki yollarınız bu noktada kesişiyor ama ilerleyen zamanlarda farklı yönlere evrilecek. Her iki tarafın da şu an farklı ruhsal öncelikleri ve odakları olduğu anlaşılıyor. Bu belirsizlik, bir sorun değil; sadece iki farklı ruhsal yolculuğun geçici bir kesişme noktası. Bu bağ her iki taraf için de küçük bir ders ya da farkındalık içeriyor olabilir. Zorlamadan ve beklenti taşımadan, bu bağın doğal akışına bırakmak en sağlıklı yaklaşım.',
      'Aranızdaki enerji henüz şekillenmemiş; bu belirsizlik, farklı yönlere evrilebileceğinizi gösterebilir. Belirsiz bağlar bazen en beklenmedik şekillerde anlam kazanır; bazen de olduğu gibi hafif kalır. Her iki olasılık da kendi içinde geçerli ve değerlidir. Bu bağı zorlamak yerine doğal akışına bırakmak ve zamanın ne getireceğini merakla beklemek en güzel tutum. Evrenin büyük planında bu bağın da kendi yeri ve anlamı var.',
      'Güçlü bir ruhsal bağlantı görünmüyor; ama her karşılaşma evrenin büyük planında bir anlam taşır. Bu belirsiz bağ da kendi küçük anlamını içeriyor; ne olduğunu ya da ne olacağını zorlamadan keşfetmek güzel. İki farklı enerji bazen sadece bir anlık temas için ya da küçük bir ders için bir araya gelir. Bu bağın şu anki belirsizliğini kabul etmek ve ne getireceğini merakla beklemek, en sağlıklı ve en güzel yaklaşım. Zaman, bu bağın gerçek niteliğini gösterecek.',
      'Bu bağ, iki farklı ruhun kısa süreli bir etkileşimini temsil ediyor olabilir. Her deneyim büyümek için bir fırsat sunar; bu bağ da kendi küçük fırsatını barındırıyor. Aranızdaki belirsizlik, her iki tarafın da şu an farklı gelişim alanlarında olduğunun bir yansıması olabilir. Bu farklılığı kabul etmek ve değerlendirmek, her iki taraf için de sağlıklı bir tutum. Zamanla bu bağın size ne söylemek istediği netleşecek.',
      'Ruhsal açıdan belirgin bir bağ görünmüyor; farklı enerjiler bir araya gelmiş durumda. Bu farklılık, mutlaka olumsuz bir işaret değildir; bazen farklı enerjiler birbirinden çok şey öğrenebilir. Aranızdaki bu belirsiz enerji, nasıl değerlendireceğinize bağlı olarak farklı anlamlar kazanabilir. Bu bağı açık kalplilikle, merakla ve beklenti taşımadan gözlemlemek en güzel yaklaşım. Evrenin büyük planında bu karşılaşmanın da bir anlamı var.',
      'Bu belirsiz bağ, gelecekte farklı bir anlam kazanabilir ya da sadece geçici bir kesişme noktası olabilir. Her iki olasılık da kendi içinde geçerli ve değerli bir yaşam deneyimini temsil ediyor. Aranızdaki bu hafif temas, küçük ama gerçek bir anlam taşıyor. Bunu zorlamadan ve beklenti taşımadan değerlendirmek en sağlıklı yaklaşım. Zaman ve doğal gelişim, bu bağın nereye gideceğini gösterecek.',
      'Derin bir ruhsal rezonans içermiyor şu an; ama bu bağın size küçük ama değerli bir şeyler öğretme potansiyeli var. İki ruhun şu an farklı frekanslarda olması, ilerleyen zamanlarda değişmeyeceği anlamına gelmiyor. Bu belirsizliği zorlamak yerine, doğal akışına bırakmak en uygun tutum. Her iki taraf da büyür ve bu büyüme yeni ve farklı enerjiler yaratır. Bu bağın şu anki görünümü, yarın için bir son söz değil.',
      'Belirsiz bir ruhsal tablo çıkıyor; her iki ruh da şu an farklı yolculuklarda ilerliyor olabilir. Bu durum değersizlik değil, sadece farklılık ve farklı zamanlama anlamına geliyor. Her ruhun kendi benzersiz ve güzel yolculuğu var; bu yolculuklar her zaman tam örtüşmeyebilir. Bu bağı kabul etmek ve her iki tarafın da kendi yoluna saygı göstermek en güzel tutum. Zamanla yollar bazen beklenmedik noktalarda yeniden kesişir.',
      'Bu bağın şu anki görünümü zayıf; ama hayatın sürprizleri her zaman beklenmedik bağları güçlendirebilir. Aranızdaki bu belirsiz enerji, henüz tam anlaşılmamış bir potansiyeli barındırıyor olabilir. Her iki taraf da zaman içinde büyüyecek ve bu büyüme, aralarındaki enerjinin de değişmesine yol açabilir. Bu bağı zorlamadan ve beklenti taşımadan gözlemlemek, en sağlıklı ve en güzel yaklaşım. Evrenin büyük planında bu bağın da yeri ve anlamı var; zamanla netleşecek.',
    ],
  };
  // ── Güçlü Yönler ─────────────────────────────────────────────────────────

  static const Map<String, List<String>> _gucluYonler = {
    'İkiz Alev':    ['Derin duygusal rezonans', 'Sezgisel anlayış', 'Karşılıklı dönüşüm gücü'],
    'Kutsal Bağ':   ['Güçlü ruhsal uyum', 'Karşılıklı ilham', 'Koşulsuz anlayış'],
    'Ruh Eşi':      ['Derin güven ve huzur', 'Tamamlayıcı enerji', 'İçten anlayış'],
    'İkiz Ruh':     ['Doğal uyum', 'Benzer değerler', 'Kolay iletişim'],
    'Kader Bağı':   ['Güçlü ve derin çekim', 'Dönüştürücü enerji', 'Anlamlı birliktelik'],
    'Karmik Bağ':   ['Derin öğrenme fırsatı', 'Ruhsal büyüme', 'Güçlü karşılıklı etki'],
    'Ruhsal Bağ':   ['Büyüme potansiyeli', 'Açık iletişim zemini', 'Karşılıklı merak'],
    'Hafif Bağ':    ['Rahat ve kolay etkileşim', 'Yargısız ortam', 'Hafif pozitif enerji'],
    'Zayıf Bağ':    ['Öğretici farklılık', 'Yeni perspektif kazanımı', 'Kısa ama anlamlı temas'],
    'Belirsiz Bağ': ['Keşif alanı', 'Serbest gelişim imkânı', 'Baskısız ortam'],
  };

  // ── Zayıf Yönler ─────────────────────────────────────────────────────────

  static const Map<String, List<String>> _zayifYonler = {
    'İkiz Alev':    ['Aşırı duygusal yoğunluk', 'Sınır belirlemede zorluk', 'Bağımlılık riski'],
    'Kutsal Bağ':   ['İdealizasyon tuzağı', 'Pratik konularda uyumsuzluk'],
    'Ruh Eşi':      ['Aşırı bağlılık riski', 'Bireyselliği korumakta zorluk'],
    'İkiz Ruh':     ['Farklılıkları görmezden gelme', 'Monotonluk ve durağanlık riski'],
    'Kader Bağı':   ['Kaçınılmazlık hissinin yükü', 'Zorlu ve sarsıcı dersler'],
    'Karmik Bağ':   ['Tekrarlayan çatışma örüntüsü', 'Bırakamama duygusu', 'Duygusal tükenme'],
    'Ruhsal Bağ':   ['Yüzeysel kalma riski', 'Yetersiz derinlik', 'Geçici enerji'],
    'Hafif Bağ':    ['Güçlü bağ kurma zorluğu', 'Geçici ve sığ his'],
    'Zayıf Bağ':    ['Belirgin uyum eksikliği', 'İletişim güçlüğü'],
    'Belirsiz Bağ': ['Belirsizlik kaynaklı stres', 'Yön eksikliği ve kararsızlık'],
  };

  // ── Tavsiyeler ────────────────────────────────────────────────────────────

  static const Map<String, List<String>> _tavsiyeler = {
    'İkiz Alev':    ['Kişisel sınırlarınıza saygı gösterin', 'Yoğun duygular için meditasyon uygulayın', 'Büyüme sürecine sabırla yaklaşın'],
    'Kutsal Bağ':   ['Birlikte spiritüel pratikler geliştirin', 'Gerçekçi beklentiler belirleyin', 'Güven ilişkisini özenle koruyun'],
    'Ruh Eşi':      ['Derin konuşmalarla bağı düzenli besleyin', 'Bireysel alanlarınızı korumaya özen gösterin', 'Ortak uzun vadeli hedefler belirleyin'],
    'İkiz Ruh':     ['Farklılıklarınızı zenginlik olarak değerlendirin', 'Birlikte yeni deneyimler keşfedin', 'Açık ve dürüst iletişimi sürdürün'],
    'Kader Bağı':   ['Bu ilişkinin derslerine açık yürekle yaklaşın', 'Zorlukları büyüme fırsatı olarak görün', 'Sabır ve derin anlayışla ilerleyin'],
    'Karmik Bağ':   ['Tekrar eden kalıpları bilinçli fark edin', 'Dönüşüme ve değişime açık olun', 'Affetmeyi bir özgürleşme yolu olarak görün'],
    'Ruhsal Bağ':   ['Ortak ilgi alanları ve değerler keşfedin', 'Zaman ve ilgi yatırımı yapın', 'Açık, dürüst ve samimi olun'],
    'Hafif Bağ':    ['Beklenti taşımadan doğal ilerleyin', 'Doğal gelişime sabırla izin verin', 'Şu anın küçük güzelliklerini görün'],
    'Zayıf Bağ':    ['Farklılıkları olduğu gibi kabul edin', 'Kısa etkileşimin değerini fark edin', 'Zorlamadan ve akışa bırakarak devam edin'],
    'Belirsiz Bağ': ['Belirsizliği merakla ve açıklıkla karşılayın', 'Doğal akışa ve zamana bırakın', 'Her iki tarafın ihtiyaçlarını dürüstçe dinleyin'],
  };

  // ── Ruhsal Enerji Barları ─────────────────────────────────────────────────

  static const Map<String, Map<String, int>> _enerjiBarlari = {
    'İkiz Alev':    {'Duygusal': 97, 'Zihinsel': 80, 'Karmik': 95, 'Ruhsal': 100, 'Fiziksel': 85},
    'Kutsal Bağ':   {'Duygusal': 90, 'Zihinsel': 85, 'Karmik': 78, 'Ruhsal': 95,  'Fiziksel': 68},
    'Ruh Eşi':      {'Duygusal': 88, 'Zihinsel': 82, 'Karmik': 70, 'Ruhsal': 85,  'Fiziksel': 72},
    'İkiz Ruh':     {'Duygusal': 78, 'Zihinsel': 85, 'Karmik': 60, 'Ruhsal': 75,  'Fiziksel': 65},
    'Kader Bağı':   {'Duygusal': 72, 'Zihinsel': 65, 'Karmik': 88, 'Ruhsal': 80,  'Fiziksel': 60},
    'Karmik Bağ':   {'Duygusal': 65, 'Zihinsel': 58, 'Karmik': 92, 'Ruhsal': 70,  'Fiziksel': 55},
    'Ruhsal Bağ':   {'Duygusal': 55, 'Zihinsel': 60, 'Karmik': 50, 'Ruhsal': 65,  'Fiziksel': 45},
    'Hafif Bağ':    {'Duygusal': 40, 'Zihinsel': 50, 'Karmik': 35, 'Ruhsal': 45,  'Fiziksel': 38},
    'Zayıf Bağ':    {'Duygusal': 28, 'Zihinsel': 35, 'Karmik': 25, 'Ruhsal': 30,  'Fiziksel': 28},
    'Belirsiz Bağ': {'Duygusal': 15, 'Zihinsel': 20, 'Karmik': 15, 'Ruhsal': 18,  'Fiziksel': 15},
  };

  // ── Uyumlu Alanlar ───────────────────────────────────────────────────────

  static const Map<String, List<String>> _uyumlular = {
    'İkiz Alev':    ['Derin duygusal anlayış', 'Ruhsal büyüme', 'Anlık sezgisel bağlantı'],
    'Kutsal Bağ':   ['Spiritüel uyum', 'Değer ortaklığı', 'Karşılıklı derin saygı'],
    'Ruh Eşi':      ['Güven ve huzur ortamı', 'Duygusal destek', 'Ortak hayaller'],
    'İkiz Ruh':     ['Kolay ve akıcı iletişim', 'Benzer bakış açısı', 'Doğal uyum'],
    'Kader Bağı':   ['Güçlü ve derin çekim', 'Anlam ve amaç arayışı', 'Dönüşüm yolculuğu'],
    'Karmik Bağ':   ['Derin öğrenme süreci', 'Karşılıklı ruhsal büyüme', 'Güçlü ruhsal ders'],
    'Ruhsal Bağ':   ['Merak ve keşif enerjisi', 'Açık iletişim zemini', 'Gelişim potansiyeli'],
    'Hafif Bağ':    ['Rahat ve kolay etkileşim', 'Yargısız özgür ortam', 'Açık ifade alanı'],
    'Zayıf Bağ':    ['Yeni ve farklı perspektif', 'Öğretici deneyim', 'Kısa süreli anlam'],
    'Belirsiz Bağ': ['Keşif özgürlüğü', 'Baskısız gelişim ortamı', 'Açık ve belirsiz gelecek'],
  };

  // ── Dikkat Edilmesi Gerekenler ───────────────────────────────────────────

  static const Map<String, List<String>> _dikkatler = {
    'İkiz Alev':    ['Kişisel sınırları özenle koruyun', 'Bağımlılık örüntülerini fark edin', 'Yoğunluğu dengelemeye çalışın'],
    'Kutsal Bağ':   ['Karşınızdakini idealize etmekten kaçının', 'Pratik dengeyi gözetin', 'Beklentileri açıkça dile getirin'],
    'Ruh Eşi':      ['Bireyselliğinizi ve kendinizi koruyun', 'Sağlıklı sınırlar belirleyin', 'Bağımlı olmamaya dikkat edin'],
    'İkiz Ruh':     ['Farklılıkları görmezden gelmeyin', 'Sağlıklı çatışmadan kaçmayın', 'Değişime ve gelişime açık kalın'],
    'Kader Bağı':   ['Zorlu süreçlere hazırlıklı olun', 'Kadercilik tuzağına düşmeyin', 'Kendi iradenizi her zaman kullanın'],
    'Karmik Bağ':   ['Tekrar eden kalıpları kırmaya çalışın', 'Duygusal tükenmişliğe dikkat edin', 'Gerektiğinde destek almaktan çekinmeyin'],
    'Ruhsal Bağ':   ['Yüzeysel kalmamaya özen gösterin', 'İletişimi aktif ve canlı tutun', 'Sabırsızlık tuzağına düşmeyin'],
    'Hafif Bağ':    ['Gerçekçi olmayan beklentilere girmeyin', 'Doğal gelişimi zorlamayın', 'Geçici olabileceğini kabul edin'],
    'Zayıf Bağ':    ['Uyumsuzluğu dürüstçe kabul edin', 'Zorlamaktan ve ısrar etmekten kaçının', 'Enerjinizi boşa harcamayın'],
    'Belirsiz Bağ': ['Belirsizliği strese ve kaygıya dönüştürmeyin', 'Acele ve erken karar vermeyin', 'Her iki tarafa da zaman ve alan tanıyın'],
  };

  // ── Element Tablosu ──────────────────────────────────────────────────────

  static const Map<String, String> _elements = {
    'Koc': 'ates',
    'Aslan': 'ates',
    'Yay': 'ates',
    'Boga': 'toprak',
    'Basak': 'toprak',
    'Oglak': 'toprak',
    'Ikizler': 'hava',
    'Terazi': 'hava',
    'Kova': 'hava',
    'Yengec': 'su',
    'Akrep': 'su',
    'Balik': 'su',
  };

  // ── Karşıt Burç Çiftleri ─────────────────────────────────────────────────

  static const Set<String> _opposites = {
    'Koc-Terazi',
    'Terazi-Koc',
    'Boga-Akrep',
    'Akrep-Boga',
    'Ikizler-Yay',
    'Yay-Ikizler',
    'Yengec-Oglak',
    'Oglak-Yengec',
    'Aslan-Kova',
    'Kova-Aslan',
    'Basak-Balik',
    'Balik-Basak',
  };

  // ── Element Uyumu ────────────────────────────────────────────────────────

  static int _elementCompat(String? e1, String? e2) {
    if (e1 == null || e2 == null) return 55;
    if (e1 == e2) return 90;
    final pair = <String>{e1, e2};
    if (pair.containsAll(['ates', 'hava'])) return 82;
    if (pair.containsAll(['toprak', 'su'])) return 82;
    if (pair.containsAll(['ates', 'toprak'])) return 42;
    if (pair.containsAll(['hava', 'su'])) return 42;
    if (pair.containsAll(['ates', 'su'])) return 28;
    if (pair.containsAll(['toprak', 'hava'])) return 28;
    return 55;
  }

  // ── Burç Uyumu ───────────────────────────────────────────────────────────

  static int _signCompat(String? s1, String? s2) {
    if (s1 == null || s2 == null) return 55;
    final n1 = _norm(s1);
    final n2 = _norm(s2);
    if (n1 == n2) return 95;
    if (_opposites.contains('$n1-$n2')) return 78;
    return _elementCompat(_elements[n1], _elements[n2]);
  }

  // ── Numeroloji (Pisagor sistemi) ─────────────────────────────────────────

  static const Map<String, int> _harfler = {
    'a': 1,
    'b': 2,
    'c': 3,
    'ç': 3,
    'd': 4,
    'e': 5,
    'f': 6,
    'g': 7,
    'ğ': 7,
    'h': 8,
    'ı': 9,
    'i': 9,
    'j': 1,
    'k': 2,
    'l': 3,
    'm': 4,
    'n': 5,
    'o': 6,
    'ö': 6,
    'p': 7,
    'q': 8,
    'r': 9,
    's': 1,
    'ş': 1,
    't': 2,
    'u': 3,
    'ü': 3,
    'v': 4,
    'w': 5,
    'x': 6,
    'y': 7,
    'z': 8,
  };

  static int _isimSayisi(String isim) {
    int toplam = 0;
    for (final r in isim.toLowerCase().runes) {
      toplam += _harfler[String.fromCharCode(r)] ?? 0;
    }
    return _tekHaneye(toplam);
  }

  static int _tekHaneye(int n) {
    while (n > 9) {
      int sonraki = 0;
      while (n > 0) {
        sonraki += n % 10;
        n ~/= 10;
      }
      n = sonraki;
    }
    return n == 0 ? 1 : n;
  }

  // ── Yaşam Yolu Sayısı ────────────────────────────────────────────────────

  static int _yasamYolu(DateTime d) {
    final tum = '${d.day}${d.month}${d.year}'.runes
        .map((r) => int.tryParse(String.fromCharCode(r)) ?? 0)
        .fold(0, (a, b) => a + b);
    return _tekHaneye(tum);
  }

  // ── Sayı Uyum Tablosu ────────────────────────────────────────────────────

  static int _sayiUyumu(int n1, int n2) {
    final k = '${n1 < n2 ? n1 : n2}-${n1 < n2 ? n2 : n1}';
    const t = <String, int>{
      '1-1': 88,
      '1-2': 85,
      '1-3': 75,
      '1-4': 50,
      '1-5': 70,
      '1-6': 80,
      '1-7': 65,
      '1-8': 75,
      '1-9': 95,
      '2-2': 85,
      '2-3': 80,
      '2-4': 75,
      '2-5': 55,
      '2-6': 90,
      '2-7': 70,
      '2-8': 60,
      '2-9': 80,
      '3-3': 85,
      '3-4': 55,
      '3-5': 80,
      '3-6': 75,
      '3-7': 65,
      '3-8': 60,
      '3-9': 85,
      '4-4': 75,
      '4-5': 45,
      '4-6': 65,
      '4-7': 85,
      '4-8': 80,
      '4-9': 55,
      '5-5': 70,
      '5-6': 60,
      '5-7': 65,
      '5-8': 75,
      '5-9': 70,
      '6-6': 90,
      '6-7': 70,
      '6-8': 65,
      '6-9': 80,
      '7-7': 85,
      '7-8': 60,
      '7-9': 90,
      '8-8': 75,
      '8-9': 70,
      '9-9': 95,
    };
    return t[k] ?? 55;
  }

  // ── Karmik Skor ──────────────────────────────────────────────────────────

  static int _karmikSkor(int yy1, int yy2, int is1, int is2) {
    const karmikSayilar = {4, 7, 9};
    int puan = 50;
    final birlesim = _tekHaneye(yy1 + yy2);
    if (karmikSayilar.contains(birlesim)) puan += 20;
    if (is1 == 9 || is2 == 9) puan += 15;
    final isimToplam = is1 + is2;
    if (isimToplam == 11 || isimToplam == 14 || isimToplam == 16) puan += 10;
    return puan.clamp(0, 100);
  }

  // ── Normalize ────────────────────────────────────────────────────────────

  static String _norm(String s) {
    const harita = <String, String>{
      'Koç': 'Koc',
      'koç': 'Koc',
      'KOÇ': 'Koc',
      'Boğa': 'Boga',
      'boğa': 'Boga',
      'İkizler': 'Ikizler',
      'ikizler': 'Ikizler',
      'Yengeç': 'Yengec',
      'yengeç': 'Yengec',
      'Başak': 'Basak',
      'başak': 'Basak',
      'Oğlak': 'Oglak',
      'oğlak': 'Oglak',
      'Balık': 'Balik',
      'balık': 'Balik',
    };
    return harita[s.trim()] ?? s.trim();
  }

  // ── Ana Hesaplama ────────────────────────────────────────────────────────

  static RuhsalBagResult hesapla({
    required String isim1,
    required DateTime dogumTarihi1,
    required String? gunes1,
    required String? ay1,
    required String? venus1,
    required String? yukselen1,
    required String isim2,
    required DateTime dogumTarihi2,
    required String? gunes2,
    required String? ay2,
    required String? venus2,
    required String? yukselen2,
  }) {
    // 1) Numeroloji
    final n1 = _isimSayisi(isim1);
    final n2 = _isimSayisi(isim2);
    final numSkor = _sayiUyumu(n1, n2);

    // 2) Yaşam Yolu
    final yy1 = _yasamYolu(dogumTarihi1);
    final yy2 = _yasamYolu(dogumTarihi2);
    final yyUyum = _sayiUyumu(yy1, yy2);

    // 3) Burç Uyumu (ağırlıklı)
    final gunesSkor = _signCompat(gunes1, gunes2);
    final aySkor = _signCompat(ay1, ay2);
    final venusSkor = _signCompat(venus1, venus2);
    final yukselenSkor = _signCompat(yukselen1, yukselen2);

    final varAy = ay1 != null && ay2 != null;
    final varVenus = venus1 != null && venus2 != null;
    final varYukselen = yukselen1 != null && yukselen2 != null;

    double burcSkor;
    if (!varAy && !varVenus && !varYukselen) {
      burcSkor = gunesSkor.toDouble();
    } else {
      double agirliklarToplam = 0.40;
      double puanToplam = gunesSkor * 0.40;
      if (varAy) {
        puanToplam += aySkor * 0.30;
        agirliklarToplam += 0.30;
      }
      if (varVenus) {
        puanToplam += venusSkor * 0.20;
        agirliklarToplam += 0.20;
      }
      if (varYukselen) {
        puanToplam += yukselenSkor * 0.10;
        agirliklarToplam += 0.10;
      }
      burcSkor = puanToplam / agirliklarToplam;
    }

    // 4) Karmik
    final karmikSkor = _karmikSkor(yy1, yy2, n1, n2);

    // ── Toplam
    final ham =
        numSkor * 0.25 + yyUyum * 0.25 + burcSkor * 0.40 + karmikSkor * 0.10;
    final skor = ham.round().clamp(0, 100);

    // ── Kategori
    final kat = _kategoriler.firstWhere(
      (k) => skor >= k.min && skor <= k.max,
      orElse: () => _kategoriler.last,
    );

    // ── Açıklama seçimi (deterministik, isim & tarih bazlı)
    final tohum =
        '${isim1.toLowerCase()}|${isim2.toLowerCase()}'
        '|${dogumTarihi1.millisecondsSinceEpoch}'
        '|${dogumTarihi2.millisecondsSinceEpoch}';
    int hash = 0;
    for (final c in tohum.runes) {
      hash = (hash * 31 + c) % 1000000007;
    }
    final aciklamalar =
        _aciklamalar[kat.ad] ?? ['Ruhsal bağınız analiz edildi.'];
    final aciklama = aciklamalar[hash.abs() % aciklamalar.length];

    return RuhsalBagResult(
      score: skor,
      categoryEmoji: kat.emoji,
      categoryLabel: kat.ad,
      description: aciklama,
      nameNumber1: n1,
      nameNumber2: n2,
      lifePathNumber1: yy1,
      lifePathNumber2: yy2,
      signScore: burcSkor.round().clamp(0, 100),
      gucluYonler: _gucluYonler[kat.ad] ?? [],
      zayifYonler: _zayifYonler[kat.ad] ?? [],
      tavsiyeler: _tavsiyeler[kat.ad] ?? [],
      enerjiBarlari: _enerjiBarlari[kat.ad] ?? {},
      uyumlular: _uyumlular[kat.ad] ?? [],
      dikkatler: _dikkatler[kat.ad] ?? [],
    );
  }
}

// ─── Dahili Kategori Modeli ───────────────────────────────────────────────────

class _Kategori {
  const _Kategori({
    required this.emoji,
    required this.ad,
    required this.min,
    required this.max,
  });

  final String emoji;
  final String ad;
  final int min;
  final int max;
}
