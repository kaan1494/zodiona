// ignore_for_file: lines_longer_than_80_chars
// Doğum haritası detay içerikleri
// Güneş × Ay × Yükselen kombinasyonları + Gezegen/Ev/Açı/Kişilik açıklamaları

// ──────────────────────────────────────────────────────────────────────────────
// 1. Gezegen bazlı içerikler: 9 gezegen × 12 burç = 108 metin
//    Her giriş: planetContentMap[planetKey][signKey]
// ──────────────────────────────────────────────────────────────────────────────

const Map<String, Map<String, String>> planetContentMap = {
  'Sun': {
    'Koc':
        'Güneş Koç burcundayken sen saf bir hayat enerjisiyle dünyaya açılırsın. '
        'Önce hareket, sonra düşünce… Koç Güneşi seni her sabah yeniden doğuran bir ateştir. '
        'İnsanlar seni lider olarak görür çünkü sen duraksamamayı bilirsin; bu cesaret bir armağandır. '
        'Ancak sabırsızlık tuzağına dikkat et; büyük zaferler çoğu zaman uzun soluklu oyunlarda kazanılır. '
        'Doğum haritanın geri kalanı bu Koç ateşini nasıl yönettiğini anlatır — bazen fırtına, bazen ısıtıcı bir ocak.',
    'Boga':
        'Güneş Boğa burcundayken kimliğin güzellik, güvenlik ve kalıcılık üzerine inşa edilir. '
        'Beş duyunla deneyimlediğin her şey sana anlam verir; iyi yemek, güzel müzik, sağlam bağlar. '
        'Başkaları kaos içindeyken sen sakin kalırsın — bu senin süpergücündür. '
        'Ama değişime direncin zaman zaman fırsatları kaçırmana yol açabilir; güvende olmak ile hapsolmak arasındaki farkı fark etmek sana aittir. '
        'Haritandaki Venüs ve Ay, bu Boğa özünü nasıl renklendirdiğini açıklar.',
    'Ikizler':
        'Güneş İkizler burcundayken zihnin hiçbir zaman dinlenmiyor ve bu bir eksiklik değil, süpergücün. '
        'Fikirleri birleştirme, farklı dünyalar arasında köprü kurma ve insanları anlatıyla büyüleme konusunda eşsizsin. '
        'Kimliğin tek değil, çok katmanlı — ve bunda utanılacak bir şey yok. '
        'Derinleşme korkusuyla yüzler arasında dolaşmak yerine bir konuda gerçek otorite olmayı dene; haritandaki Merkür sana bu yolu gösterir.',
    'Yengec':
        'Güneş Yengeç burcundayken kimliğin duygularla, bellek ve aile bağlarıyla örülüdür. '
        'Empatin bir süpergüçtür — başkalarının hislerini kelime söylenmeden anlarsın. '
        'Koruma içgüdün hem seni hem de sevdiklerini güvende tutar, ama kimi zaman kendi ihtiyaçlarını arka planda bırakırsın. '
        'Kendin için de bir adım at; seni besleyen şeyi bulmak bu haritanın en kritik görevidir.',
    'Aslan':
        'Güneş Aslan burcundayken sahne sana aittir — bu büyüklük değil, doğanın sana verdiği ışıktır. '
        'Yaratıcılık, cömertlik ve liderlik üçlüsü senin imzandır. '
        'Sevgi almak kadar vermeyi de bilmek bu Aslan özünün en güzel yanıdır. '
        'Onaylara bağımlılık ise zayıf noktandır; içinden gelen ışık başkalarının alkışına muhtaç değil. '
        'Haritandaki Güneş evi, bu enerjini hayatın hangi sahnesinde daha yoğun yaşadığını anlatır.',
    'Basak':
        'Güneş Başak burcundayken mükemmellik arayışın her şeyi daha iyi yapma çabasından doğar. '
        'Analitik zekan, hizmet etme arzun ve detaylara olan ilgin seni vazgeçilmez kılar. '
        'Ama öz eleştiri sesi zaman zaman özgüvenini eritir — sen yeterlisin, kusurlarınla birlikte. '
        'Bu haritayı okurken "nasıl daha iyi olabilirim?" diye sadece başkalarına değil, kendine de sor.',
    'Terazi':
        'Güneş Terazi burcundayken adalet, estetik ve ilişkiler kimliğinin merkezindedir. '
        'Denge arayışın zamanla karar verme konusunda zorlanmana yol açabilir; ama bu aslında tüm tarafları dinleme erdeminden kaynaklanır. '
        'İnsanlar seninle konuşunca dinlenilmiş hisseder — bu nadir bir armağandır. '
        'Başkalarını memnun etmek için kendinden taviz vermek Terazi tuzağıdır; haritandaki Venüs bunun derinliğini gösterir.',
    'Akrep':
        'Güneş Akrep burcundayken yüzeyin altını görme, sırları çözme ve köklü dönüşümleri yönetme senin alanındır. '
        'Duygusal yoğunluğun çoğu zaman anlaşılmaz; aslında bu bir güç, bir derinliktir. '
        'Güven inşa etmen zaman alır ama bir kez verdiğinde tamdır. '
        'Kontrol ve şüphecilik ise seni bazen izole eder; bırakmayı öğrenmek bu haritanın en büyük dönüşümüdür.',
    'Yay':
        'Güneş Yay burcundayken anlam, özgürlük ve keşif senin oksijenidir. '
        'Neden diye sormaktan vazgeçmezsin ve bu felsefi iştah seni hem öğretmen hem öğrenci yapar. '
        'Seyahat, kültür, vizyon… bunlar seni besler. '
        'Ama başlayıp bitirememek Yay gölgesidir; haritandaki Jüpiter hangi alanlarda bu dağılganlığın önüne geçebileceğini işaret eder.',
    'Oglak':
        'Güneş Oğlak burcundayken kariyer, sorumluluk ve uzun vadeli inşa senin doğanın bir parçasıdır. '
        'Disiplin ve sabır konusunda çevrendekilerden çok ilerisin. '
        'Ücra hedeflere ulaşmak için sessizce yıllarca çalışabilirsin. '
        'Ancak duygusal dünyayla bağlantıyı kesmek, başarı adına zevki ertelemek bu haritanın seni uyardığı tehlikedir. '
        'Hayat sadece zirveye tırmanmak değil; yol boyunca yaşanacak anlardır.',
    'Kova':
        'Güneş Kova burcundayken toplumu yeniden düşünmek, kuralları sorgulamak ve geleceğe ait bir vizyon taşımak senin özündedir. '
        'Bağımsızlık ve özgünlük sen için havasız bir odada nefes almak kadar zorunludur. '
        'İnsanlığa hizmet fikri seni eyleme geçirir. '
        'Yakınlık korkusu Kova gölgesidir; tek başınasın ama yalnız olmak zorunda değilsin.',
    'Balik':
        'Güneş Balık burcundayken sınırlar eriyor, empatin sonsuz, hayal gücün bir okyanus kadar derindir. '
        'Sanatla, ruhaniyetle ve şefkatle bağlantın hayatına anlam katar. '
        'Başkalarının acısını kendi bedeninde hissedersin — bu hem güç hem yük. '
        'Gerçeklikten kaçış tuzağından korunmak için güçlü bir çıpa bulmak bu haritanın temel meselesinden biridir.',
  },

  'Moon': {
    'Koc':
        'Ay Koç burcundayken duygular şiddetli ve ani gelir; ne hissedersen anında gösterirsin. '
        'Duygusal tatmin için eylem gerekir — hareketsiz kalmak içini çökertir. '
        'Öfken hızlı alevlenir ama çabuk da söner. '
        'Başkalarının yavaş tempo sinirini bozabilir. '
        'Bu Ay yerleşimi sana özgün bir duygusal cesaret verir: hislerinle yüzleşmekten kaçınmazsın.',
    'Boga':
        'Ay Boğa burcundayken duygusal güvenliğin temeli istikrar, rutinler ve dokunsal konfor üzerine kurulur. '
        'Güzel şeyler, lezzetli yemekler ve sıcak bağlar seni besler. '
        'Duygusal sıçramalar seni rahatsız eder; ani değişiklikler içini gergin yapar. '
        'Ama bir kez güvende hissettin mi, sevgin kalıcı ve sakinleştiricidir.',
    'Ikizler':
        'Ay İkizler burcundayken zihin ve duygu iç içe geçer; bir duyguyu konuşmak onu daha az ağır yapar. '
        'Duygusal tatmin için zihinsel uyarıma ihtiyaç duyarsın. '
        'Hislerin bazen hızla değişir ve bu kararsız görünürsün ama aslında çok boyutlusun. '
        'Yazmak, konuşmak, anlatmak duygularını işlemenin en güçlü yoludur sancın için.',
    'Yengec':
        'Ay Yengeç burcundayken — Ay\'ın kendi doğal evinde — duygusal dünyanda son derece derinsin. '
        'Aile, kök ve ait olmak hissi sana güç verir. '
        'Başkalarına baktığın ve onları koruduğun kadar kendine de bak; verici olmak güzel, ama tükenme. '
        'Geçmişe ve anılara bağlılığın bazen şimdiye dalmanı zorlaştırır.',
    'Aslan':
        'Ay Aslan burcundayken duygusal tatmin övgü, sıcaklık ve ifade etme özgürlüğüyle gelir. '
        'Sevildiğini hissetmek için görmek ve görülmek istersin. '
        'Drama bu Ay yerleşiminin gölgesidir; ama aynı zamanda yaşamı renkli kılan da sensin. '
        'Sevdiklerine cömertçe ilgi gösterirsin; aynı ilgiyi talep etmek ise zaman zaman zor gelir.',
    'Basak':
        'Ay Başak burcundayken duygusal güvenliğini yardım ederek, düzenleyerek ve faydalı olarak inşa edersin. '
        'Hislerin pratik eylemle ifade bulur. '
        'Ama iç eleştiri sesi bu Ay yerleşiminde yüksek çalışır; hem kendinle hem başkalarıyla aşırı titiz olabilirsin. '
        'Yeterliliğin performansına değil, var oluşuna bağlı olduğunu hatırla.',
    'Terazi':
        'Ay Terazi burcundayken duygusal uyum ilişkilerle, adaletle ve estetikle gelir. '
        'Çatışmadan kaçınmak için kendi ihtiyaçlarını görmezden gelebilirsin. '
        'Güzellik içinde olmak, adil kararlar vermek ve bağlantı hissetmek seni besler. '
        'Karar vermekte zorlandığında bu Ay sana hem avantaj hem dezavantaj sunar.',
    'Akrep':
        'Ay Akrep burcundayken duygular yüzeysel değil, derin ve sarsıcıdır. '
        'Güven ettiğin insanlara sonuna kadar bağlanırsın; ama ihanetle başa çıkmak çok zorlandır. '
        'Hem dönüşüm hem de tutunma senin duygusal ikilemindir. '
        'Bu Ay yerleşimi sana olağanüstü bir sezgi verir; kimi zaman bir bakışta insanı okursun.',
    'Yay':
        'Ay Yay burcundayken özgürlük, anlam arayışı ve keşif duygusal ihtiyaçlarının başında gelir. '
        'Sıkıştığında, daraldığında ya da anlamsız hissettiğinde duygusal dünyanda fırtına kopar. '
        'Macera, öğrenme ve umut seni besler. '
        'Duygusal bağlılıkta kök salmak ise en büyük zorluğun olabilir.',
    'Oglak':
        'Ay Oğlak burcundayken duygular dışarıya az yansıtılır; güçlü görünmek önce gelir. '
        'Sorumluluk ve kontrol duygusal güvenlik kaynağındır. '
        'Ama bu güçlü görünme çabası zaman zaman bağ kurmanı zorlaştırır. '
        'İçindeki çocuğu, oyunu ve spontane sevinci bulmak bu yerleşimin iyileşme yolculuğudur.',
    'Kova':
        'Ay Kova burcundayken duygusal bağımsızlık temel ihtiyaçtan biridir. '
        'Yakın olmak istiyorsun ama çok kıstırılmak da istemiyorsun — bu denge hassastır. '
        'İnsanlığa karşı hissettiğin genel sevgi bazen yakınındakilere gösterdiğin sıcaklığı gölgeler. '
        'Sezgilerini ve insani fikirleri ayırt edilmez biçimde birleştirirsin.',
    'Balik':
        'Ay Balık burcundayken duygusal sınırlar çok geçirgen; başkalarının acısını adeta içine çekersin. '
        'Yaratıcılık, müzik, rüya ve ruhaniyetle bağlantın bu Ay yerleşiminin ruhunu anlatır. '
        'Kendin için zaman yaratmak ve gerçeklikle bağını sağlamlaştırmak önceliğin olmalı. '
        'Bu Ay sana inanılmaz bir şefkat ve sezgi verir; bunu hem kendine hem insanlara yönelt.',
  },

  'Asc': {
    'Koc':
        'Yükselen Koç ile dünyaya dinamik, direkt ve enerjik bir izlenim verirsin. '
        'Girdiğin odayı hissettirirsin; insanlar seni fark eder ve seninle ilgili hemen fikir oluşturur. '
        'Beden dilinde güç, yüz ifadende kararlılık okunur. '
        'Özellikle ilk izlenimde saldırgan ya da aceleci görünebilirsin; ama bu dışarıya yansıyan adrenalindir, içinde hep hesaplıyorsundur. '
        'Marte yönetilen bu yükselen, haritanın tamamından bağımsız olarak sana rekabetçi bir ilk katman katar.',
    'Boga':
        'Yükselen Boğa ile sakin, güvenilir ve estetik bir izlenim verirsin. '
        'İnsanlar sana güvenir çünkü beden dilin ve ses tonun rahatlatıcıdır. '
        'Güzelliğe, kaliteye ve konfora ilgin dışarıdan da okunur. '
        'Ağır hareket etmen, zamana ihtiyaç duyman bazen yavaş ya da inatçı gösterebilir seni; oysa sen sadece eminleşmek istiyorsundur. '
        'Bu yükselen bedenle ilişkini, konfor bölgeni ve fiziksel iştahını da şekillendirir.',
    'Ikizler':
        'Yükselen İkizler ile meraklı, uyanık ve iletişim kurmaya hazır bir izlenim yaratırsın. '
        'Ellerin konuşurken hareket eder, gözlerin her şeyi kaydeder. '
        'Sosyal ortamlarda kolayca bağ kurarsın; insanlar seninle sohbet etmekten hoşlanır. '
        'Tutarsız ya da derinsiz görünmek bu yükselenin gölgesidir; oysa sen çok katmanlısın sadece. '
        'Merkür yönetimi bu yükselenleri keskin bir zihin ve güçlü adaptasyon yeteneğiyle donatır.',
    'Yengec':
        'Yükselen Yengeç ile dünyaya çekingen ama sıcak bir ilk izlenimle girersin. '
        'Tanımadığın insanlarla ilk anlarda kabuğuna çekilirsin; ama yakındığında son derece besleyici ve koruyucusun. '
        'Yüzündeki duygu geçişleri hızlıdır; hislerini saklamak zaten hiç öğrenemedeydin. '
        'Bu yükselen ann figürleri ve güvenli mekânlarla güçlü bir bağ oluşturur.',
    'Aslan':
        'Yükselen Aslan ile sahneye çıktığında tüm gözler sana döner — bunu istemesen bile. '
        'Saçın, kıyafetin veya duruşunda bir kral/kraliçe enerjisi okunur. '
        'Övgüye açık, bağlılığa muhtaç görünebilirsin ilk bakışta. '
        'Ama bu yükselenin gerçek armağanı: insanlara ilham verme kapasitesi. '
        'Güneş hangi burçta olursa olsun, Aslan yükselen sahneyi ısıtır.',
    'Basak':
        'Yükselen Başak ile dikkatli, titiz ve erişilebilir bir izlenim verirsin. '
        'Sadeliği seversin, dikkat çekmeyi değil yararlı olmayı hedeflersin. '
        'Başkaları sorununuzu Başak yükselen birine getirir çünkü çözüm odaklı yaklaşımın hemen okunur. '
        'Aşırı eleştirel görünmek bu yükselenin tuzağıdır; ama aslında sen sadece iyileştirmek istiyorsundur.',
    'Terazi':
        'Yükselen Terazi ile zarif, dengeli ve hoş bir izlenim verirsin. '
        'İnsanlar seninle tanışmaktan memnun kalır; kibarlığın ve estetiğin fark edilir. '
        'İlk tanışmada çatışmadan kaçınman seni bazen tutarsız ya da karaktersiz gösterebilir; oysa sen sadece barışçılsındır. '
        'Venüs yönetimi bu yükselenlere fiziksel çekicilik ve sosyal zarafet verir.',
    'Akrep':
        'Yükselen Akrep ile yoğun, gizemli ve nüfuz eden bir izlenim yaratırsın. '
        'İnsanlar seni zor okur; bu bazen korkutucu, bazen çekici bulunur. '
        'Gözlerin konuşur; söylediğinden fazlasını ifade eder bakışın. '
        'Sırlarını kolayca vermezsin ve bu güvensizlik değil, içgüdüsel kendin korumadır. '
        'Bu yükselen güç dinamikleri ve dönüşümle derin bir ilişki kurar.',
    'Yay':
        'Yükselen Yay ile iyimser, özgür ruhlu ve maceracı bir izlenim verirsin. '
        'Gülen gözlerin ve kaygısız duruşun insanları sana doğru çeker. '
        'Fikirlerin ve vizyonun konuşmana yansır; sohbetler seninle derinleşir. '
        'Sınırsanlığa ve sorumluluktan kaçmaya meyilli görünebilirsin; ama aslında büyük resmi gören birisin.',
    'Oglak':
        'Yükselen Oğlak ile ciddi, güvenilir ve otoriter bir izlenim verirsin. '
        'İnsanlar seni ilk bakışta saygın bulur; sana görev ve sorumluluk teslim etmekten çekinmezler. '
        'Gülümsemen nadir olabilir ama değerlidir. '
        'Yaş ilerledikçe bu yükselen yumuşar; genç Oğlak yükselenler zamanla çiçek açar.',
    'Kova':
        'Yükselen Kova ile alışılmadık, özgün ve ilerici bir izlenim verirsin. '
        'Tarzın, temaların veya konuştuğun fikirlerin başkalarınınkinden farklı olduğu hemen fark edilir. '
        'İnsanlar seni "farklı" biri olarak görür; bu bir kompliman. '
        'Duygusal mesafe Kova yükselenin tuzağıdır; yakınlığa izin vermek bilinçli bir seçim gerektirir.',
    'Balik':
        'Yükselen Balık ile yumuşak, rüya gibi ve sezgisel bir izlenim verirsin. '
        'İnsanlar sana kolaylıkla açılır; mahrem şeylerini yabancılara söyleyip sonra şaşırırlar. '
        'Dış görünüşün değişken olabilir; aynı Balık yükselen birine gün içinde pek çok farklı sefer bakılabilir. '
        'Bu yükselen sanatsal bir alımlılık ve ruhaniyetle güçlü bir bağ getirir.',
  },

  'Mercury': {
    'Koc':
        'Merkür Koç burcunda: Hızlı, doğrudan ve bazen kaba dürüst bir düşünce tarzı. İlk düşünce genellikle doğru ama aceleci kararlar tuzağına dikkat.',
    'Boga':
        'Merkür Boğa burcunda: Yavaş ama sağlam düşünce yapısı. Bir kez karar verdinde değiştirmek zor; bu bazen inat, bazen sağlamlık olarak okunur.',
    'Ikizler':
        'Merkür İkizler burcunda — kendi evinde: Keskin, çok yönlü ve meraklı bir zihin. Bilgi toplamak ve paylaşmak nefes almak kadar doğal.',
    'Yengec':
        'Merkür Yengeç burcunda: Duygusal bellek güçlüdür; geçmiş deneyimler bugünün kararlarını şekillendirir. Sezgi ile mantık birlikte çalışır.',
    'Aslan':
        'Merkür Aslan burcunda: Anlatı sanatçısı. Fikirlerini dramatik ve etkileyici biçimde sunarsin; dinleyiciler seni dinlemek ister.',
    'Basak':
        'Merkür Başak burcunda — kendi evinde: Analitik, hassas ve eleştirel düşünce. Ayrıntı gözden kaçmaz; aşırı analize dikkat.',
    'Terazi':
        'Merkür Terazi burcunda: Dengeli, adil ve diplomatik iletişim. Tartışmalarda tüm tarafları duyar, karar vermede zorlanabilirsin.',
    'Akrep':
        'Merkür Akrep burcunda: Araştırmacı, soran, sırlara ulaşan bir zihin. Söylediklerin kadar söylemediklerin de güçlüdür.',
    'Yay':
        'Merkür Yay burcunda: Büyük resmi görürsün ama detaylar gözden kaçabilir. Vizyon sahibi ama zaman zaman aşırı iyimser düşünce.',
    'Oglak':
        'Merkür Oğlak burcunda: Pratik, yapısal ve uzun vadeli düşünce. Spekülatif fikirler ilgini çekmez; gerçekçilik önce gelir.',
    'Kova':
        'Merkür Kova burcunda: Alışılmamış bağlantılar kurar, geleceği düşünürsün. Deha ile tuhaflık arasındaki ince çizgide gezinirsin.',
    'Balik':
        'Merkür Balık burcunda: Sezgisel, şiirsel ve imgelerle düşünen bir zihin. Mantık yerine his öne çıkar; sanata ve hikayelere yatkınlık güçlüdür.',
  },

  'Venus': {
    'Koc':
        'Venüs Koç burcunda: Aşkta ateşli ve direkt. İlk hamleyi yapmaktan çekinmezsin; ama ilgi azalınca tutku da söner kolayca.',
    'Boga':
        'Venüs Boğa burcunda — kendi evinde: Sadık, duyusal ve kalıcı sevgi. Güzel şeyler, dokunma ve güvenlik aşkını besler.',
    'Ikizler':
        'Venüs İkizler burcunda: Zekice sohbetler seni kazanır. Zihinsel uyum olmadan duygusal uyum gelişmez.',
    'Yengec':
        'Venüs Yengeç burcunda: Koruyucu ve besleyici sevgi. Aşkta yuva kurma ve güvenlik ararsin; ihanet çok derin iz bırakır.',
    'Aslan':
        'Venüs Aslan burcunda: Tutkulu, sadık ve görkemli romantizm. Sevdiğine kendini tamamen verirsin; karşılıklı övgü ve görkeme ihtiyaç duyarsın.',
    'Basak':
        'Venüs Başak burcunda: Sevgiyi hizmet ederek, detaylara dikkat ederek ve güvenilir olarak gösterirsin. Büyük jestlerden çok anlamlı küçük dokunuşlar.',
    'Terazi':
        'Venüs Terazi burcunda — kendi evinde: Estetik, zarif ve adil bir aşk anlayışı. Partnerliğe ihtiyaç duyarsın ama bağımsızlığını da korumak gerekir.',
    'Akrep':
        'Venüs Akrep burcunda: Yoğun, derin ve dönüştürücü bir aşk. Sıradan ilişkiler tatmin etmez; ruhsal bağ zorunluluğu hissedersin.',
    'Yay':
        'Venüs Yay burcunda: Özgürlük ve macera sevenle aşkı yaşamak. Kısıtlanmak ilişkiyi soğutur; ortak vizyon ve büyüme şart.',
    'Oglak':
        'Venüs Oğlak burcunda: Geleneksel, kararlı ve uzun vadeli ilişkiler. Aşkı romantizmle değil bağlılıkla ifade edersin.',
    'Kova':
        'Venüs Kova burcunda: Alışılmadık ilişkiler ve özgün bağlar. Kural tanımayan bağlantılar seni çeker; yakınlık ile alan arasındaki denge hassastır.',
    'Balik':
        'Venüs Balık burcunda: Romantik, fedakâr ve neredeyse mistik bir aşk anlayışı. Sınırları korumak gerekir; yoksa kaybolursun.',
  },

  'Mars': {
    'Koc':
        'Mars Koç burcunda — kendi evinde: Enerji sınırsız, motivasyon anlıktır. Lider olmak ve ilk olmak için çabalarsin; uzun soluklu rekabette güçlüsün.',
    'Boga':
        'Mars Boğa burcunda: Yavaş ateşlenir ama bir kez harekete geçti mi kararlı ve dayanıklıdır. Maddi güvenlik için çalışmak seni sakinleştirir.',
    'Ikizler':
        'Mars İkizler burcunda: Enerjiyi söz ve fikirle ifade edersin. Çok işe başlar, tamamlamada zorlanabilirsin; zihinsel meşguliyet gerekir.',
    'Yengec':
        'Mars Yengeç burcunda: Savunmacı güdülerle hareket eder, sevdiklerini korumak için savaşırsın. Duygusal tetikleyiciler öfkeyi de hareketi de belirler.',
    'Aslan':
        'Mars Aslan burcunda: Yaratıcı projeler ve liderlik için güçlü enerji. Küçük düşürülmek öfke patlamasına yol açabilir; onur önemlidir.',
    'Basak':
        'Mars Başak burcunda: Pratik ve yöntemli çalışma tarzı. Kaosun içinde bile sistematik kalırsın; hizmet için çaba harcamak seni tatmin eder.',
    'Terazi':
        'Mars Terazi burcunda: Adalet için eylem. Çatışmadan kaçınırsın ama haksızlığa uğrayınca beklenmedik bir kararlılık gösterir.',
    'Akrep':
        'Mars Akrep burcunda: Güçlü irade ve odaklanma. Hedeflerine ulaşmak için gölgede hareket etmekten çekinmezsin; intikam duygusuna dikkat.',
    'Yay':
        'Mars Yay burcunda: Büyük hedefler için enerji. Özgürlük ve macera motive eder; küçük detaylar seni sıktırır.',
    'Oglak':
        'Mars Oğlak burcunda: Disiplinli ve sabırlı hareket. Kariyer ve uzun vadeli hedefler için olağanüstü dayanıklılık sergilersin.',
    'Kova':
        'Mars Kova burcunda: Kolektif hedefler için enerji. Bireysel hedefler yerine grubun faydasına çalışmak seni canlandırır.',
    'Balik':
        'Mars Balık burcunda: Sezgi ile hareket. Somut plan yerine his ve akış rehberlik eder; sanatsal yaratımda güçlü enerji.',
  },

  'Jupiter': {
    'Koc':
        'Jüpiter Koç burcunda: Girişimcilik ve liderlikte büyüme. Risk almak şansı getirir; yeni başlangıçlara adım atmak refahı çoğaltır.',
    'Boga':
        'Jüpiter Boğa burcunda: Maddi bolluk sabır ve temkinlilik yoluyla gelir. Yatırım ve birikim konusunda şanslı dönemler.',
    'Ikizler':
        'Jüpiter İkizler burcunda: Bilgi, iletişim ve çeşitlilik alanında büyüme. Öğrenmek ve öğretmek kapıları açar.',
    'Yengec':
        'Jüpiter Yengeç burcunda: Duygusal zeka ve aile bağları yoluyla büyüme. Ev, beslenme ve koruma konularında bolluk.',
    'Aslan':
        'Jüpiter Aslan burcunda: Yaratıcılık ve özgüven yoluyla bolluk. Sahneye çıkmak ve ilham vermek kapıları açar.',
    'Basak':
        'Jüpiter Başak burcunda: Hizmet ve uzmanlık yoluyla büyüme. Pratik beceriler ve iyileştirme çabaları ödüllendirilir.',
    'Terazi':
        'Jüpiter Terazi burcunda: İlişkiler ve ortaklıklar yoluyla büyüme. Adalet ve denge arayışı bereket getirir.',
    'Akrep':
        'Jüpiter Akrep burcunda: Derin araştırma ve dönüşüm yoluyla büyüme. Gizli kaynaklar açılır; miras ve ortaklık varlıkları için şans.',
    'Yay':
        'Jüpiter Yay burcunda — kendi evinde: En güçlü noktası. Seyahat, felsefe, din ve yüksek öğrenim alanında büyük şans.',
    'Oglak':
        'Jüpiter Oğlak burcunda: Kariyer ve yapısal başarı yoluyla büyüme. Disiplin ödülün anahtarıdır.',
    'Kova':
        'Jüpiter Kova burcunda: Toplumsal yenilik ve kolektif vizyon yoluyla büyüme. Ağlar ve teknoloji kapıları açar.',
    'Balik':
        'Jüpiter Balık burcunda: Ruhaniyet ve şefkat yoluyla büyüme. Yaratıcı ve sezgisel alanlarda bereket.',
  },

  'Saturn': {
    'Koc':
        'Satürn Koç burcunda: Öz disiplin ve sabır öğrenilmesi gereken ders. Acele kararların sonuçlarıyla yüzleşmek büyütür.',
    'Boga':
        'Satürn Boğa burcunda: Maddi güvenlik konusunda ders. Hak etmeden beklememek; birikim ve sabır ödüllendirilir.',
    'Ikizler':
        'Satürn İkizler burcunda: Odaklanma ve derinleşme dersi. Çok şey bilmek değil, bir şeyi gerçekten bilmek kazandırır.',
    'Yengec':
        'Satürn Yengeç burcunda: Duygusal bağımsızlık ve güvenlik dersi. Duygusal kısıtlamalar çalışılarak aşılır.',
    'Aslan':
        'Satürn Aslan burcunda: Onay bağımlılığından kurtulma dersi. Yaratıcı güven dışarıdan değil içeriden inşa edilmeli.',
    'Basak':
        'Satürn Başak burcunda: Mükemmeliyetçilik ve öz eleştiri dersi. Yeterince iyi olmak yetmez hissi; sağlıklı standartlar geliştirmek şart.',
    'Terazi':
        'Satürn Terazi burcunda: İlişkilerde denge ve sorumluluk dersi. Başkalaşmadan ortaklık kurabilmek öğrenilmesi gereken beceridir.',
    'Akrep':
        'Satürn Akrep burcunda: Kontrolü bırakma ve güven verme dersi. Güç oyunlarından uzak durarak derin dönüşüm mümkün olur.',
    'Yay':
        'Satürn Yay burcunda: İnanç ve özgürlük dersi. Kısıtlamalar içinde anlam bulmak ve dogmadan bağımsız bir felsefe geliştirmek.',
    'Oglak':
        'Satürn Oğlak burcunda — kendi evinde: En güçlü noktası. Kariyerde zorluklar ama sert elde edilen başarılar kalıcıdır.',
    'Kova':
        'Satürn Kova burcunda: Birey ile toplum arasındaki denge dersi. Özgünlük ile sorumluluk arasında sağlıklı bir yer bulmak.',
    'Balik':
        'Satürn Balık burcunda: Sınır koyma ve gerçekçilik dersi. Rüya ile gerçeklik arasındaki köprüyü inşa etmek temel görev.',
  },
};

// ──────────────────────────────────────────────────────────────────────────────
// 2. Ev içerikleri: 12 ev
// ──────────────────────────────────────────────────────────────────────────────

const Map<int, String> houseContentMap = {
  1:
      '1. Ev — Benlik ve Dış Görünüş\n\n'
      'Haritanın en kişisel noktası olan 1. ev, seni sen yapan özü ve dünyaya sunduğun ilk katmanı temsil eder. '
      'Yükselen burcun bu evin kapısında durur; nasıl yürüdüğünü, nasıl göründüğünü, bir odaya girdiğinde nasıl bir enerji yayıldığını yönetir. '
      'Bu ev aynı zamanda sağlık ve yaşamsallıkla da bağlantılıdır — beden, ruh ve kimliğin kesişim noktası burasıdır.\n\n'
      'Bu evde gezegen varsa, o gezegenin enerjisi doğrudan kişiliğine ve dışarıya yansıttığın imaja renk katar. '
      'Örneğin 1. evde Mars varsa güçlü ve dinamik bir varlık hissettirirsin; Venüs varsa zarif ve çekici bir izlenim doğal olarak gelir.\n\n'
      'Kendinle ilgili yaptığın her yolculuk bu evden başlar. Bu evi anlamak, kendini anlamaktır.',

  2:
      '2. Ev — Kaynaklar, Değerler ve Güvenlik\n\n'
      '2. ev para ile başlar ama çok daha derin bir soruya yanıt arar: "Ben için ne değerlidir?" '
      'Sahip olduğun şeyler, para kazanma biçimin, mülkiyet anlayışın ve en önemlisi — öz değerin bu evde barınır.\n\n'
      'Bu evdeki burç ve gezegenler, maddi dünyayla ilişkini renklendirir. '
      'Boğa veya Venüs etkisi konforu ve güzelliği ön plana çıkarır; Akrep etkisi kaynakları miras ya da ortak varlıklar yoluyla deneyimlemenizi işaret edebilir.\n\n'
      'Öz değerin yükseldikçe 2. evin maddi anlamı da berraklaşır — çünkü içindeki değer, dışındaki değeri çeker.',

  3:
      '3. Ev — İletişim, Öğrenme ve Yakın Çevre\n\n'
      '3. ev zihnin, dilin ve sokak düzeyindeki bilginin evidir. Okul öncesi öğrenme, kardeşlerle ilişki, komşuluk, kısa yolculuklar ve gündelik konuşmalar bu evin sınırları içindedir.\n\n'
      'Bu evde güçlü etkiler varsa; yazmak, konuşmak, öğretmek veya öğrenmek hayatının merkezine gelebilir. '
      'İkizler ve Merkür bu evi en iyi tanıyan figürlerdir.\n\n'
      'Düşüncelerini nasıl ifade ettiğin, bilgiyle ilişkin ve yakın çevrenle bağlanma biçimin 3. ev hikayenden okunur. '
      'Sözcükler senaristindir; bu evi anlamak anlatma gücünü tanımaktır.',

  4:
      '4. Ev — Kök, Aile ve Ev\n\n'
      '4. ev haritanın en derininde, tabanında yer alır; köklerine, geçmişine ve duygusal temeline işaret eder. '
      'Büyüdüğün ortam, anne figürüyle ilişkin, "yuva" kavramını nasıl hissettiğin bu evde saklıdır.\n\n'
      'Güçlü 4. ev enerjisi derin bir aidiyet ihtiyacı doğurur; insanlar için ev — hem fiziksel hem duygusal — kutsal bir mekandır. '
      'Yengeç burcunun doğal evidir; Ay\u2019ın etkisiyle duygusal bellek ve geçmiş bu evde yaşar.\n\n'
      'Hayatın hangi temeller üzerine inşa edildiğini, nereye ait hissettiğini ve geçmişinin bugününü nasıl şekillendirdiğini anlamak için bu evi oku.',

  5:
      '5. Ev — Yaratıcılık, Zevk ve Aşk\n\n'
      '5. ev oyunun, yaratıcılığın ve saf sevincin evidir. Çocuklarla ilişki, romantik ilişkilerin başlangıcı, sanat, kumar ve eğlence hepsi bu evde dans eder.\n\n'
      'Bu evde canlı gezegenler veya Aslan izi varsa; ifade etmek, yaratmak ve sevilmek hayatının parlak noktalarından olur. '
      'Ego ile yaratıcılık arasındaki denge bu evin en dikkat çekici gerilimlerinden biridir.\n\n'
      'Kendinle oynadığında, sahnelediğinde ve sadece yaşamanın keyfine vardığında 5. ev aktive olur. '
      'Bu evi beslemeyi unutmak, hayatı renksizleştirmektir.',

  6:
      '6. Ev — Günlük Hayat, Sağlık ve Hizmet\n\n'
      '6. ev rutinler, sağlık alışkanlıkları, iş günü ve hizmet ethosunun evidir. '
      'Çalışma biçimin, beslenmene verdiğin önem, hayvanlarla ilişkin ve küçük görevleri nasıl yerine getirdiğin — hepsi 6. ev senaryosudur.\n\n'
      'Bu evde Başak enerjisi öne çıkarsa titiz, işe yarar ve mükemmeliyetçi bir iş perspektifi gelir. '
      'Kötü yönetilen 6. ev, sağlık sorunları, tükenmişlik veya köle gibi çalışma düzenine dönüşebilir.\n\n'
      'Bedenine özenle bakmak ve günlük hayatı ritüelleştirmek bu evin armağanını açar. '
      'Monoton gibi görünen alışkanlıklar aslında büyük hedeflerin tuğlalarıdır.',

  7:
      '7. Ev — Ortaklıklar ve İlişkiler\n\n'
      '7. ev resmi ilişkilerin, evliliğin, birebir ortaklıkların ve açık düşmanların evidir. '
      'Kendinle kuramadığın denge, bu evden ayna tutar; kazanmak ve kaybetmek burada tanımlanır.\n\n'
      'Bu evdeki burç ve gezegenler partnerlik tercihlerini, ilişki kalıplarını ve birileriyle nasıl sözleşme yaptığını anlatır. '
      'Terazi burcunun evidir; karşılıklılık, adalet ve uzlaşı bu evin temel sözleşmesidir.\n\n'
      'İlişkilerin sana ayna tutuyorsa 7. evi oku — çünkü seçtiğin partnerler genellikle haritanda görmek istemediğin parçalarını hayata geçirir.',

  8:
      '8. Ev — Dönüşüm, Güç ve Derinlik\n\n'
      '8. ev en yoğun, en özel ve en dönüştürücü evdir. Ölüm ve yeniden doğuş, ortak kaynaklar, miras, cinsellik, gizli bilgi ve ruhsal dönüşüm burada yaşanır.\n\n'
      'Akrep burcunun evidir; Plüton ve Mars bu evde güç oyunlarını ve köklü değişimleri yönetir. '
      '8. ev güçlü kişiler, var olma ile yok olma arasındaki sınırı görmüş ve bunun ötesine geçmiş ruhlar çeker.\n\n'
      'Bu evi anlayamayanlar derinden korkar; anlayanlar için en büyük dönüşümün kaynağı olur.',

  9:
      '9. Ev — Felsefe, Seyahat ve Anlam\n\n'
      '9. ev büyük soruların, uzak yolculukların, yüksek eğitim ve inanç sistemlerinin evidir. '
      '"Neden buradayım?" sorusu 9. evin sorumluluğundadır.\n\n'
      'Yay burcunun ve Jüpiter\u2019in doğal evidir; burada ufkunu genişletmek, farklı kültürlerle temas ve anlam bulmak merkezdedir. '
      'Bu evi aktive etmek için bilgiyi derinleştirmek, seyahat etmek ya da felsefi bir topluluğa dahil olmak yeterlidir.\n\n'
      'Hayatının anlamını bulmak istiyorsan 9. eve bak — oraya neyin çektiği, seni en dolu hissettiren şeydir.',

  10:
      '10. Ev — Kariyer, Kamu Kimliği ve Miras\n\n'
      '10. ev haritanın zirvesinde yer alır; topluma verdiğin katkıyı, kariyer yolunu, otoriteyle ilişkini ve hayatta bırakmak istediğin izi temsil eder.\n\n'
      'MC — Ortadaki Gökyüzü — bu evden okunur. Oğlak burcunun evidir; Satürn disiplini ve uzun vadeli inşayı yönetir. '
      'Bu evi anlayan kişiler nereye gittiğini bilir ve camını temiz tutar.\n\n'
      'Kamuya açık başarılar, kariyer seçimleri ve "nasıl hatırlanmak istiyorsun?" sorusunun cevabı bu evde gizlidir.',

  11:
      '11. Ev — Topluluk, Umutlar ve Gelecek Vizyonu\n\n'
      '11. ev arkadaşlıklar, kolektif hedefler, dernekler ve geleceğe ilişkin umutların evidir. '
      '"Dünyayı nasıl daha iyi yaparım?" sorusu bu evde yankılanır.\n\n'
      'Kova burcunun evidir; Uranüs burada devrim, yenilik ve kolektif değişimi yönetir. '
      'Bu evde güçlü etkiler varsa, topluluk içinde lider olmak ya da alışılmadık gruplarla bağ kurmak doğal gelir.\n\n'
      'Tek başına ulaşamayacağın hedefler, 11. evin ağı sayesinde mümkün olur. '
      'Bul, bağlan ve büyü.',

  12:
      '12. Ev — Gizem, Bilinçdışı ve Ruhsal Yolculuk\n\n'
      '12. ev görünmezin evidir: gizli korkular, bastırılmış anılar, rüyalar, yalnızlık içinde bulunan güç ve mistik deneyimler. '
      'Balık burcunun ve Neptün\u2019ün evidir; neye göre yaşadığını değil, nasıl hissettiğini yönetir.\n\n'
      'Bu evde güçlü gezegenler, kişiyi sorgulayan fikirlere, manevi arayışlara ya da derin iç dünyalara yöneltir. '
      '12. ev kötü değil; sadece görünmeyenin dili burada konuşulur.\n\n'
      'Sanatla, meditasyonla, bakımla ya da yalnızlıkla geçirilen kaliteli zamanda 12. ev dolar. '
      'Bu evi ihmal etmek, bilinçdışının kontrolü ele geçirmesi demektir.',
};

// ──────────────────────────────────────────────────────────────────────────────
// 3. Açı içerikleri: açı türüne göre genel içerik
// ──────────────────────────────────────────────────────────────────────────────

const Map<String, String> aspectContentMap = {
  'conjunction':
      'Kavuşum Açısı — İki Güç Bir Arada\n\n'
      'Kavuşum, iki gezegenin aynı noktada (veya birbirinden 0-8° uzaklıkta) bir araya gelmesidir. '
      'Bu en güçlü açıdır; iki gezegenin enerjisi birleşir, pekişir ve tek bir varlık gibi çalışır.\n\n'
      'Kavuşum bazen aşırı yüklenme hissine yol açabilir — iki güç birbiriyle kaynaşmış ve birbirinden bağımsız hareket edemez haldedir. '
      'Hangi gezegenlerin kavuştuğu bu açıyı iyi veya zorlu yapar.\n\n'
      'Güneş - Merkür kavuşumu iletişim gücü verir; Ay - Satürn kavuşumu ise duygusal kısıtlamalarla yüzleşmeyi gerektirir. '
      'Haritanda bu kavuşumun tam koordinatını bul; hayatının hangi alanlarında çift yoğunluk hissetttiğin oradan okunur.',

  'sextile':
      'Altmışlık Açı — Fırsat Kapısı\n\n'
      'Altmışlık açı (60°), iki gezegen arasında akıcı ama çalışılması gereken bir fırsatı simgeler. '
      'Üçgen kadar kolay değildir ama kare kadar da zorlu değil. '
      'Kullanılırsa büyük kazanımlar getirir; ihmal edilirse bir potansiyel olarak haritada bekler durur.\n\n'
      'Bu açı genellikle yetenekli olduğun ama geliştirgemen gereken alanları işaret eder. '
      'Harekete geçmek şart; yoksa sadece bir "güzel olabilirdi" hikayesi kalır.\n\n'
      'Hangi alanların seni kolayca büyütebileceğini bu açı söyler. Fırsatı yakala.',

  'square':
      'Kare Açı — Büyüme Gerilimleri\n\n'
      'Kare açı (90°), iki gezegen arasında gerilim, çatışma ve zorluğu işaret eder. '
      'Bu açı sizi sarsan, zorlayan ve büyümek zorunda bırakan haritanın en dürüst seslerinden biridir.\n\n'
      'Kare açılar kolayca çözülmez; bunlar zamanla, bilinçli çalışmayla ve tekrar eden mücadelelerle dönüştürülür. '
      'Ama dönüşüm gerçekleştiğinde, bu gerilim en büyük güç kaynağına dönüşür.\n\n'
      'Haritanın yıldız oyuncuları çoğu zaman kare açılara sahiptir. Zorluk seni öldürmez; seni zorunlu kılar.',

  'trine':
      'Üçgen Açı — Doğal Akış\n\n'
      'Üçgen açı (120°), iki gezegen arasındaki en uyumlu ve akıcı bağlantıdır. '
      'Bu açıda enerjiler birbirini destekler; herhangi bir çaba gerekmeksizin yetenekler açılır.\n\n'
      'Ancak üçgen açının tuzağı da burada gizlidir: çok kolay geldiği için geliştirilmeden bırakılabilir. '
      'Haritada üçgeninle ne yaptığın, potansiyelini ne kadar hayata geçirdiğini gösterir.\n\n'
      'Bu açı bir armağandır — ama armağanlar kullanılmayınca solar.',

  'opposition':
      'Karşıtlık Açısı — Ayna ve Denge\n\n'
      'Karşıtlık açısı (180°), tam karşı kutuplarda iki gezegenin birbirini yüzleştirmesidir. '
      'Bu açı, genellikle karşı kutupta başkalarında gördüğümüz ama kendi içimizde tanımak istemediğimiz şeyleri temsil eder.\n\n'
      'İlişkilerde ortaya çıkar; partnerler, rakipler veya zıtlıklar yoluyla bu açının enerjisi dışa yansır. '
      'Denge bulunduğunda bu açı, haritanın en değerli entegrasyon noktalarından birine dönüşür.\n\n'
      'Karşıtlık açınla barışmak = hayatındaki zıtlıklara sahip çıkmaktır.',
};

// ──────────────────────────────────────────────────────────────────────────────
// 4. Kişilik kartları içeriği (Güneş × Ay × Yükselen kombinasyonu)
// Anahtar format: 'sunKey_moonKey_ascKey'  (örn: 'Koc_Boga_Ikizler')
// 1728 kombinasyonun hepsini üretmek yer kaplar; en çok görülen 48
// kombinasyon özeldir, geri kalanı dinamik fallback ile doldurulur.
// ──────────────────────────────────────────────────────────────────────────────

const Map<String, String> identityContentMap = {
  // Koç Güneş kombinasyonları
  'Koc_Koc_Koc':
      'Üçlü Ateş — Saf Koç Enerjisi\n\n'
      'Güneş, Ay ve Yükselen\'in tamamı Koç\'ta olmak... Bu son derece nadir ve son derece yoğun bir enerji kombinasyonudur. '
      'Doğrudan, hızlı, rekabetçi ve koşulsuz kendiliğindensin. Önce hareket, sonra düşünce. '
      'Sabır zulümdür sana; beklemenin anlamı yoktur zihninde.\n\n'
      'Bu yoğunluk içindeki en büyük ders: durup dinlemek de bir güçtür. '
      'Hızın seni bazen ateşinle yakar; kendi alevini yönetmek bu haritanın ömür boyu süren egzersizi.\n\n'
      'Kim olduğun, ne hissettiğin ve dışarıya yansıttığın tek bir ses çıkarır: "Şimdi, burada, benimle."',

  'Koc_Boga_Ikizler':
      'Ateş Özü, Toprak Duyguları, Hava Maskesi\n\n'
      'Koç Güneşin seni cesur ve inisiyatif sahibi kılarken, Boğa Ayın duygusal dünyanda müzik, tat, dokunma ve güvenlik arar. '
      'İkizler Yükselenin ise dışarıya meraklı, çok yönlü bir izlenim yayar.\n\n'
      'Bu kombinasyonda için ile dışın çelişkili görünür; hızlı kararlar alırsın ama içinde hâlâ "emin miyim?" sorusu çarpar. '
      'Boğa Ayın seni sakinleştirir; bu sayede Koç impulsivitesi dengede kalır.\n\n'
      'İletişim yeteneğin ve duygusal zekan bir araya gelince etkili ve güvenilir bir lider profilir çıkar. '
      'Bu haritanın en büyük armağanı: hızlı düşünmek ve iyi hissetmek aynı anda.',

  'Koc_Aslan_Yay':
      'Saf Ateş Üçgeni — Hayatı Büyütmek İçin Doğmuşsun\n\n'
      'Güneş Koç, Ay Aslan ve Yükselen Yay... Bu üç ateş burcunun bir araya gelmesi nadir ve coşkulu bir enerji alanı oluşturur. '
      'Vizyon sahibisin, ilham veriyorsun ve hareket halindeyken en canlısın. Durgunluk sana zulümdür.\n\n'
      'Aslan Ay\'ın seni görülme ve takdir edilme konusunda hassas kılar; Koç\'ın ve Yay\'ın bağımsızlık arzusuyla çarpıştığında ego çatışmaları doğabilir. '
      'Ancak bu çatışma yaratıcı sürtünme olarak değerlendirersen dönüştürücüdür.\n\n'
      'En büyük ders: büyüklüğün başkalarını küçük kılmak zorunda değil. Asıl karizman herkesi büyütürken büyümene izin verdiğinde ortaya çıkıyor.',

  // Boğa Güneş kombinasyonları
  'Boga_Yengec_Balik':
      'Su ve Toprak Uyumu — Derin Hisler, Sakin Yüzey\n\n'
      'Boğa Güneşin sana istikrar ve güzellik zevki verirken, Yengeç Ayın duygusal dünyanda en derin yuvayı arar. '
      'Balık Yükselenin dışarıya yumuşak, sezgisel ve kaçamak bir izlenim verir.\n\n'
      'Bu üç su ve toprak enerji kombinasyonu seni derin hisseden, ama çoğu zaman o derinliği gizleyen biri yapar. '
      'İnsanlara açılman zaman alır; ama bir kez güvenildi mi son derece besleyici ve kalıcısın.\n\n'
      'Duygusal empatinin gücü sınır koymayı zorlaştırır. Başkalarına taşıdığın o büyük sevginin bir kısmını da kendine yönelt. '
      'Bu harita, şefkatin ilk önce içe bakmasını istiyor.',

  'Boga_Basak_Oglak':
      'Saf Toprak Üçgeni — Kalıcı İnşa\n\n'
      'Güneş Boğa, Ay Başak, Yükselen Oğlak... Toprak elementinin üç yüzü seni son derece pratik, güvenilir ve uzun vadeli düşünen biri yapar. '
      'Başladığın şeyi bitirirsin; söz verdiğinde tutarsın; inşa etmek doğanın bir parçasıdır.\n\n'
      'Ancak bu kombinasyonun gölgesi ciddilik ve kontrol ihtiyacıdır. '
      'Spontane olmak, oyun oynamak ve anlık keyfin tadına varmak zorken bir egzersiz olarak bile yapılabilir.\n\n'
      'Bu harita bir miras bırakma haritası. Yıllar içinde biriktirdiğin şey — materyal ya da ruhsal — çevreni besleyecek ve hatırlanacaksın.',

  // İkizler Güneş kombinasyonları
  'Ikizler_Ikizler_Ikizler':
      'Saf Hava — Zihin Sonsuz, Yön Değişken\n\n'
      'Güneş, Ay ve Yükselen\'in hepsi İkizler\'de... Bu son derece zihinsel, iletişim odaklı ve akışkan bir kimlik tablosu. '
      'Birden fazla ilgi alanı, birden fazla kişilik katmanı ve her biri biraz gerçek olan çelişkili fikirler.\n\n'
      'Sıradan insanlar seni tutarsız bulur; sen aslında çok boyutlusun. '
      'Bu çok boyutluluğu derinleştirmeye odaklanmak, bu haritanın en büyük zorlananıdır.\n\n'
      'Yazmak, öğretmek, yayın yapmak ya da köprü kurmak senin yerinde olduğun alanlardır. '
      'Zihnini bir konuda gerçek otorite olmaya yönlendirdiğinde olağanüstü sonuçlar gelir.',

  'Ikizler_Terazi_Kova':
      'Hava Üçgeni — Fikir, Bağlantı, Vizyon\n\n'
      'Güneş İkizler, Ay Terazi, Yükselen Kova... Bu üç hava burcu seni sosyal, analitik ve geleceğe dönük yapar. '
      'insanlarla konuşmak, fikirler üretmek ve toplumu daha iyi naplamak için çabalamak senin oksijenidir.\n\n'
      'Terazi Ay\'ın ilişkilerde denge ararken İkizler Güneş çeşitlilik ve özgürlük ister — bu çekişme ilişki dinamiklerinde ortaya çıkabilir. '
      'Kova Yükselen ise seni alışılmadık biri olarak tanımlar; kalabalık içinde öne çıkarsın çünkü farklı düşünürsün.\n\n'
      'Bu harita bir iletişim haritası. Sözlerin, fikirlerinve bağlantıların dünyada iz bırakacak.',

  // Yengeç Güneş kombinasyonları
  'Yengec_Yengec_Yengec':
      'Saf Su — Sınırsız Empati, Derin Bellek\n\n'
      'Güneş, Ay ve Yükselen\'in hepsi Yengeç... Bu kombinasyon son derece derin bir duygusal dünya anlatır. '
      'Hislerin anında gelir, geçmişin seni güçlü biçimde etkiler ve aile-köken meseleleri hayatın merkezinde durur.\n\n'
      'Başkalarına bakım vermek neredeyse refleks gibi gelir; kendin için bakım almak ise zor ve garip hissettir. '
      'Bu haritanın en kritik dersi: alet olmadan önce doldurulman gereken bir kap sensin.\n\n'
      'Duygusal zekân ve empatik derinliğin eşsiz hediyelerdir. Bunları kendine de gösterebildikçe hakiki gücüne ulaşırsın.',

  'Yengec_Akrep_Balik':
      'Su Üçgeni — Korunma ve Dönüşüm\n\n'
      'Güneş Yengeç, Ay Akrep ve Yükselen Balık... Bu su üçgeni olağanüstü bir sezgi, derin duygusal kapasite ve hem iyileştirici hem de yaralanabilir bir kişilik çizer.\n\n'
      'Akrep Ay\'ın güveni yavaş inşa eder; Yengeç Güneşin koruma içgüdüsüyle birleşince bazı insanlara sert bir kabuk gösterirsin. '
      'Balık Yükselen ise tüm bu derinliği yumuşak ve kaçamak bir izlenim arkasında saklar.\n\n'
      'Bu kombinasyon şifacı, terapist ya da sanatçı ruhunu taşır. '
      'En büyük ders: başkalarını her zaman kurtaramazsın; bazen sadece tanık olmak yeterlidir.',

  // Aslan Güneş kombinasyonları
  'Aslan_Aslan_Aslan':
      'Saf Ateş — Işık Saçmak Zorunluluktur\n\n'
      'Üçlü Aslan kombinasyonu, kimliğin sahte olmadığı tek vitrini sunar: kendin ol, ışığını ver, sahneye çık. '
      'Hem içinde hem dışında hem de duygusal dünyanda Aslan ile yaşayan birisin; bu yoğunluk hem güç hem yük taşır.\n\n'
      'Onay ihtiyacı bu kombinasyonun kör noktasıdır. "Yeterince seviliyor muyum?" sorusu zaman zaman kararlarını şekillendirebilir. '
      'Oysa asıl özgürlük, bu soruyu sormadan da parlamak.\n\n'
      'Sana bakan insanlara ilham veriyorsun — bunu fark et ve bu sorumluluğu bilinçli taşı. Işığın başkalarını da aydınlatır.',

  'Aslan_Yay_Koc':
      'Ateş Üçgeni — Liderlik Doğanın Gereği\n\n'
      'Güneş Aslan, Ay Yay, Yükselen Koç... Üç ateş burcunun buluşması seni enerjik, cesur ve ilham verici yapar. '
      'Durağanlık yoktur bu kombinasyonda; hareket, vizyon ve eylem hayatını besler.\n\n'
      'Yay Ay\'ın anlam ve özgürlük ararken, Aslan Güneş tanınmak ve yaratmak ister; '
      'Koç Yükselen ise anında harekete geçer. Bazen bu üç enerji birbiriyle koşar göründüğünde tükenme ortaya çıkabilir.\n\n'
      'Bu harita bir eylem haritası. Konuşmak değil yapmak, seyretmek değil oynamak seni hayatta tutar.',

  // Başak Güneş kombinasyonları
  'Basak_Basak_Basak':
      'Saf Toprak — Mükemmellik Arayışı\n\n'
      'Üçlü Başak enerjisi son derece analitik, titiz ve kendine yüksek standartlar uygulan bir kimlik çizer. '
      'Her şeyi iyileştirmek istiyorsun; işini, ilişkilerini, bedenini ve düşüncelerini.\n\n'
      'İç eleştiri sesi bu kombinasyonda çok güçlü çalışır — bazen yeterince iyi hiçbir şey yoktur. '
      'Bu sesin olumlu baskısı seni gerçekten ilerleti; ama aşırıya kaçınca olumsuza döner.\n\n'
      'Hizmet etmek ve yararlı olmak bu haritanın çağrısıdır. '
      'Ama şunu bil: var oluşun yeterlidir, sadece ne verdiğin değil.',

  'Basak_Oglak_Boga':
      'Toprak Üçgeni — Güvenilirliğin Zirvesi\n\n'
      'Güneş Başak, Ay Oğlak, Yükselen Boğa... Bu kombinasyon son derece güvenilir, çalışkan ve uzun vadeli düşünen bir kişilik inşa eder. '
      'Söz verdiğinde tutarsın; hedeflerin gerçekçidir ve adım adım ulaşırsın.\n\n'
      'Oğlak Ay\'ın duygularını gizlemesi, Başak Güneşin öz eleştirisi ve Boğa Yükselenin değişime direnciyle birleşebilir; '
      'bu durum zaman zaman katı ya da mesafeli görünürsün.\n\n'
      'Bu harita güvenin kendisidir. Sana verilen görevler tamamlanır, sana emanet edilen kişiler korunur. '
      'Bunu bilerek daha değerli bir armağanı kim verebilir?',

  // Terazi Güneş kombinasyonları
  'Terazi_Ikizler_Kova':
      'Hava Üçgeni — Fikir Dünyası ve Toplumsal Bağlar\n\n'
      'Güneş Terazi, Ay İkizler, Yükselen Kova... Bu kombinasyon sosyal, entelektüel ve ileri görüşlü bir enerji alanı kurar. '
      'İnsanları bir araya getirme, köprü kurma ve yeni fikirler üretme senin doğal yetkin.\n\n'
      'İkizler Ay\'ın duygusal çeşitliliği, Terazi\'nin karar güçlüğüyle birleşince bazen eylemsiz kalırsın. '
      'Kova Yükselen ise seni "farklı" biri olarak sunar; bu fark zaman zaman izolasyon, zaman zaman özgünlük ikramı verir.\n\n'
      'Fikir üretmeyi icraat ile birleştirdiğinde harika işler ortaya çıkar. Potansiyel var; şimdi sahnele.',

  'Terazi_Terazi_Terazi':
      'Saf Hava — Denge Her Şeydir\n\n'
      'Üçlü Terazi kombinasyonu denge, estetik ve adalet odaklı son derece uyumlu bir kimlik sunar. '
      'Çatışmadan kaçınmak bu kombinasyonun güçlü ve zayıf yanı aynı anda.\n\n'
      'İlişkiler bu haritanın bütün sahnesini kaplar; kim olduğunu çoğu zaman iletişim kurduğun insanlarda görürsün. '
      'Bu sağlıklıdır — ama zamanla "Ben neyi istiyorum?" sorusu zorlaşabilir.\n\n'
      'Haritanın en büyük dersi: her iki tarafı dinlemek kadar kendi tarafına da sahip çıkmak.',

  // Akrep Güneş kombinasyonları
  'Akrep_Akrep_Akrep':
      'Saf Su — Derinliğin Efendisi\n\n'
      'Üçlü Akrep bu haritayı en yoğun, en gizli ve en dönüştürücü kombinasyonlardan biri yapar. '
      'Yüzeyin altını görürsün; insanları analiz eder, güdüleri okur ve zayıflıkları fark edersin.\n\n'
      'Bu güç sorumluluk getirir. Bilmek ne yapacağını da bilmeyi gerektirir. '
      'Güveni yavaş verir ama bir kez verince sonuna kadar verirsin — ihanetle başa çıkmak bu haritanın en zorlu sınavıdır.\n\n'
      'Dönüşüm kaçınılmazdır; buna direnç göstermek yerine onu bilinçli yönetmek bu haritanın en büyük gücüdür.',

  'Akrep_Yengec_Balik':
      'Su Üçgeni — Şifacı ve Duyarlı Ruh\n\n'
      'Güneş Akrep, Ay Yengeç, Yükselen Balık... Bu üç su burcu derinden hisseden, derin seven ve derinden yaralanan bir kişilik tablosu çizer. '
      'Sezgin inanılmaz güçlüdür; bazen konuşulmadan bile ne hissedildiğini bilirsin.\n\n'
      'Yengeç Ay\'ın köklere bağlılığı ve Balık Yükselenin sınırsız empatiyle birleştiğinde başkalarının acısını kendi acın gibi taşıyabilirsin. '
      'Bu şefkat bir armağandır ama sınır çizmeden taşınamazssın.\n\n'
      'Bu harita şifacı ruh taşır. Destek verirken kendini de desteklemeyi ihmal etme.',

  // Yay Güneş kombinasyonları
  'Yay_Yay_Yay':
      'Saf Ateş — Sonsuz Ufuk\n\n'
      'Üçlü Yay haritası, özgürlüğü nefes almak gibi gören bir ruh çizer. '
      'Sorular sor, keşfet, yolcul — bu kombinasyonda duruk hayat ölümdür.\n\n'
      'Bağlanmak, kök salmak ve taahhüt vermek bu haritanın en zor adımlarıdır. '
      'Ama gitmek sadece mesafeyi değil; bazen kendi içine gitmeyi de kapsar.\n\n'
      'En büyük yolculuk çoğu zaman dışarıda değil içeridedir. Anlam bulmak için hep uzağa gitmek gerekmez.',

  'Yay_Koc_Aslan':
      'Ateş Üçgeni — Tutkudan Eylem\n\n'
      'Güneş Yay, Ay Koç, Yükselen Aslan... Bu ateş üçgeni büyük hayaller, anında tepkiler ve doğal karizmayla donanmıştır. '
      'Sahneye çıkmak sana doğal gelir; insanlar seni izler çünkü canlılığın bulaşıcıdır.\n\n'
      'Koç Ay\'ın sabırsızlığı ve Yay\'ın sıkılganlığıyla birleştiğinde projeleri başlatırsın ama bitirmek zor gelir. '
      'Aslan Yükselen ise her şeyi daha büyük gösterir.\n\n'
      'Bu haritanın gücü kıvılcım yakmaktır. Ama kıvılcımı aleve dönüştürmek için sabır gereken tek ders.',

  // Oğlak Güneş kombinasyonları
  'Oglak_Oglak_Oglak':
      'Saf Toprak — Zirveye Adanmış\n\n'
      'Üçlü Oğlak kombinasyonu, kariyerde, sorumluluğun ve uzun vadeli hedeflerde zirveye odaklı bir kimlik sunar. '
      'Zamanı verimli kullanmak, plan yapmak ve disiplinli kalmak bu haritanın doğasıdır.\n\n'
      'Ama bu çalışma odağı zaman zaman şu soruyu bastırır: "Bütün bunları neden yapıyorum?" '
      'Anlam ve zevk bu haritanın ihmal edilen mekânıdır.\n\n'
      'Zirveye ulaştığında kutlamayı ve dinlenmeyi öğrenmek, hayatı yaşamak anlamına gelir. Yönetilebilir başarı, tüketici başarıdan daima iyidir.',

  'Oglak_Boga_Basak':
      'Toprak Üçgeni — Güvenilirlik ve İnşa\n\n'
      'Güneş Oğlak, Ay Boğa, Yükselen Başak... Bu kombinasyon son derece pratik, güvenilir ve ölçülü bir kişilik inşa eder. '
      'Başkalarının çözemediği sorunları sessiz sedasız halledersin.\n\n'
      'Boğa Ay\'ın duyusal konfora ihtiyacı ve Başak Yükselenin titanizmiyle birleştiğinde bedenini ve sağlığını ciddiye almak temel görevin olur. '
      'Oğlak Güneş ise kariyer zaferi için uzun vadeli sabrı verir.\n\n'
      'Bu harita bir inanç haritasıdır: emek boşa gitmez, zaman her şeyi olgunlaştırır, sabır altına dönüşür.',

  // Kova Güneş kombinasyonları
  'Kova_Kova_Kova':
      'Saf Hava — İnsanlığa Adanmış Vizyon\n\n'
      'Üçlü Kova, alışılmışın dışında, topluluğa yönelik ve özgün bir kimlik sunar. '
      'Kuralları sorgulamak, geleceği hayal etmek ve farklı olmak bu haritanın özüdür.\n\n'
      'Yakınlık, duygusal ifade ve bireysel ihtiyaçlar zaman zaman arka planda kalır. '
      'İnsanlığı seviyor ama bireysel insanlarla bağ kurmak zor geliyorsa bu kombinasyonun tipik çelişkisidir.\n\n'
      'Bu harita devrimci ruh taşır. Dünyayı değiştirmek istiyorsan — başla, küçük de olsa.',

  'Kova_Ikizler_Terazi':
      'Hava Üçgeni — Fikir Ekonomisi\n\n'
      'Güneş Kova, Ay İkizler, Yükselen Terazi... Bu hava üçgeni sosyal, zekî ve adalet odaklı bir yaşamı simgeler. '
      'Fikir üretmek, iletişim kurmak ve grupları bir araya getirmek sen için nefes almak gibidir.\n\n'
      'Duygusal derinlik ve yavaşlama bu kombinasyonun en az çalışılan köşeleridir. '
      'Zihni durdurup sadece hissetmek zaman zaman zorlukla\n\n'
      'Bu harita sosyal etki haritasıdır. Doğru kelimeleri doğru zamanda söylediğinde dünyaları değiştirebilirsin.',

  // Balık Güneş kombinasyonları
  'Balik_Balik_Balik':
      'Saf Su — Evrensel Şefkat\n\n'
      'Üçlü Balık kombinasyonu bu haritayı en empatik, en sezgisel ve en sınırsız kombinasyonlardan biri yapar. '
      'Başkalarının acısını hissedersin, sanatla beslenirsin ve ruhaniyetle bağın güçlüdür.\n\n'
      'Gerçeklikle ilişki, sınır koymak ve bireyseli korumak bu haritanın en zorlandığı alanlardır. '
      'Kaybolmak kolaydır — bir metafor olarak değil, gerçekten.\n\n'
      'Bu harita şefkatin en saf formunu taşır. Ama şefkat önce içine akmalıdır ki taşsın.',

  'Balik_Akrep_Yengec':
      'Su Üçgeni — Gizem ve Şifa\n\n'
      'Güneş Balık, Ay Akrep, Yükselen Yengeç... Üç su burcu en derin duygusal kapasiteyi ve sezgiyi taşır. '
      'İnsanların ruhu sana açılır çünkü onları yargılamaksızın kabul edersin.\n\n'
      'Akrep Ay\'ın yoğunluğu ve Yengeç Yükselenin koruyucu kabuğuyla birleşince dışarıya yumuşak görünürsün ama içinde derin ateşler yanar. '
      'Güven ver, ama sınır da kur.\n\n'
      'Bu harita en derin iyileştirme enerjisini taşır. Şifa hem verir hem alırsın.',
};

// ──────────────────────────────────────────────────────────────────────────────
// Fallback: spesifik kombinasyon yoksa dinamik üretim
// ──────────────────────────────────────────────────────────────────────────────

String identityFallback(String sunSign, String moonSign, String ascSign) {
  final sunDisplay = _displaySignTr(sunSign);
  final moonDisplay = _displaySignTr(moonSign);
  final ascDisplay = _displaySignTr(ascSign);
  final elem1 = _elementOf(sunSign);
  final elem2 = _elementOf(moonSign);
  final elem3 = _elementOf(ascSign);

  final sameElement = elem1 == elem2 && elem2 == elem3;
  final elemNote = sameElement
      ? 'Üç burcun da $elem1 elementinde olması bu kombinasyona güçlü bir odak ve yoğunluk katar.'
      : 'Güneşin $elem1, Ayın $elem2 ve Yükselenin $elem3 elementini taşıması zengin bir iç çeşitlilik yaratır.';

  return 'Güneş $sunDisplay · Ay $moonDisplay · Yükselen $ascDisplay\n\n'
      '$elemNote\n\n'
      'Güneş $sunDisplay kimliğinin çekirdeğini oluşturur: ${_sunEssence(sunSign)}\n\n'
      'Ay $moonDisplay duygusal iç dünyanı şekillendirir: ${_moonEssence(moonSign)}\n\n'
      'Yükselen $ascDisplay dışarıya verdiğin ilk izlenimi çizer: ${_ascEssence(ascSign)}\n\n'
      'Bu üç enerji birlikte çalışır; bazen uyum içinde, bazen yaratıcı bir gerilimle. '
      'Haritanın geri kalanını keşfederek bu üç katmanın hayatında nasıl dans ettiğini görebilirsin.';
}

String _displaySignTr(String key) {
  const map = {
    'Koc': 'Koç',
    'Boga': 'Boğa',
    'Ikizler': 'İkizler',
    'Yengec': 'Yengeç',
    'Aslan': 'Aslan',
    'Basak': 'Başak',
    'Terazi': 'Terazi',
    'Akrep': 'Akrep',
    'Yay': 'Yay',
    'Oglak': 'Oğlak',
    'Kova': 'Kova',
    'Balik': 'Balık',
  };
  return map[key] ?? key;
}

String _elementOf(String sign) {
  const fire = {'Koc', 'Aslan', 'Yay'};
  const earth = {'Boga', 'Basak', 'Oglak'};
  const air = {'Ikizler', 'Terazi', 'Kova'};
  if (fire.contains(sign)) return 'Ateş';
  if (earth.contains(sign)) return 'Toprak';
  if (air.contains(sign)) return 'Hava';
  return 'Su';
}

String _sunEssence(String sign) {
  const map = {
    'Koc': 'cesaret, inisiyatif ve direkt hareket ederek öne çıkarsın.',
    'Boga': 'güzellik, güvenlik ve kalıcı değerlere odaklanarak var olursun.',
    'Ikizler':
        'zihinsel merak, çok yönlülük ve iletişimle kimliğini inşa edersin.',
    'Yengec':
        'duygusal bağlar, koruma güdüsü ve bellek ile tanımlarsın kendini.',
    'Aslan': 'yaratıcılık, ifade özgürlüğü ve ısıtıcı liderlikle öne çıkarsın.',
    'Basak': 'analiz, hizmet ve iyileştirme arzusuyla anlam bulursun.',
    'Terazi': 'denge, adalet ve ilişkilerin dokusuyla şekillenirsin.',
    'Akrep': 'derinlik, dönüşüm ve güç arayışıyla kimliğine kök atarsın.',
    'Yay': 'anlam, macera ve vizyon peşinden giderek var olursun.',
    'Oglak': 'disiplin, uzun vadeli inşa ve sorumlulukla kendin olursun.',
    'Kova': 'özgünlük, kolektif vizyon ve kural kırmakla tanımlarsın kendini.',
    'Balik': 'empati, sezgi ve sınır ötesi bağlantıyla var olursun.',
  };
  return map[sign] ?? 'kendine özgü bir enerjiyle var olursun.';
}

String _moonEssence(String sign) {
  const map = {
    'Koc': 'anlık, yoğun hisler ve eylemle duygusal tatmin ararsin.',
    'Boga': 'istikrar, dokunsal konfor ve güvenli bağlarla beslenirsin.',
    'Ikizler': 'zihinsel uyarı ve sohbetle duygusal dünyanda dengeyi bulursun.',
    'Yengec': 'aidiyet, yuva ve derin duygusal bağlarla tatmin olursun.',
    'Aslan': 'takdir görmek, yaratmak ve sevmekle duygusal olarak dolarsin.',
    'Basak': 'yararlı olmak ve düzenlemekle iç huzurunu bulursun.',
    'Terazi': 'uyum, adalet ve bağlantıyla duygusal denge kurarsın.',
    'Akrep': 'derin güven, yoğun bağlar ve dönüşümle beslenirsun.',
    'Yay': 'özgürlük, anlam ve keşifle duygusal olarak canlanırsın.',
    'Oglak': 'kontrol, sorumluluk ve başarıyla duygusal güvenlik inşa edersin.',
    'Kova': 'bağımsızlık ve entelektüel bağlantıyla duygusal alanını korursun.',
    'Balik':
        'ruhaniyet, empati ve yaratıcılıkla duygusal dünyana anlam katarsın.',
  };
  return map[sign] ?? 'kendine özgü bir his dünyası taşırsın.';
}

String _ascEssence(String sign) {
  const map = {
    'Koc': 'enerjik, direkt ve harekete hazır görünürsün.',
    'Boga': 'sakin, güvenilir ve estetik bir izlenim verirsin.',
    'Ikizler': 'meraklı, canlı ve iletişime açık bir aura yayarsın.',
    'Yengec': 'yumuşak, koruyucu ve içten bir ilk izlenim bırakırsın.',
    'Aslan': 'karizmatik, ısıtıcı ve unutulmaz bir varlık olarak girersin.',
    'Basak': 'titiz, erişilebilir ve pratik bir dışsal kimlik sunarsın.',
    'Terazi': 'zarif, uyumlu ve bağ kurmaya açık görünürsün.',
    'Akrep': 'yoğun, gizemli ve derinlikli bir izlenim bırakırsın.',
    'Yay': 'iyimser, özgür ruhlu ve maceracı bir enerji yayarsın.',
    'Oglak': 'ciddi, güvenilir ve otoriter bir izlenim verirsin.',
    'Kova': 'alışılmadık, özgün ve ilerici bir profil çizersin.',
    'Balik': 'yumuşak, sezgisel ve kaçamak bir aura yayarsın.',
  };
  return map[sign] ?? 'özgün bir izlenim bırakırsın.';
}

// Kimlik içeriğini döndüren ana fonksiyon
String getIdentityContent(String sunSign, String moonSign, String ascSign) {
  final key = '${sunSign}_${moonSign}_$ascSign';
  return identityContentMap[key] ??
      identityFallback(sunSign, moonSign, ascSign);
}

// Gezegen içeriğini döndüren yardımcı fonksiyon
String getPlanetContent(String planetKey, String signKey) {
  return planetContentMap[planetKey]?[signKey] ??
      '${_displaySignTr(signKey)} burcundaki ${_planetLabel(planetKey)} enerjisi, '
          'haritanın bu köşesine ${_elementOf(signKey)} elementi özellikleri katar. '
          'Bu yerleşim seni hem zorlayan hem geliştiren benzersiz bir perspektif sunar.';
}

String _planetLabel(String key) {
  const map = {
    'Sun': 'Güneş',
    'Moon': 'Ay',
    'Asc': 'Yükselen',
    'Mercury': 'Merkür',
    'Venus': 'Venüs',
    'Mars': 'Mars',
    'Jupiter': 'Jüpiter',
    'Saturn': 'Satürn',
    'Uranus': 'Uranüs',
    'Neptune': 'Neptün',
    'Pluto': 'Plüton',
    'NorthNode': 'Kuzey Ay Düğümü',
    'Chiron': 'Kiron',
    'SouthNode': 'Güney Ay Düğümü',
    'Fortune': 'Şans Noktası',
    'Juno': 'Juno',
    'MC': 'MC Noktası',
  };
  return map[key] ?? key;
}
