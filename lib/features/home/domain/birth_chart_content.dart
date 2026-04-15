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
        'Önce hareket, sonra düşünce; bu sıra senin için bilinçli bir tercih değil, içgüdüsel bir zorunluluktur. '
        'Koç Güneşi seni her sabah yeniden doğuran bir ateştir; dün ne yaşandığına dair hesaplaşma bile yeniden harekete geçmeni bir süre sonra engelleyemez.\n\n'
        'İnsanlar seni lider olarak görür çünkü sen duraksamamayı bilirsin; bu cesaret bir armağandır ve çevreni de cesur kılar. '
        'Başladığın şeylere olan tutkun bulaşıcıdır; bir odaya girdiğinde enerji yoğunlaşır. '
        'Ancak sabırsızlık tuzağına dikkat et: anlık parlayan coşku seni hızla tüketebilir. '
        'Büyük zaferler çoğu zaman uzun soluklu oyunlarda kazanılır, Koç\'un en çok zorlandığı da bu maratondur.\n\n'
        'Haritanın geri kalanı bu Koç ateşini nasıl yönettiğini anlatır; bazen fırtına, bazen ısıtıcı bir ocak. '
        'Mars\'ın konumu ise bu ateşin nerede en keskin, nerede en yapıcı aktığını gösterir. '
        'Öfken hızlı alevlenir ama çabuk söner — bunu bilen çevrende kalanlar en kıymetli dostlarındır.',

    'Boga':
        'Güneş Boğa burcundayken kimliğin güzellik, güvenlik ve kalıcılık üzerine inşa edilir; bu soyut değil, somut bir gerçektir.\n\n'
        'Beş duyunla deneyimlediğin her şey sana anlam verir: iyi bir yemek masasında geçen akşam, sevdiğin insanın sesi, kaliteli bir kumaşın dokusu, evin kokusunda hissettiğin huzur. '
        'Başkaları kaos içindeyken sen sakin kalırsın — bu pasiflik değil, kendi merkezinden konuşan bir süpergüçtür. '
        'Ancak değişime direncin zaman zaman fırsatları kaçırmana yol açabilir; güvende olmak ile hapsolmak arasındaki farkı fark etmek yalnızca sana aittir.\n\n'
        'Boğa Güneşi aynı zamanda derin bir sadakat ve dayanıklılık verir — bir kez bağlandığında sözünden dönmezsin, hedefini bırakmak için ciddi bir neden gerekir. '
        'Bu dünyada emek ve sonuç arasındaki bağı en derinden anlayan burçlardan birisin. '
        'Sabırla örülmüş çabalar sende çoğu zaman beklenmedik anda büyük bir olgunluğa dönüşür. '
        'Haritandaki Venüs ve Ay, bu Boğa özünü nasıl renklendirdiğini açıklar.',

    'Ikizler':
        'Güneş İkizler burcundayken zihnin hiçbir zaman dinlenmiyor ve bu bir eksiklik değil, süpergücün.\n\n'
        'Fikirleri birleştirme, farklı dünyalar arasında köprü kurma ve insanları anlatıyla büyüleme konusunda eşsizsin. '
        'Bir konuşmayla başlayan şey birkaç saat içinde hayat değiştiren bir fikre dönüşebilir — bunu sen bile fark etmeden yaparsın. '
        'Kimliğin tek değil, çok katmanlı; ve bunda utanılacak ya da açıklanacak bir şey yok.\n\n'
        'Derinleşme korkusuyla yüzler arasında dolaşmak yerine bir konuda gerçek otorite olmayı dene. '
        'Bilgini yaymanın yanı sıra onu birikmesine izin vermek, İkizler\'in en az keşfettiği alandır. '
        'Haritandaki Merkür sana bu derini nasıl açacağını gösterir; ama ilk adım her zaman biraz daha uzun oturmaktır. '
        'Yazma alışkanlığı bu burcun en güçlü silahıdır; dağılan düşünceler kağıda döküldüğünde berraklaşır.',

    'Yengec':
        'Güneş Yengeç burcundayken kimliğin duygularla, bellek ve aile bağlarıyla örülüdür; bu bağlantı seni güçlü ve zaman zaman savunmasız yapar.\n\n'
        'Empatin bir süpergüçtür: başkalarının hislerini kelime söylenmeden anlarsın, odadaki atmosferi okur ve sezgisel olarak neye ihtiyaç duyulduğunu bilirsin. '
        'Koruma içgüdün hem seni hem de sevdiklerini güvende tutar; ama kimi zaman kendi ihtiyaçlarını arka planda bırakırsın, sanki bakım almak bir zayıflıkmış gibi.\n\n'
        'Yengeç Güneşinin en derin dersi şudur: kendin için de bir adım at. '
        'Seni besleyen şeyi bulmak, bu haritanın en kritik görevidir. '
        'Geçmişe olan bağlılığın bazen şimdiki an pahasına sürer; anıların senin gücün olduğunu, ama yaşanacak olanların daha az gerçek olmadığını hatırla. '
        'Ay\'ın konumu bu Yengeç özünün duygusal tonunu belirler.',

    'Aslan':
        'Güneş Aslan burcundayken sahne sana aittir — bu büyüklük değil, doğanın sana verdiği ışıktır ve onu saklamak kimseye fayda sağlamaz.\n\n'
        'Yaratıcılık, cömertlik ve liderlik üçlüsü senin imzandır. Sevdiğin insanlara döktüğün sevgi gerçek, yaktığın enerji sıcak, anlattığın hikayeler büyüleyicidir. '
        'Sevgi almak kadar vermeyi de bilmek bu Aslan özünün en güzel yanıdır; çünkü bu burcun gölgesi tam tersi yönde konuşlanmıştır.\n\n'
        'Onaylara bağımlılık ise zayıf noktandır; içinden gelen ışık başkalarının alkışına muhtaç değil. '
        'Alkış kesildiğinde bile aynı kişi olmak, Aslan Güneşinin en olgun halidir. '
        'Haritandaki Güneş evi, bu enerjini hayatın hangi sahnesinde daha yoğun yaşadığını anlatır. '
        'Ve hatırla: en unutulmaz Aslanlar, diğerlerinin de parlamasına alan açanlardır.',

    'Basak':
        'Güneş Başak burcundayken mükemmellik arayışın her şeyi daha iyi yapma çabasından doğar — bu seni hem vazgeçilmez hem de kimi zaman bitkin kılar.\n\n'
        'Analitik zekan, hizmet etme arzun ve detaylara olan ilgin seni çevrenin en güvenilir insanı haline getirir. '
        'Başkalarının görmediği hataları görür, iyileştirilebilecek noktaları içgüdüsel olarak fark edersin. '
        'Ama öz eleştiri sesi zaman zaman özgüvenini eritir: yapılan şey yeterince mükemmel değildir, emek yeterince görünmez, sonuç beklentinin altındadır.\n\n'
        'Sen yeterlisin, kusurlarınla birlikte ve birlikte. '
        'Bu haritayı okurken "nasıl daha iyi olabilirim?" diye sadece başkalarına değil, kendine de sor. '
        'Vücut, beslenme ve sağlık konularına olan ilgin bu Güneş yerleşiminin armağanıdır; kendine baktıkça zihninle de daha barışık olursun.',

    'Terazi':
        'Güneş Terazi burcundayken adalet, estetik ve ilişkiler kimliğinin merkezindedir; hayatının anlam haritasını bu üç koordinat çizer.\n\n'
        'Denge arayışın zamanla karar verme konusunda zorlanmana yol açabilir; ama bu aslında tüm tarafları dinleme erdeminden kaynaklanır. '
        'İnsanlar seninle konuşunca dinlenilmiş hisseder — bu nadir ve kıymetli bir armağandır. '
        'Güzelliğe, düzene ve uyuma duyduğun içgüdüsel çekim, çevreni de daha iyi bir atmosfere taşır.\n\n'
        'Başkalarını memnun etmek için kendinden taviz vermek Terazi tuzağıdır; haritandaki Venüs bunun derinliğini gösterir. '
        'Sınır koymak ne nezaketsizliktir ne de çatışmacılık; sadece kendi sesini de duyurmaktır. '
        'Uzlaşının sihiri bu burcun en büyük armağanıdır; ama önce iç dengeyi koruyan insan da sensin.',

    'Akrep':
        'Güneş Akrep burcundayken yüzeyin altını görme, sırları çözme ve köklü dönüşümleri yönetme senin alanındır; bu sıradan bir beceri değil, sezgisel bir yaşam biçimidir.\n\n'
        'Duygusal yoğunluğun çoğu zaman anlaşılmaz; bu bir güç, bir derinliktir. '
        'Güven inşa etmen zaman alır ama bir kez verdiğinde tamdır. '
        'Yarım güven, yüzeysel ilişki, kolay açılım bu burçta var olmaz — her şey ya derindir ya anlamsızdır.\n\n'
        'Kontrol ve şüphecilik ise seni bazen izole eder; her şeyi bilen ama kimseye güvenemeyen biri olmak yorucudur. '
        'Bırakmayı öğrenmek bu haritanın en büyük dönüşümüdür. '
        'Özellikle Plüton\'un konumu, bu Akrep enerjisinin hayatının hangi alanında en güçlü köklü değişim istediğini gösterir.',

    'Yay':
        'Güneş Yay burcundayken anlam, özgürlük ve keşif senin oksijenidir; bunlar olmadan en parlak ortamda bile boğulursun.\n\n'
        'Neden diye sormaktan vazgeçmezsin ve bu felsefi iştah seni hem öğretmen hem öğrenci yapar. '
        'Seyahat, kültür, vizyon, inanç sistemleri… bunlar seni hem büyüten hem bütünleyen unsurlardır. '
        'Başkalarına umut verebiliyorsun çünkü sen halihazırda büyük resmi görüyorsun.\n\n'
        'Ama başlayıp bitirememek Yay gölgesidir: özgürlük adına sorumluluktan kaçmak, macera adına köksüz kalmak. '
        'Haritandaki Jüpiter, bu dağılganlığın nerede daha yönetilebilir olduğunu işaret eder. '
        'Ve şunu bil: en derin özgürlük, nereye ait olduğunu bilmekten gelir.',

    'Oglak':
        'Güneş Oğlak burcundayken kariyer, sorumluluk ve uzun vadeli inşa senin doğanın ayrılmaz bir parçasıdır; başkalarının şans dediği şey senin birikimin ve sabrındır.\n\n'
        'Disiplin ve sabır konusunda çevrendekilerden çok ilerisin. '
        'Uzak hedeflere ulaşmak için sessizce yıllarca çalışabilirsin; sosyal onay olmadan da yoluna devam edebilirsin. '
        'Yöneticilik ve yapı kurma içgüdün hem işte hem ilişkilerde kendini gösterir.\n\n'
        'Ancak duygusal dünyayla bağlantıyı kesmek, başarı adına zevki ertelemek bu haritanın seni uyardığı tehlikedir. '
        'Hayat sadece zirveye tırmanmak değil; yol boyunca yaşanacak anlardır. '
        'Satürn\'ün konumu bu Oğlak özünün hangi alanlarda en yoğun ders verdiğini anlatır. '
        'Yaşlandıkça hafifleyen Oğlaklar dünyanın en güzel insanlarına dönüşür.',

    'Kova':
        'Güneş Kova burcundayken toplumu yeniden düşünmek, kuralları sorgulamak ve geleceğe ait bir vizyon taşımak senin özündedir; bu seçimle değil, içgüdüyle gelir.\n\n'
        'Bağımsızlık ve özgünlük sen için havasız bir odada nefes almak kadar zorunludur. '
        'İnsanlığa hizmet fikri seni eyleme geçirir; bir topluluğa ait olma hissi seni besler ama bireyselliğinden ödün vermeyi asla kabul etmezsin. '
        'Bu gerilim Kova\'nın en yaratıcı ve en sancılı yeridir.\n\n'
        'Yakınlık korkusu Kova gölgesidir; fikirlerinle insanlığı kucaklarken bireysel insanlarla duygusal bağ kurmak zor gelebilir. '
        'Tek başınasın ama yalnız olmak zorunda değilsin; bu ayrımı yaşamak bu haritanın en büyük hediyesidir. '
        'Uranüs\'ün konumu bu özgünlük enerjisinin nerede en sarsıcı, nerede en ilham verici aktığını gösterir.',

    'Balik':
        'Güneş Balık burcundayken sınırlar eriyor, empatin sonsuz, hayal gücün bir okyanus kadar derindir; bu kimi zaman nimet, kimi zaman kayıp hissettirir.\n\n'
        'Sanatla, ruhaniyetle ve şefkatle bağlantın hayatına anlam katar. '
        'Başkalarının acısını kendi bedeninde hissedersin — bu hem güç hem yük. '
        'İnsanlar sana kolayca açılır; sır saklamayı bile doğal olarak senden öğrenirler.\n\n'
        'Gerçeklikten kaçış tuzağından korunmak için güçlü bir çıpa bulmak bu haritanın temel meselelerinden biridir. '
        'Sanata ya da ruhsal pratiğe yönelen Balık Güneşler bu enerjilerini son derece güçlü bir şekilde dışa vurur. '
        'Neptün\'ün konumu, bu sonsuz denizin hayatında nerede en berrak, nerede en sisli aktığını anlatır. '
        'En sağlıklı Balık, hem hayalperest hem de gerçekçi olmayı aynı anda öğrenmiş olandır.',
  },

  'Moon': {
    'Koc':
        'Ay Koç burcundayken duygular şiddetli ve ani gelir; ne hissedersen anında gösterirsin ve bu bir kural değil, içgüdüsel bir tepkidir.\n\n'
        'Duygusal tatmin için eylem gerekir — hareketsiz kalmak içini çökertir. '
        'Biri seni kızdığında ilk tepki hızlıdır; biri seni mutlu ettiğinde coşkun da hemen okunur. '
        'Öfken hızlı alevlenir ama çabuk da söner; uzun süre kin tutmak bu Ay yerleşiminin doğasında yoktur.\n\n'
        'Başkalarının yavaş temposu sinirini bozabilir; duygusal kararlarını sabırla almanı zorlar. '
        'Bu Ay yerleşimi sana özgün bir duygusal cesaret verir: hislerinle yüzleşmekten kaçınmazsın, kendini yalanlamaya tahammülün yoktur. '
        'Enerji boşaltacak fiziksel bir çıkış yolu bulmak Koç Ay\'a düzenli denge getirir.',

    'Boga':
        'Ay Boğa burcundayken duygusal güvenliğin temeli istikrar, rutinler ve dokunsal konfor üzerine kurulur; bu yüzeysel değil, varoluşsal bir ihtiyaçtır.\n\n'
        'Güzel şeyler, lezzetli yemekler ve sıcak bağlar seni besler. '
        'Müzik, doğa ve el ile yapılan işler duygusal dünyanı dengeler. '
        'Duygusal sıçramalar seni rahatsız eder; ani değişiklikler içini gergin yapar ve geçişten bile geçiş aşaması gerekir.\n\n'
        'Ama bir kez güvende hissettin mi, sevgin kalıcı ve sakinleştiricidir. '
        'İlişkilerde güvenilirliğin tüm özelliklerinin önüne geçer; sana güvenen insan yitirilmez bir hazine kazanmış gibidir. '
        'Bu Ay yerleşiminin gölgesi: inatçılık — bazen hem kendine hem karşındakine karşı.',

    'Ikizler':
        'Ay İkizler burcundayken zihin ve duygu iç içe geçer; bir duyguyu konuşmak onu daha az ağır yapar, anlatmak onu işler.\n\n'
        'Duygusal tatmin için zihinsel uyarıma ihtiyaç duyarsın; sıkıldığında ya da monotonluğa düştüğünde iç dünyan dengesizleşir. '
        'Hislerin bazen hızla değişir ve bu kararsız görünürsün ama aslında çok boyutlusun; tek bir duygunun içinde kalmak sana doğal gelmez.\n\n'
        'Yazmak, konuşmak, anlatmak duygularını işlemenin en güçlü yoludur sancın için. '
        'Günlük tutmak, bir arkadaşla uzun telefon konuşmaları ya da sesli düşünme bu Ay için şifadır. '
        'Yakın ilişkilerinde zihinsel bağlantı duygusal bağ kadar belirleyicidir.',

    'Yengec':
        'Ay Yengeç burcundayken — Ay\'ın kendi doğal evinde — duygusal dünyanda son derece derinsin; hislerin anında gelir, geçmişin izleri güçlüdür.\n\n'
        'Aile, kök ve ait olmak hissi sana güç verir. '
        'Başkalarına baktığın ve onları koruduğun kadar kendine de bak; verici olmak güzel, ama tükenme. '
        'Duygusal belleğin olağanüstü güçlüdür; onlarca yıl önceki bir izlenime bugünkü gibi sahip çıkabilirsin.\n\n'
        'Geçmişe ve anılara bağlılığın bazen şimdiye dalmanı zorlaştırır. '
        'Hem besleyici hem de talepkar olan bu Ay, duygusal doluluktan en doğal biçimde beslenir. '
        'Güvenli bir yuva — fiziksel ya da duygusal — senin için bir lüks değil, temel ihtiyaçtır.',

    'Aslan':
        'Ay Aslan burcundayken duygusal tatmin övgü, sıcaklık ve ifade etme özgürlüğüyle gelir; görülmek bu Ay için psikolojik oksijene benzer.\n\n'
        'Sevildiğini hissetmek için görmek ve görülmek istersin; basit bir iltifat içini aydınlatır, fark edilmemek seni derinden etkiler. '
        'Drama bu Ay yerleşiminin gölgesinde gizlidir; ama aynı zamanda hayatı renkli ve coşkulu kılan da sensin.\n\n'
        'Sevdiklerine cömertçe ilgi gösterirsin; aynı ilgiyi açıkça talep etmek ise zaman zaman zor gelir. '
        'Ama talep etmek hak ettiğini istemektir; bunu öğrenmek bu Ay yerleşiminin en değerli dersidir. '
        'Yaratıcı bir çıkış yolu bulduğun zamanlarda duygusal dünyan en denglisidir.',

    'Basak':
        'Ay Başak burcundayken duygusal güvenliğini yardım ederek, düzenleyerek ve faydalı olarak inşa edersin; hislerin pratik eylemle ifade bulur.\n\n'
        'Birini sevdiğinde ona pratik bir şey yaparsın: tamir edersin, organize edersin, gece saat geç olsa dahi sorularını cevaplayanın senin olduğunu bilirsin. '
        'Büyük sözler değil, tutarlı davranışlar bu Ay yerleşiminin dil sevgisidir.\n\n'
        'Ama iç eleştiri sesi bu Ay yerleşiminde yüksek çalışır; hem kendinle hem başkalarıyla aşırı titiz olabilirsin. '
        'Yeterliliğin performansına değil var oluşuna bağlı olduğunu hatırla. '
        'Bedenle olan bağlantın güçlüdür; sağlık, beslenme ve ritüeller bu Ay için duygusal temel taşlarıdır.',

    'Terazi':
        'Ay Terazi burcundayken duygusal uyum ilişkilerle, adaletle ve estetikle gelir; yalnız ve dengesiz bir ortamda iç dünyan çöker.\n\n'
        'Çatışmadan kaçınmak için kendi ihtiyaçlarını görmezden gelebilirsin; kimseyi kırmamak, barışı korumak bu Ay için birincil güdüdür. '
        'Güzellik içinde olmak, adil kararlar vermek ve bağlantı hissetmek seni besler.\n\n'
        'Karar vermekte zorlandığında bu Ay sana hem avantaj hem dezavantaj sunar: tüm tarafları görürsün ama sonunda tercih yapmak ağır gelir. '
        'Uzlaşı sanatkârı olarak tanınırsın; ama kendi tarafına da sahip çıkmayı öğrenmek bu Ay yerleşiminin en kritik büyüme alanıdır. '
        'Estetik çevreni düzenlemek — ev, giyim, koku — ruh halini hızla toparlar.',

    'Akrep':
        'Ay Akrep burcundayken duygular yüzeysel değil, derin ve sarsıcıdır; yüzeysel ilişkilere ve sahte konuşmalara tahammülün yoktur.\n\n'
        'Güven ettiğin insanlara sonuna kadar bağlanırsın; ama ihanetle başa çıkmak son derece zorlandır, bazen yıllar sürer. '
        'Hem dönüşüm hem de tutunma senin duygusal ikilemindir: bir şeyi bırakmak can acıtır ama bıraktıktan sonra tamamen biter.\n\n'
        'Bu Ay yerleşimi sana olağanüstü bir sezgi verir; kimi zaman bir bakışta insanı okursun. '
        'Bu sezgiye güvenmek onun en iyi kullanım biçimidir. '
        'Duygusal dönüşüm bu Ay için kural değil yaşam biçimidir; krizler seni genellikle daha güçlü bırakır.',

    'Yay':
        'Ay Yay burcundayken özgürlük, anlam arayışı ve keşif duygusal ihtiyaçlarının başında gelir; kısıtlanmak, sıkışmak ya da anlamsız hissetmek iç dünyanı çökertir.\n\n'
        'Sıkıştığında, daraldığında ya da anlamsız hissettiğinde duygusal dünyanda fırtına kopar. '
        'Macera, öğrenme ve umut seni besler; geleceğe olumlu bakmak bu Ay için psikolojik bir ihtiyaçtır, lüks değil.\n\n'
        'Duygusal bağlılıkta kök salmak ise en büyük zorluğun olabilir; özgürlüğünü kısıtlamayan bir yakınlık modeli bulmak bu Ay\'ın ömür boyu aradığı dengedir. '
        'Felsefe, din ya da doğayla bağlantı duygusal şifa için güçlü araçtır. '
        'Neşe ve kahkaha bu Ay için en kısa iyileşme yoludur.',

    'Oglak':
        'Ay Oğlak burcundayken duygular dışarıya az yansıtılır; güçlü görünmek içgüdüsel olarak önce gelir ve bu çoğu zaman gerçek hisleri maskeler.\n\n'
        'Sorumluluk ve kontrol duygusal güvenlik kaynağındır. '
        'Bir plan yapmak, adımları bilmek ve yavaş ama kararlı ilerlemek duygusal olarak seni denger kılar. '
        'Başarı hissi bu Ay için bir lüks değil, duygusal bir ihtiyaçtır.\n\n'
        'Ama bu güçlü görünme çabası zaman zaman bağ kurmanı zorlaştırır; savunmasız görünmek zayıflık gibi hissettirdiğinde gerçek yakınlık oluşmaz. '
        'İçindeki çocuğu, oyunu ve spontane sevinci bulmak bu yerleşimin iyileşme yolculuğudur. '
        'Yaş ilerledikçe bu Ay, katılığını bırakır; deneyimle kazanılan yumuşaklık olağanüstü bir güce dönüşür.',

    'Kova':
        'Ay Kova burcundayken duygusal bağımsızlık temel ihtiyaçlarından biridir; yakın olmak istiyorsun ama çok kıstırılmak istemiyorsun — bu denge hassastır.\n\n'
        'İnsanlığa karşı hissettiğin genel sevgi bazen yakınındakilere gösterdiğin bireysel sıcaklığı gölgeler. '
        'Bir gruba ait hissetmek seni besler; ama grubun içinde bile farklılığını koruyan biri olarak kalırsın.\n\n'
        'Sezgilerinle ve insani fikirlerinle iç içe geçmiş bir duygusal dünya yaşarsın. '
        'Mantıksallaştırma bu Ay\'ın güçlü ama zaman zaman hisleri örtbas eden mekanizmasıdır. '
        'Duygularını doğrudan hissetmek, analiz etmeden önce sadece var olmalarına izin vermek bu Ay için en erişilmesi zor hediyedir.',

    'Balik':
        'Ay Balık burcundayken duygusal sınırlar çok geçirgen; başkalarının acısını adeta içine çekersin ve bu hem empatini hem bağlantını güçlü kılar.\n\n'
        'Yaratıcılık, müzik, rüya ve ruhaniyetle bağlantın bu Ay yerleşiminin ruhunu anlatır. '
        'Bir film seni ağlatabilir, bir müzik parçası saatler boyu ruh halinizi belirleyebilir; bu hassasiyet bir zayıflık değil, gerçekliği derin hissetme yeteneğidir.\n\n'
        'Kendin için zaman yaratmak ve gerçeklikle bağını sağlamlaştırmak önceliğin olmalı; yoksa başkalarının duygusal yükünü taşırken kendi ağırlığını unutursun. '
        'Bu Ay sana inanılmaz bir şefkat ve sezgi verir; bunu hem kendine hem insanlara yönelt. '
        'Sanat, müzik ya da sessizlik bu Ay için en güçlü duygusal arındırma araçlarıdır.',
  },

  'Asc': {
    'Koc':
        'Yükselen Koç ile dünyaya dinamik, direkt ve enerjik bir izlenim verirsin; girdiğin odayı hissettirirsin ve insanlar seni fark eder.\n\n'
        'Beden dilinde güç, yüz ifadende kararlılık okunur. Harekete hazır bir duruş, hızlı adımlar ve doğrudan göz teması bu yükselenin imzasıdır. '
        'Özellikle ilk izlenimde aceleci ya da saldırgan görünebilirsin; ama bu dışarıya sızan adrenalindir, içinde her zaman daha hesaplısındır.\n\n'
        'Mars tarafından yönetilen bu yükselen haritanın tamamından bağımsız olarak sana rekabetçi bir ilk katman katar. '
        'Kıyafet ve görünüm konusunda pratik ve işlevsel seçimler yapmak bu yükselene doğal gelir. '
        'Zamanla öğrenilmesi gereken ders: dinlemek, duraksamak ve karşındakine alan açmak da liderliğin parçasıdır.',

    'Boga':
        'Yükselen Boğa ile sakin, güvenilir ve estetik bir izlenim verirsin; insanlar sana güvenir çünkü beden dilin ve ses tonun rahatlatıcıdır.\n\n'
        'Güzelliğe, kaliteye ve konfora ilgin dışarıdan da okunur. Kıyafet, mekan ve estetik seçimlerinde tutarlı bir zevk gösterir ve başkalarına da bu zevki yansıtırsın. '
        'Ağır hareket etmen, zamana ihtiyaç duyman bazen yavaş ya da inatçı gösterebilir seni; oysa sen sadece eminleşmek istiyorsundur.\n\n'
        'Bu yükselen bedenle ilişkini, konfor bölgeni ve fiziksel iştahını da şekillendirir. '
        'Sağlık ve beden bu yükselen için özellikle önemlidir; iyi yemek, dinlenme ve fiziksel zevk duygusal dengeyi destekler. '
        'Venüs\'ün konumu bu Boğa yükselenin hangi alanlarda en güçlü yansıdığını gösterir.',

    'Ikizler':
        'Yükselen İkizler ile meraklı, uyanık ve iletişime hazır bir izlenim yaratırsın; gözlerin her şeyi kaydeder, ellerin konuşurken hareket eder.\n\n'
        'Sosyal ortamlarda kolayca bağ kurarsın; insanlar seninle sohbet etmekten hoşlanır çünkü hem söyleyecek şeyin vardır hem de gerçekten dinliyorsundur. '
        'Tutarsız ya da derinsiz görünmek bu yükselenin gölgesidir; oysa sen çok katmanlısın sadece.\n\n'
        'Merkür yönetimi bu yükselenlere keskin bir zihin ve güçlü adaptasyon yeteneğiyle donatır. '
        'Genç göründüğün ya da yaşından genç hissettirdiğin söylenir; hareketli enerji, meraklı bakışlar ve değişken ifade bu yükselenin fiziksel imzasıdır. '
        'Yazılı ve sözlü iletişim bu yükselenin en doğal ifade mecrasıdır.',

    'Yengec':
        'Yükselen Yengeç ile dünyaya çekingen ama sıcak bir ilk izlenimle girersin; tanımadığın insanlarla ilk anlarda kabuğuna çekilirsin ama zamanla son derece besleyici ve koruyucusun.\n\n'
        'Yüzündeki duygu geçişleri hızlıdır; hisleri saklamak zaten hiç öğrenemedeydin. '
        'Göz temasında bile bir duyarlılık okunur; insanlar seni nazik bulur ve rahatsız etmekten çekinirler.\n\n'
        'Bu yükselen anne figürleri ve güvenli mekanlarla güçlü bir bağ oluşturur. '
        'Yuvaya benzeyen çevreler yaratma yeteneğin örnek alınır; bulunduğun mekanı sıcaklaştırmak için fazladan çaba harcamana gerek yoktur. '
        'Ay\'ın konumu bu yükselenin nasıl şekillendiğini en derinden belirler.',

    'Aslan':
        'Yükselen Aslan ile sahneye çıktığında tüm gözler sana döner — bunu istemesen bile ve aklında olmasa bile.\n\n'
        'Saçın, kıyafetin, duruşun ya da ses tonunda bir kral veya kraliçe enerjisi okunur. '
        'Açık renk ya da göz alıcı kıyafetlere doğal bir eğilim, dik yürüyüş ve karizmatik gülümseme bu yükselenin imzasıdır. '
        'Övgüye açık, bağlılığa muhtaç görünebilirsin ilk bakışta; ama bu yükselenin gerçek armağanı insanlara ilham verme kapasitesidir.\n\n'
        'Güneş hangi burçta olursa olsun Aslan yükselen sahneyi ısıtır. '
        'En güçlü olduğun an: başkalarının da parlamasını sağlarken sen de parlıyorsun.',

    'Basak':
        'Yükselen Başak ile dikkatli, titiz ve erişilebilir bir izlenim verirsin; sadeliği seversin, dikkat çekmeyi değil yararlı olmayı hedeflersin.\n\n'
        'Başkaları sorununuzu Başak yükselen birine getirir çünkü çözüm odaklı yaklaşımın hemen okunur. '
        'Temiz, sade ve düzenli bir görünüm bu yükselenin doğal tercihi; şatafat ve abartı rahatsız edici gelir.\n\n'
        'Aşırı eleştirel görünmek bu yükselenin tuzağıdır; ama aslında sen sadece iyileştirmek istiyorsundur. '
        'Hizmet anlayışın ve pratik zekân çevirende güven yaratır. '
        'Sağlık rutinleri ve düzenli alışkanlıklar bu yükselenin en iyi performans aracıdır.',

    'Terazi':
        'Yükselen Terazi ile zarif, dengeli ve hoş bir izlenim verirsin; insanlar seninle tanışmaktan memnun kalır ve bir süre sonra neden bu kadar memnun kaldıklarını açıklayamazlar.\n\n'
        'Kibarlığın ve estetiğin fark edilir. Giyim, beden dili ve söz seçiminde estetik bir uyum bulunur. '
        'İlk tanışmada çatışmadan kaçınman seni bazen tutarsız ya da karaktersiz gösterebilir; oysa sen sadece barışçılsındır.\n\n'
        'Venüs yönetimi bu yükselenlere fiziksel çekicilik ve sosyal zarafet verir. '
        'Diplomatik zekânla zorlayıcı ortamları bile daha uyumlu bir hale getirebilirsin. '
        'En büyük ders: zarif duruş kendi sınırlarını da içerir.',

    'Akrep':
        'Yükselen Akrep ile yoğun, gizemli ve nüfuz eden bir izlenim yaratırsın; insanlar seni zor okur ve bu bazen korkutucu, bazen çekici bulunur.\n\n'
        'Gözlerin konuşur; söylediğinden fazlasını ifade eder bakışın. '
        'Sırlarını kolayca vermezsin ve bu güvensizlik değil, içgüdüsel bir korunmadır. '
        'Çoğu insan seni gerçekten anladığını düşünür; nadiren haklı olurlar.\n\n'
        'Bu yükselen güç dinamikleri ve dönüşümle derin bir ilişki kurar. '
        'Fiziksel görünümünde yoğun ve çekici bir enerji bulunur; aşırı süslü olmaktan çok anlam yüklü bir imaj tercih edersin. '
        'Plüton\'un konumu bu yükselenin nerede daha güçlü ya da daha kırılgan olduğunu anlatır.',

    'Yay':
        'Yükselen Yay ile iyimser, özgür ruhlu ve maceracı bir izlenim verirsin; gülen gözlerin ve kaygısız duruşun insanları sana doğru çeker.\n\n'
        'Fikirlerin ve vizyonun konuşmana yansır; sohbetler seninle derinleşir ve perspektif açar. '
        'Uzun bacaklar, güçlü bir yürüyüş ve açık bir beden dili bu yükselenin fiziksel imzasıdır.\n\n'
        'Sınırsallığa ve sorumluluktan kaçmaya meyilli görünebilirsin; ama aslında büyük resmi gören birisin. '
        'Jüpiter\'in konumu bu yükselenin en parlak kapılarını gösterir. '
        'Mizah ve neşe bu yükselenin en doğal savaş silahlarıdır.',

    'Oglak':
        'Yükselen Oğlak ile ciddi, güvenilir ve otoriter bir izlenim verirsin; insanlar seni ilk bakışta saygın bulur ve görev teslim etmekten çekinmezler.\n\n'
        'Gülümsemen nadir olabilir ama değerlidir; gerçek bir sıcaklık özel anlarda teslim edilir. '
        'Giyim ve görünümde klasik, kaliteli ve zamanın ötesinde tercihler öne çıkar. '
        'Otoriter görünümün gençken sorun yaratabilir; yaş ilerledikçe bu yükselen güç kazanır.\n\n'
        'Satürn\'ün konumu bu yükselenin hangi alanlarda en güçlü biçimde öne çıktığını anlatır. '
        'Yaş ilerledikçe bu yükselen yumuşar; genç Oğlak yükselenler zamanla çiçek açar — gerçek güzellik zamanla gelen taraftır.',

    'Kova':
        'Yükselen Kova ile alışılmadık, özgün ve ilerici bir izlenim verirsin; tarzın, temaların veya konuştuğun fikirlerin başkalarınınkinden farklı olduğu hemen fark edilir.\n\n'
        'İnsanlar seni "farklı" biri olarak görür ve bu bir complimandır. '
        'Kıyafet ve stil seçimlerinde özgürce hareket edersin; ne moda ne de anti-moda değil, sadece kendi yolun. '
        'Fiziksel hareketlerin öngörülmez ve kendiliğinden olabilir; bu enerji bazen dağınık bazen büyüleyici okunur.\n\n'
        'Duygusal mesafe Kova yükselenin tuzağıdır; yakınlığa izin vermek bilinçli bir seçim gerektirir. '
        'Uranüs\'ün konumu bu yükselenin toplumsal ve bireysel alanda nasıl titreştiğini anlatır.',

    'Balik':
        'Yükselen Balık ile yumuşak, rüya gibi ve sezgisel bir izlenim verirsin; insanlar sana kolaylıkla açılır, mahrem şeylerini söyler ve sonra neden söylediklerini anlamazlar.\n\n'
        'Dış görünüşün değişken olabilir; aynı Balık yükselen birine gün içinde pek çok farklı sefer bakılabilir. '
        'Gözlerin buğulu ya da derin görünür; bakışın olduğundan uzaklarda gibi hissettirebilir.\n\n'
        'Bu yükselen sanatsal bir alımlılık ve ruhaniyetle güçlü bir bağ getirir. '
        'Neptün\'ün konumu bu kaçamak ve sezgisel yükselenin hayatında nasıl bir renk kattığını gösterir. '
        'Sınır koymayı öğrenmek bu yükselenin en kritik gelişim alanıdır; yoksa çevrenin enerjisini doğrudan içine çekersin.',
  },

  'Mercury': {
    'Koc':
        'Merkür Koç burcundayken düşüncen bir ok gibi hedefe doğru fırlar — hazırlık yapmadan, gecikmeden, doğrudan. Zihin, bedenin önüne geçmeye alışmış değil; tam tersine, düşünce ve eylem neredeyse eşzamanlı gerçekleşir. Bu sana inanılmaz bir sezgisel doğruluk verir; çoğu zaman ilk aklına gelen şey gerçekten de doğrudur.\n\n'
        'İletişimde doğrudansın, belki biraz sert ama kesinlikle dürüstsün. İnsanlar senden ne düşündüğünü sormaya gerek duymaz; zaten söylemiş olursun. Bu sayıklık değil, otantiklik meselesidir. Ama aynı bu özellik seni zaman zaman patavatsız ya da diplomatik değil gibi gösterebilir. Sabırsızlık, bir fikri tam olarak ifade etmeden başka bir fikre atlamana yol açabilir.\n\n'
        'Güçlü yanın, yavaşlayan ya da duraksayan grupları canlandırma yeteneğidir. Toplantılarda çoğunlukla ilk fikri sen üretirsin ve bu fikir genellikle tartışmanın omurgasını oluşturur. Öğrendikçe gelişmek istiyorsan, bir fikri savunmadan önce onu birkaç saniye daha tutmayı dene. O birkaç saniye, sözünü mücevhere dönüştürebilir.',
    'Boga':
        'Merkür Boğa burcundayken düşünce, toprak gibi ağır ve köklüdür. Zihnin acele etmez; bilgiyi sindirmen, test etmen, gerçek hayata uygulamanı görmeni gerektirir. Bu yavaşlık bir kusur değil, sağlam bir zemin üzerine inşa etme ihtiyacının göstergesidir. Bir konu üzerine karar vermeden önce tüm boyutlarını hisseder, koklarsın adeta.\n\n'
        'Zihninle öğrenmen, tekrar ve pratik yoluyla daha kolay gerçekleşir; soyut teoriler seni pek güdülemez. Ama bir kez bir kavramı kavradığında o bilgi kalıcıdır ve gerçek anlamda senindir. İletişimde söylediklerinin ağırlığı vardır. Kelimelerini yerli yerince seçersin, gereksiz yere konuşmazsın.\n\n'
        'Gölge yönün, tutumluluğun katılığa dönüşmesidir. Bir kez karar verdiğinde fikri değiştirmekte direniş gösterebilirsin — bu sağlamlık mı, inatçılık mı? İkisi arasındaki çizgiyi anlamak seni özgürleştirecektir. Yeni bir fikirle karşılaştığında "değişmek yetersizlik değil, büyümektir" şiarını hatırla.',
    'Ikizler':
        'Merkür İkizler burcunda kendi evindedir ve bu, zihnin doğallıkla parlayacağı anlamına gelir. Düşünce tarzın hızlı, bağlantılı ve çok katmanlıdır. Birden fazla fikri aynı anda tutabilir, aralarındaki ilişkileri sezebilir ve bunu başkalarına anlatma konusunda doğal bir yeteneğin vardır. Merak seni her yere götürür; bir konu seni ilgilendirir, araştırırsın, paylaşırsın ve başka bir konuya geçersin.\n\n'
        'İletişim senin için nefes almak gibidir. Yazar, konuşmacı, öğretmen ya da sosyal medya içerik üreticisi olman fark etmez — sözcükleri bir alet gibi kullanırsın. Zihninse hiç durmaz; uyurken bile düşünürsün. Bu sürekli hareket seni canlı ve ilginç kılar, ama zihinsel yorgunluk da kaçınılmazdır.\n\n'
        'Dikkat dağınıklığı ve yüzeysellik sana en sık çarpan gölgelerdir. Bir şeyi gerçekten derinlemesine öğrenmek için zaman zaman hız kesmek gerekir. Seçici derinlik, zihinsel çok yönlülüğünle birleştiğinde, seni yalnızca zeki değil aynı zamanda bilge yapabilir.',
    'Yengec':
        'Merkür Yengeç burcundayken düşünce yalnızca akılda değil, vücudun içinde de yaşar. Sezgin, bir bilgisayarın mantığından çok bir şairin içgüdüsüne benzer; durumu hissederek anlar, verileri değil atmosferi işlersin. Duygusal zeka, zihinsel değerlendirmenin önündedir; bu nedenle kararlarında hem kalbini hem de nedenlerini duyarsın.\n\n'
        'Hafızan güçlüdür — özellikle duygusal anlar söz konusu olduğunda. Yıllar önce yaşanan bir konuşmanın tonunu, havasını hatta sözcüklerini kelimesi kelimesine hatırlayabilirsin. Bu enerji sana empati ve anlayış verir; insanların alttan alta ne hissettiğini sezersin. Geri bildirimde bulunurken önce karşı tarafın duygusal ihtiyacını karşılar, sonra söylemek istediğini söylersin.\n\n'
        'En büyük zorlukların, aşırı kişiselleştirme ve savunmacılıktır. Nötr bir yorumu kendine yönelik eleştiri olarak okuyabilirsin. Aynı zamanda ruh haline göre değişen bir düşünce ritmin var; kendine en iyi koşullarda karar vermek için sakin, güvende hissettirici ortamlar yarat.',
    'Aslan':
        'Merkür Aslan burcundayken zihnin bir sahne üzerinde yaşar. Fikirler sıradan değil, bir performanstır — dramatik, renkli ve iz bırakan. Düşüncelerini ifade etmek için basit cümleler seçmezsin; benzetmeler, hikayeler, anılar ve imgeler kullanırsın. İnsanlar seni sadece anlatım biçimin için bile dinleyebilir.\n\n'
        'Yaratıcı fikirler üretmek senin için oyun gibidir. Monoton rutin toplantılar seni ilhamsız bırakır; ama bir fikir beyin fırtınasında ya da spontane bir tartışmada zihnin kıvılcım atar. Liderlik rollerinde, gruba vizyon kazandırma yeteneğin öne çıkar — insanlar seni fikirlerinin sahibi olarak değil, onları harekete geçiren kişi olarak hatırlar.\n\n'
        'Gölge yönün, övgüye olan bağımlılık ve farklı görüşlere kapalılık olabilir. Fikrin eleştirildiğinde savunmacı bir duruş sergileyebilirsin. Hatırla: en güçlü zihinler, kendi düşüncelerini sorgulayabilen zihinlerdir. Bu sorgulama yaratıcılığını kırmaz; onu daha olgun ve kalıcı yapar.',
    'Basak':
        'Merkür Başak burcunda kendi evindedir ve bu güçlü bir konumdur. Analizin, bir cerrahın hassasiyetiyle çalışır; büyük resmi gördükten sonra onu bileşenlerine ayırır, her parçayı test eder ve sonucu yeniden birleştirirsin. Hatalı bir veri, mantık zincirinde sana hemen görünür; başkalarının atlayıp geçtiği tutarsızlıkları fark edersin.\n\n'
        'İletişimde kesin, net ve güvenilirsin. Bir şey söylediğinde ardında bir araştırma vardır; rastgele konuşmazsın. Yazılı ifadede özellikle güçlüsün; teknik içerik, talimat veya analiz gerektiren her alanda doğal bir üstünlük taşırsın. Düzeltmek, geliştirmek ve mükemmelleştirmek sana tatmin verir.\n\n'
        'En kritik gölgen, aşırı analiz ve öz eleştiridir. Kendi söyleyeceğin şeyi "yeterince doğru mu, iyi ifade ettim mi, yanlış anlaşılır mıyım?" diye defalarca süzmek, seni sessizliğe iter. Bazen mükemmeli beklemek yerine "yeterince iyi" ile hedefe ulaşmak gerekir. Eleştiri bir silah değil, sürekli büyüme için bir araçtır — ama bu önce kendine uyguladığın bir araç olmamalı.',
    'Terazi':
        'Merkür Terazi burcundayken düşünce, adalet terazisi gibi çalışır. Tek bir bakış açısıyla yetinmezsin; her konunun birden fazla tarafını görmek, farklı perspektifleri duygulanmadan değerlendirebilmek senin için doğaldır. Bu özellik seni olağanüstü bir arabulucu, danışman veya avukat yapar.\n\n'
        'İletişimin nazik, dengeli ve nüanslıdır. İnsanları incitmeden gerçeği söyleme konusunda zanaatkarsın. Ama bu zarif yüzey zaman zaman bir bedel öder: karar vermek senin için streslidir. İki eşit derecede geçerli seçenek arasında gidip gelmek, bazen hem seni hem de etrafındaki insanları yorabilir.\n\n'
        'Gölgen, fikrinle özdeşleşmekte zorlanmaktır. "Her ikisi de doğru olabilir" kalkanı iyi niyetli ama zaman zaman sorumluluktan kaçış gibi görünebilir. En büyük büyümen, kendi tutumunu net olarak ortaya koymak, ardından bunu savunmak olacak. Adil olmak, tarafsız kalmak anlamına gelmez.',
    'Akrep':
        'Merkür Akrep burcundayken zihnin yüzey bilgiyle tatmin olmaz. Her şeyin altındaki gerçeği, her konuşmanın arkasındaki niyeti, her olayın görünmeyen boyutlarını araştırırsın. Bu derinlik, seni bir dedektif, psikolog ya da araştırmacı haline getirir — yüzeysel anlatılara şüpheyle bakarsın.\n\n'
        'İletişiminde güç vardır. Az konuşursun ama söylediklerinin ağırlığı vardır. Bir bakış, bir soruyla çok şey anlatırsın. Sessizliğini bile iletişim aracı olarak kullanırsın. İnsanlar sana sırlarını anlatır çünkü bir şekilde güvende hissettirirsin; ama kendi sırlarını nadiren paylaşırsın.\n\n'
        'Gölgen, takıntı eğilimi ve şüpheciliktir. Bir konuyu çok derinlemesine araştırmak ya da bir kişinin motivasyonunu sürekli sorgulamak, seni gerçek bağlantıdan uzaklaştırabilir. Ayrıca bazen manipülatif iletişim kurma tehlikesi de taşırsın — bilginin gücünü fark et ve onu etik biçimde kullan.',
    'Yay':
        'Merkür Yay burcundayken zihnin ufka bakar. Detaylar değil, anlamlar ilgini çeker. "Bu ne anlama geliyor?" ve "Bu nereye bağlanıyor?" soruları sürekli kafanda döner. Filozofik, dinî, kültürel ya da felsefi büyük fikirler seni heyecanlandırır; küçük prosedür tartışmaları ise sıkar.\n\n'
        'Harika bir öğretmen ve ilham verici bir konuşmacısın. İnsanlara bilgi aktarmayı sevdiğin kadar, onları bizzat düşünmeye teşvik etmekten de zevk alırsın. Yabancı kültürler, farklı inançlar, bilinmeyenler seni büyüler. Öğrenmek için yolculuk etmek, okumak, keşfetmek yaşamının ayrılmaz parçasıdır.\n\n'
        'Gölgen, atlamak, çıkarsama yapmak ve detayları gözden kaçırmaktır. Sonuca çok hızlı ulaştığında, yol boyunca önemli bilgiler kaybolabilir. Büyük vizyon harika; ama bazen o büyük fikri hayata geçirecek adımlar ayrıntının içindedir. Sabırlı olmayı öğrenmek, fikirlerinin gerçeğe dönüşüm sürecini tamamlar.',
    'Oglak':
        'Merkür Oğlak burcundayken düşünce bir sorunun en pratik çözümünü arar. Spekülatif, hayali ya da kanıtlanmamış fikirler zihnini pek meşgul etmez; uygulanabilir, test edilmiş ve sonuç verecek bilgiler ilgini çeker. Bu seçicilik seni çok becerikli bir problem çözücü yapar.\n\n'
        'İletişiminde sözcük israfı yoktur. Gereksiz süslemelerden uzak, doğrudan ve otoriter bir anlatım tarzın vardır. İnsanlar fikirlerini sana açar çünkü pragmatik bir geri dönüş alacaklarını bilirler. Yazılı iletişimde bile öz ve yapısal olmayı tercih edersin; sunumların ve raporların nettir.\n\n'
        'Gölgen, katılık ve fikirsel tutuculuktur. "Kanıtlanmamış şeye yatırım yapmam" tutumu bazen yeni fırsatları veya devrimci fikirleri kaçırmana neden olabilir. Zihni zaman zaman belirsizlikle çalışmaya zorlamak, kapasiteni genişletir. Yaratıcı düşünce, verimliliğin düşmanı değil; tamamlayıcısıdır.',
    'Kova':
        'Merkür Kova burcundayken zihnin, başkalarının henüz görmediği bağlantıları kurar. Aykırı fikirler, sıra dışı teoriler ve "henüz keşfedilmemiş doğrular" seni büyüler. Bu yüzden zaman zaman çevrendekiler seni anlamakta zorlanır; sen ise anlaşılmayı beklemekten çok, fikrin kendisiyle ilgilenirsin.\n\n'
        'Teknoloji, bireycilik, kolektif bilinç ve insanlığın geleceği gibi konular zihnini en çok besleyen alanlardır. Sistemleri eleştirmek ve alternatifleri hayal etmek için zihinsel enerji harcarsın. İnsanlarla zeka düzeyinde bağlantı kurarsın; duygusal uyum değil, fikir alışverişi seni bir ilişkiye bağlar.\n\n'
        'Gölgen, mesafeli ve soğuk görünme eğilimidir. Entelektüel mesafeni korurken insani sıcaklıktan uzaklaşabilirsin. Ayrıca "farklı düşünme" takıntısı bazen seni gerçekten doğru olan basit şeyleri reddetmeye itebilir. Özgünlük için farklı olmak değil, dürüst olmak gerekir.',
    'Balik':
        'Merkür Balık burcundayken düşünce, somut mantıktan çok imgeler, metaforlar ve hisler aracılığıyla biçimlenir. Zihninle değil, tüm varlığınla anlarsın; bir konuyu kavramadan önce onu hissedersin. Bu sezgisel anlayış seni sanatçı, şair, terapist ya da vizyoner kılar.\n\n'
        'İletişiminde güzellik vardır — sözcüklerin ritmi, kurduğun imgeler, anlattığın hikayeler insanların içine işler. Yaratıcı yazı, müzik sözleri ya da anlatı sanatı için doğal bir yeteneğin vardır. Empatin güçlüdür; karşındakinin o an ne hissettiğini söylemeden anlayabilirsin.\n\n'
        'Gölgen, belirsizlik ve odaklanma güçlüğüdür. Pratik konuları takip etmek, tarihleri ve sayıları hatırlamak senin için bazen zorlu olabilir. Zihin sisli sularda yüzdüğünde karar vermek güçleşir. Rutinler, listeler ve yapısal alışkanlıklar seni bu sisin içinden çıkarır. Sezgiyi mantıkla dengelemek, güçlü yanını daha da etkili kılar.',
  },

  'Venus': {
    'Koc':
        'Venüs Koç burcundayken aşkta öncüsün — beklemez, düşünmez, hissedince hamle yaparsın. İlişkinin ilk anları, o ilk kıvılcım ve hız heyecanı seni büyüler. Aşık olmak kolaydır; sabırla, çabayla ve uzun soluklu bir bağlılıkla büyütmek ise öğreneceğin en büyük derstir.\n\n'
        'Seni çeken insanlar enerjik, cesur ve özgüvenlidir. Silik ya da bağımlı bir partner seni zamanla bunaltır. Kendi bağımsızlığını korurken birini sevmek, Venüs Koç için hayati bir dengedir. Güzellik anlayışın dinamik ve etkileyicidir; moda, atletizm, güç iceren estetik seni çeker.\n\n'
        'Gölgen, hayal kırıklığına tahammülsüzlük ve monotonluktan kaçmak için ilişkileri terk etmektir. Heyecan azalınca bağlılık da azalır risk. Unutma: gerçek tutku zaman zaman rutin içinde gizlenir. Bir ilişkiyi beslemek, yalnızca kıvılcım yakalamaktan çok daha değerlidir.',
    'Boga':
        'Venüs Boğa burcunda kendi evindedir — bu, en güçlü ve en doğal noktasıdır. Sevgiyi beş duyuyla yaşarsın: dokunma, tat, koku, müzik, güzel mekanlar. Bir öğünü birlikte pişirmek, birinin saçını okşamak ya da güzel bir kokunun arasında oturmak sana derinlemesine bağlantı hissini verebilir.\n\n'
        'İlişkilerde güven ve süreklilik senin için romantizmden önce gelir. Bağlanamayan, gidip gelen ya da güvensizlik yaratan biri ne kadar çekici olursa olsun, uzun vadede seni yorar. Bir kez gerçekten bağlandın mı, o kişiye derin bir sadakatle sarılırsın; bu sadakat senin en büyük güzelliğindir.\n\n'
        'Gölgen, bağlandığın ilişkiyi bitmesi gerektiğinde bile sürdürmek istemektir. Materyal güvenliği sevginin yerini tutamaz ama zaman zaman onları karıştırabilirsin. Kıskançlık ve sahiplenme duyguları da izlenmesi gereken alanlardır. Gerçek güvenlik, başka birinin yanında değil kendi içindedir.',
    'Ikizler':
        'Venüs İkizler burcundayken seni bir insana bağlayan şey, onunla kurduğun zihinsel kimyadan geçer. Sohbet eden, seni güldüren, farklı fikirler sunan, merak uyandıran biri gözünde çok daha çekici görünür. Gece boyunca anlamsız ama sürükleyici bir konuşma, en eksiksiz akşam yemeğinden daha romantik olabilir.\n\n'
        'Sosyal hayatını canlı tutan çevre ilişkilerinde de dinamiksin. İnsanlarla kolayca bağ kurarsın, onları güldürür ve rahatlatırsın. Ama bu yelpazeyi genişleten yapın, derinlik söz konusu olduğunda seni zorlayabilir. Birden fazla alternatifin olduğu dönemlerde karar vermek güçleşir; ilişki sıkışınca dışarıdan uyarı arasana eğilim doğar.\n\n'
        'Gölgen, sıkıldığında bağlılığı azaltmak ya da bir konuşmadan kaçmaktır. Gerçek bağlılık, tüm konuşmaların ilginç olmadığı dönemleri de kapsar. Bir ilişkinin derinliği, tutarlı olmayı öğrenmekle inşa edilir; bu ders Venüs İkizler için en anlamlı büyüme yollarından biridir.',
    'Yengec':
        'Venüs Yengeç burcundayken sevmek, beslemek ve korumak içgüdüseldir. Bir insanı sevdiğinde onun için yemek pişirmek, hastalığında yanında olmak, geçmişini dinlemek ve geleceği için endişelenmek otomatik içgüdülerdir. Bu besleyicilik nadirdir ve çok değerlidir; ama bir bedel de ister.\n\n'
        'Güvenli bir alan olmadan sevgini tam açamazsın. Birinin seni reddedeceğini hissedersen, kendini geri çekersin. Bu savunma mekanizması seni koruduğu kadar gerçek bağlantıdan da uzaklaştırabilir. Evlilik, aile ya da derin bir yuva kurma isteği çoğu zaman içinde yüksek sesle vardır.\n\n'
        'Gölgen, duygusal inişler çıkışlar ve geçmişe yapışmaktır. Eski ilişkilerin izleri uzun süre taşınır; kapanmamış yaralar sevginin akışını kesilebilir. İhanet ya da terk edilme çok derin bir yara açar. Onaylamak, kapamak ve yeniden güvenmek için zaman tanımak gerekiyor — hem kendine hem de birine.',
    'Aslan':
        'Venüs Aslan burcundayken aşk bir sahne gibidir — büyük, renkli ve iz bırakan. Sevdiğin kişiyi hayatının merkezine alırsın; ona övgü yağdırır, özel anlar yaratır ve ilişkinizi diğerlerinden farklı kılmak için çaba harcarsın. Karşılığında ise aynı derecede görünmek, takdir edilmek ve değer görmek istersin.\n\n'
        'Güzellik duygunun güçlüdür: iyi giyinmek, çekici görünmek, sahnesi olan mekanlara çıkmak seni beslir. Partnerini de bu estetik dünyanın bir parçası olarak görürsün. Sadakatın derin ve içtendir; ama önce o bağlılığı hak etmesi gerekir. Kuru ve ilgisiz kalanlar seni soğutur.\n\n'
        'Gölgen, ego çatışmaları ve kırılgan gururdur. Eleştirilince ilişkide kale gibi kapanabilirsin ya da beklentilerin karşılanmadığında dramatik tepkiler verebilirsin. Sevgi, kasıtlı olarak alçakgönüllülük üzerine inşa edildiğinde hem sen hem de partnerın bir arada daha parlarsınız.',
    'Basak':
        'Venüs Başak burcundayken sevgiyi büyük jestlerle değil, küçük ve anlamlı eylemlerle gösterirsin. Birinin yorulduğunu fark etmek ve sessizce çay yapmak, geç dönen partnerine yemek ayırtmak ya da randevusunu hatırlatmak — bunlar senin aşk dilinin cümleleridir. Hizmet etmek, seni küçük düşürmez; tam tersi, seni derinleştirir.\n\n'
        'İlişkide güvenilirlik ve netlik istersin. Ne hissettiğini, ne istediğini, ne düşündüğünü söyleyen biri seni rahatlatır. Belirsiz "belki" ve "göreceğiz" cevapları kaygı yaratır. Sevdiğin kişiyi iyileştirmek, geliştirmek, daha iyi kılmak için çabalarsın; bu niyetin güzeldir ama karşı taraf bunu eleştiri olarak algılayabilir.\n\n'
        'Gölgen, aşırı öz eleştiri ve mükemmel ilişki beklentisidir. Gerçek bir ilişki dağınıktır, çelişkili ve mükemmel olmayan. Bunu kabullenmek, bağlantının gerçekliğine adım atmak demektir. Ayrıca sağlık, beslenme ve beden bakımı da sevgi diliyle iç içedir — kendi bedenini sevmek, başkasını sevmenin temelini güçlendirir.',
    'Terazi':
        'Venüs Terazi burcunda kendi evindedir. İlişki, denge, estetik ve ortaklık, Venüs Terazi için yalnızca istekler değil — ihtiyaçlardır. Partnerlik olmadan yaşamın renkleri soluk kalır. Birinin yanında düşünürsün, birinin bakış açısıyla tamamlanırsın ve ilişkinini güzeliyle beslenirsin.\n\n'
        'Zarif ve diplomatik yapın, ilişkilerde uzlaşı ve uyum sağlamayı kolaylaştırır. İnsanların yanında kendini iyi hissettirirsin; hem sosyal ortamlarda başarılısın hem de bire bir bağlantılarda. Estetik açıdan hassassın: şık insanlar, güzel mekanlar ve uyumlu ortamlar seni aşk hissettiren koşullardır.\n\n'
        'Gölgen, karar verememek ve çatışmadan kaçmaktır. Ortaklığa o kadar çok değer verirsin ki bazen kendi ihtiyaçlarını bastırır, sınırlarını erteleyebilirsin. Gerçek uyum, iki kişinin aynı şeyi düşünmesiyle değil; farklılıkları saygıyla tutmasıyla gelir. Dengeyi aramak güzeldir; ama önce kendi içinde bul.',
    'Akrep':
        'Venüs Akrep burcundayken aşk, bir dönüşüm ritüeli gibidir. Sıradan, yüzeysel ya da tekrarlayan ilişkiler seni tatmin etmez. Karşındakinin en karanlık köşelerine ulaşmak, orada da kabul görmek ve en derin katmanlarını onunla paylaşmak istersin. Bu yoğunluk bir seçim değil; senin aşk biçimindir.\n\n'
        'Güven sana kolay gelmez — ama bir kez gerçekten güvendin mi, karşına sonsuz bir bağlılık sunarsın. İlişkide dürüstlük zorunludur. Yüzeyde kalan konuşmalar, sahte pozitiflik ya da duygusal mesafe seni soğutur. Cinsellik ve yakınlık senin için ruhanî bir boyut taşır; yalnızca fiziksel değil, her düzeyde bütünleşmek istersin.\n\n'
        'Gölgen, kıskançlık, kontrol etme dürtüsü ve incinen gururdur. Birinin sana ihanet ettiğini hissedersen ya da güvenini sarsarsa, derin bir içe kapanma ya da yoğun bir tepkiyle karşılık verebilirsin. Bırakmayı öğrenmek ve affetmeyi — hem kendini hem de ötekini — yaşamın en büyük dönüşümünü yaratır.',
    'Yay':
        'Venüs Yay burcundayken aşk özgürlüksüz büyüyemez. Seninle büyüyen, seninle keşfeden, ufkunu genişleten biri seni büyüler. Seyahat arkadaşı, fikir ortağı, eğlence yoldaşı — bunlar romantik bir partner için en temel niteliklerdir senin gözünde. Macerayı kaybeden ilişki, enerjisini kaybeder.\n\n'
        'Kısıtlanmak seni bunaltır; beklenmedik hazırlığa, anlık değişikliklere ve özgür alanına sahip çıkmaya ihtiyaç duyarsın. Buna karşın partnerinin sana güven vermesini de istersin. Bu dengeyi korumak için açık iletişim — özgürlük isteğini savunmacılık olmadan ifade etmek — hayati önem taşır.\n\n'
        'Gölgen, bağlanma korkusu ya da derinlemesine yatırım yapmaktan kaçmaktır. Yeni başlangıçlar heyecan verir; ama ilişki rutine girdikçe çıkış yollarına bakınırsın. Sadakat, bir anlık heves değil, seçimle pekiştirilmiş bir karardır. Bir ilişkiye gerçekten yatırım yaptığında büyümenin ne kadar güzel olduğunu keşfedeceksin.',
    'Oglak':
        'Venüs Oğlak burcundayken aşk, güven ve sorumluluk üzerine inşa edilir. Romantik jestler seni pek heyecanlandırmaz; bunun yerine taahhüdünü yerine getiren, sözünü tutan, sağlam adımlar atan biri seni çeker. Uzun vadeli bağlılık, anlık tutku ateşlerinden çok daha değerlidir senin gözünde.\n\n'
        'Duygularını ifade etmekte temkinlisin; kolay açılmaz, kolayca aşık olmazsın. Ama bir ilişkiye gerçekten girdiğinde kararlı ve sadık bir partnersin. Statü, başarı ve ortak hedeflere duyulan saygı, ilişkide önem verdiğin değerler arasındadır. Çalışkan, hırslı ve sorumlu biri seni derinden çeker.\n\n'
        'Gölgen, duygusal mesafelilik ve ilişkide iş disiplinini uygulamaktır. Sevgi, bir proje listesi değildir. Planlanmamış anlar, mantıksız romantizm ve işe yaramaz ama eğlenceli şeyler de ilişkiyi besler. Kontrolü bırakmak, seni kırılgan değil; daha gerçek kılar. Gerçek yakınlık buradan doğar.',
    'Kova':
        'Venüs Kova burcundayken aşkta özgünlük zorunludur. Sıradan bir ilişki biçimi, beklenen roller ya da toplumsal beklentiler seni sıkar. Seninle zihnen bağlanan, seni fikir düzeyinde anlayan, bağımsızlığına saygı gösteren biri seni çeker. Dostluk temelli ilişkiler en sağlam zemine sahiptir.\n\n'
        'Yakınlık hissini çabuk kurarsın ama o mesafeyi de koruma eğilimindedir. "Seninle birlikteyim ama bütünce senin değilim" bir paradoks gibi görünebilir; ancak bu senin sevgi dilidir. Partnerinin de kendi alanına, fikirlerine ve kimliğine sahip olmasını istersin. Birleşmek değil; yan yana büyümek seni tatmin eder.\n\n'
        'Gölgen, duygusal mesafelilik ve soğukluk olarak algılanmaktır. İnsanlık için büyük aşkın olabilir ama tek bir insana açılmak zorlanabilir. Yakın ilişkilerde savunmasız olabilmek, soyut sevgiyi somut bir bağa dönüştürür. Risk almak istemiyorsan; bilmek istediğin şeyi asla bilemezsin.',
    'Balik':
        'Venüs Balık burcunda kendi yükselmesindedir — bu, en mistik ve özverili aşk biçiminin taşıyıcısıdır. Sınırlar eriir, kendini karşına tam teslim edersin. Sevdiğin kişinin acısını hisseder, sevincini içinde taşırsın. Bu derin empati seni benzersiz kılar; ama aynı zamanda en savunmasız noktadır.\n\n'
        'Romantizmde idealist ve şaircesin. İlişkinin gerçek olmayan, hatta biraz imkansız olduğu durumlarda bile gönlünü kaptırabilirsin. Hayal edilen aşk bazen gerçek insanların karmaşık dünyasından daha cazip görünür. Müzik, sanat, rüya ve manevi anlayış senin aşk diliyle iç içedir.\n\n'
        'Gölgen, sınır koymakta zorlanmak ve kurtarıcı ilişkiler kurmaktır. Birini kurtarmak isteme güdüsü, seni kendini yitirme tehlikesiyle yüz yüze bırakabilir. Gerçek sevgi özveriye ihtiyaç duyar; ama kendin olmaktan vazgeçmeye değil. Sağlıklı bir bağlılık, var olmanı değil büyümeni sağlar.',
  },

  'Mars': {
    'Koc':
        'Mars Koç burcunda kendi evindedir ve bu, enerjinin en saf, en diri biçiminde tezahür ettiği noktadır. Harekete geçmek, beklemekten çok daha doğal gelir; ilk olmak, lider olmak, sınırları zorlamak için tutuşan bir ateş taşırsın içinde. Bu yerleşim sana sınırsız bir başlangıç gücü verir.\n\n'
        'Motivasyonun anlıktır — bir şeyi istemek ile ona doğru harekete geçmek arasına çok az zaman girer. Bu içgüdüsel hız, krizlerde büyük bir avantajdır. Spor, rekabet, girişimcilik ya da acil yanıt gerektiren alanlarda doğal bir üstünlük taşırsın. Fiziksel egzersiz ve bedensel hareket seni dengeler; hareket etmediğinde sinirlenme eğilimin artar.\n\n'
        'Gölgen, sabırsızlık ve düşünmeden atılma eğilimidir. Uzun soluklu projelerde ya da beklemek zorunda kaldığın durumlarda tahammülsüzlük gösterebilirsin. Öfke hızlı tutuşur ama genellikle çabuk söner. Enerjiyi yönlendirilmiş bir hedefle kullanmak, bu güçlü Marsı hem seni hem de çevreni geliştiren bir kuvvete dönüştürür.',
    'Boga':
        'Mars Boğa burcundayken enerji yavaş ateşlenir ama bir kez tutuşunca söndürülmesi güçtür. Harekete geçmeden önce ölçer, tartar, kararlılığını toplarsın. Bu yavaşlık bir eksiklik değil; sağlam ve kalıcı bir güç biriktirme sürecidir.\n\n'
        'Maddi güvenlik, konfor ve beden kökenli zevkler seni motive eder. Güzel bir ortam, iyi bir yemek, güvenli bir ev — bunlar sadece yaşam kalitesi değil, senin enerji kaynakların. Bir hedefe ulaşmak için saatlerce çalışabilirsin; dayanıklılığın ve ısrarın rakipsizdir. Zanaatkarlar, inşaatçılar, aşçılar ya da maddi dünyayla çalışan herkes bu Marsın gücünden yararlanabilir.\n\n'
        'Gölgen, inatçı direniş ve değişime kapalılıktır. Bir kez karar verdiğinde dışarıdan gelen baskıyla yön değiştirmek neredeyse imkansız hale gelir. Bu sağlamlık zaman zaman katılığa dönüşebilir. Ayrıca baskı biriktiğinde sert bir patlama yaşanabilir; düzenli ventilasyon gereklidir. Öfkeni erken ve dürüstçe ifade etmek bu birikimi önler.',
    'Ikizler':
        'Mars İkizler burcundayken enerji fikirler, sözcükler ve bilgi aracılığıyla akar. Tartışmak, ikna etmek, retorik kullanmak ya da gerçeği hızla birden fazla kaynaktan derlemek senin mücadele biçimindir. Kalemle, sesle ya da zihinsel meşguliyetle daha fazla şey başarırsın.\n\n'
        'Çok işe başlamak ve eşzamanlı projeleri yürütmek seni uyarır. Monoton, tekrar eden eylemler hızla sıkıştırır. Zihnen meşgul olduğunda beyin enerji üretir; boştayken ise sinirlenme ve tahrik edicilik artar. Bu yüzden öğrenme, okuma, yazma ve iletişim senin enerji yönetim sisteminin can damarlarıdır.\n\n'
        'Gölgen, enerjini dağıtmak ve hiçbir şeyi tamamlamamaktır. Söz çok, eylem az olduğunda ya da birden fazla tartışmayı aynı anda yürütmeye çalışırken hiçbirini bitirmediğinde enerji buharlaşır. Bir hedefe odaklanmak, tüm parıltıyı o noktaya yönlendirmek, Mars İkizlerin gerçek gücünü ortaya çıkarır.',
    'Yengec':
        'Mars Yengeç burcundayken enerji duygusal tetikleyicilerle yönetilir. Sevdiklerini korumak, bir yuvayı savunmak ya da duygusal bir adaletsizliği gidermek seni güçlü bir eyleme iter. Bu savunma içgüdüsü, hem en büyük gücün hem de en hassas noktandır.\n\n'
        'Sezgin güçlüdür: bir ortamın duygusal havasını hisseder ve buna göre hareket edersin. Kariyer ve kişisel yaşamda insanların ihtiyaçlarını önceden sezme yeteneğin seni değerli bir lider yapar. Ama bu sezgisellik, duygusal dengesizlikle birleştiğinde savunmacılığa ya da ani geri çekilmelere neden olabilir.\n\n'
        'Gölgen, dolaylı çatışma tarzı ve öfkeyi içe gömmektir. Doğrudan yüzleşmek yerine pasif agresiflik ya da içe kapanma tercih edilebilir. Diğer insanların duygusal yorumlayışın, seni kendi tepkilerinden sorumlu hissettirebilir. Gerçek güç, duygularını kabul edip onları eyleme dönüştürmekten geçer — saklamamak, ya da onları bahane olarak kullanmamak.',
    'Aslan':
        'Mars Aslan burcundayken enerji sahnede yaşar. Takdir görmek, ilham vermek, liderlik etmek ve yaratıcı projeler üretmek seni harekete geçirir. Büyük hedefler için büyük enerji üretirsin; ama o hedeflerin önemli, değerli ve onurlu görünmesi gerekir — küçük ya da sıradan işler için içten gelen motivasyon zor gelir.\n\n'
        'Sahneye çıktığında enerjin bulaşıcıdır. Gruba ilham verir, heyecan ateşlersin. Liderlik senin için doğal bir hal; ama kontrolü ele geçirildiğinde ya da çalışman küçümsendiğinde ani bir ego çöküşü yaşanabilir. Onur ve saygı, enerji seviyeni doğrudan etkiler.\n\n'
        'Gölgen, kibir ve sahiplenme eğilimidir. Bir proje ya da ilişkide başrol senin değilse rahatsızlık duyabilirsin. Rekabetçilik olumlu bir güdü olabilir; ama başkalarının başarısından tehdit hissetmek seni küçültür. Gerçek liderlik, güçlünü dağıtmaktan değil; başkalarını da güçlendirmekten doğar.',
    'Basak':
        'Mars Başak burcundayken eylem pratik, sistemli ve hizmet odaklıdır. Bir problemi çözmek, bir süreci optimize etmek ya da karmaşayı düzenli bir yapıya kavuşturmak seni derinden tatmin eder. Büyük hedefler değil; küçük ve tutarlı adımlar senin gücünün kaynağıdır.\n\n'
        'Kaosun içinde bile yöntemi bulursun. Zor koşullarda bile verimli çalışmaya devam edersin; bu dayanıklılık mesleki hayatta büyük bir avantaj yaratır. Uzmanlık gerektiren alanlarda, sağlık, hizmet ya da teknik çalışmalarda bu Mars kalıbını en iyi biçimde ifade edersin.\n\n'
        'Gölgen, aşırı eleştirisellik ve enerjiyi bitmez kılıcı endişeye yatırmaktır. "Yeterince iyi mi?" sorusu motivasyonu yavaşlatabilir. Mükemmel olmayan bir çalışmayı teslim etmek, hiç bitirememekten iyidir. Bedenini dinlemek de kritik: stres fiziksel olarak sindirim sisteminde kendini gösterebilir. Düzen, rutinler ve küçük öz bakım ritüelleri bu Marsı verimli tutar.',
    'Terazi':
        'Mars Terazi burcundayken güç dışa dönük değil; diplomatik kanallardan akar. Doğrudan çatışmadan kaçınırsın ama bu, pasiflik değildir. Seni harekete geçiren şey, adaletsizliğe tanıklık etmek ya da dengenin bozulmasıdır. O an, sessiz ve zarif ama son derece kararlı bir eylem başlatırsın.\n\n'
        'Ortaklık, müzakere ve ikna etme becerisi bu Marsın en parlak özelliğidir. Bir grubu ortak bir karara yönlendirmek, farklı tarafları bir araya getirmek, çözüm yolları üretmek senin doğal enerji alanındır. Sanatsal alanlarda da bu Mars kendini gösterir: estetik mücadele, yaratıcı üretim için güçlü bir motivasyon sunar.\n\n'
        'Gölgen, karar verememek ve çatışmayı bastırmaktır. "Herkes memnun olsun" kaygısı bazen kendi yönünü belirsiz bırakır. Bastırılan öfke farklı kanallardan çıkabilir; dolaylı pasif dirençle ya da beklenmedik patlamalarla. Kendi haklarını savunmak bir seçenek değil, gereklilik. Diplomatik olmak, kendi görüşünden vazgeçmek anlamına gelmez.',
    'Akrep':
        'Mars Akrep burcunda son derece güçlü bir konumdadır. İrade, odak ve dayanıklılık burada birleşir. Bir hedefe yönelik hareket ettiğinde ne duygusal yorgunluk ne sosyal baskı ne de zaman seni durdurabilir. Bu kararlılık seni hem korkutucu hem de son derece etkileyici yapar.\n\n'
        'Gölgede hareket etmekten çekinmezsin. Stratejik düşünürsün, bilgiyi güç olarak kullanırsın ve gerektiğinde bekleyebilirsin — bu sabır, çoğu kişinin yapamayacağı bir cephe stratejisidir. Araştırma, istihbarat, strateji, psikoloji ve dönüşüm gerektiren alanlarda bu Mars gerçek gücünü gösterir.\n\n'
        'Gölgen, intikam dürtüsü ve kontrole aşırı bağlanmaktır. Birisi sana ihanet ettiğinde ya da sınırını çiğnediğinde derin bir öfke birikir. Bu öfke yönlendirilmezse yıkıcı olabilir. Ayrıca güç ve kontrol konusundaki hassasiyet ilişkilere baskı yaratabilir. Gerçek güç, dışarıyı değil kendinî kontrol etmektir.',
    'Yay':
        'Mars Yay burcundayken enerji büyük vizyonlarla, özgürlük çağrısıyla ve sınır aşma arzusuyla taşar. Risk almak motivasyon verir; güvenli, öngörülü ve tasarlanmış planlar ise seni kısıtlanmış hissettirir. Yeni topraklar — fiziksel ya da zihinsel — keşfetmek, senin eylem dilindir.\n\n'
        'Spor, seyahat, felsefe, din ya da yüksek öğrenim alanlarında ekstra enerji bulursun. İnsanları ilham almaları için zorlayan, zihni genişleten, büyük soruların peşinden giden her şey seni canlandırır. Takım sporları ve açık mekanlarda fiziksel boşalım bu Mars için büyük bir denge sağlar.\n\n'
        'Gölgen, abartme, söz verip teslim etmeme ve detay körlüğüdür. Heyecan dolu bir başlangıcın ardından uygulama kısmında enerji düşer. Tamamlamak, başlamak kadar önemlidir. Hayatta "bitirilmemiş şeylerin ağırlığı" seni yavaşlatmadan önce, büyük vizyonlarını net sınırlı hedeflere bölmeyi öğren.',
    'Oglak':
        'Mars Oğlak burcunda yücelmesindedir ve bu, disiplinli bir gücün en işlevsel biçimidir. Hedeflerine ulaşmak için kısa yollara değil; uzun, güvenli ve kanıtlanmış yollara güvenirsin. Kariyer, başarı ve kalıcı sonuçlar bu Marsı her sabah uyandıran yakıttır.\n\n'
        'Sabırlısın, stratejiksin ve başladığını bitirirsin. Ani kararlar vermez; uzun vadeli sonuçlara odaklanırsın. İş hayatında ya da rekabetçi alanlarda bu özellik anlaşılır bir üstünlük sağlar. Baskı altında çalışmak seni korkutmaz; tam tersine, zor koşullar performansını artırır.\n\n'
        'Gölgen, ısrarcı bir iş odağının yaşamın diğer alanlara nüfuz etmesidir. Eğlence, dinlenme ya da "anlamsız" zaman sana israf gibi görünebilir. Ama beden ve ruh, üretkenlikten beslendiği gibi; oyundan da beslenir. Ayrıca katı disiplin, spontanliği öldürebilir. Kontrol etmeyi bıraktığın anlar, seni daha insan yapar.',
    'Kova':
        'Mars Kova burcundayken enerji, bireysel hedeflerden çok kolektif bir amaç için harekete geçer. Toplumu, grubu ya da bir fikri ilerletmek için çalışmak seni derin biçimde motive eder. Kişisel çıkar kaygısından çok; daha büyük bir hedefe hizmet etmenin tatmini peşindesin.\n\n'
        'Bazen beklenmedik biçimlerde, bazen de toplumun kabul görmediği sıra dışı yollarla harekete geçersin. Bu özgünlük seni lider düşünür, sosyal aktivist ya da yenilikçi bir figür yapar. Teknoloji, sosyal sistemler ya da kitlesel iletişim, bu Marsın enerji kanallarıdır.\n\n'
        'Gölgen, isyana kolaylıkla kayabilmek ve işbirliğini zorlaştırmaktır. "Ben farklı hareket ederim" tutumu bazen otoriteyle gereksiz çatışmalara yol açabilir. Devrim bazen kuralları yıkmakla değil; onları dönüştürmekle gerçekleşir. Bireysel özerklik ile kolektif sorumluluk arasındaki dengeyi bulmak, bu Marsın gerçek gücünü açar.',
    'Balik':
        'Mars Balık burcundayken enerji bir nehir gibi akar — belirlenmiş bir yataktan değil, en az dirençli yoldan. Doğrudan çatışma yerine dolaylı yollar, kati hedefler yerine sezgiyle hareket etmek senin eylem tarzındır. Bu belirsizlik zayıflık değil; farklı bir zekadır.\n\n'
        'Sanat, müzik, dans, şiir ya da manevi pratikler bu Marsın en güçlü ifade alanlarıdır. Yaratırken ya da adanmış bir amaç için çalışırken farkında olmadan sonsuz bir enerji ve odak bulursun. Teslimiyet ve empati, eyleminde kayda değer bir iz bırakır — insanlar seni zorla değil, ilhamla takip eder.\n\n'
        'Gölgen, sınır koymakta zorlanmak ve kurban rolüne sürüklenmektir. Başkalarının enerjisini ya da taleplerini çok içine alırsın ve bu seni tüketebilir. Öfke doğrudan değil; içe çekilme, kaçınma ya da psikosomatik olarak kendini gösterebilir. Kendi ihtiyaçlarını ve sınırlarını tanımak, bu Marsı verimli kılan temel adımdır.',
  },

  'Jupiter': {
    'Koc':
        'Jüpiter Koç burcundayken büyüme, cesaret ve ilk adımlar aracılığıyla gelir. Beklemek, hazırlanmak, izin almak yerine harekete geçmek sana kapıları açar. Bu yerleşim sana spontane girişimcilik, liderlik için doğal bir cesaret ve yeni başlangıçlara karşı neredeyse çocuksu bir açık yüreklilik verir.\n\n'
        'Risk aldığında şansın yüksektir. Bu, körü körüne atlamak anlamında değil; iç güdülerine güvenerek aşina olmadığın alanlara adım atmak demektir. Spor, girişimcilik, askeri ya da öncü alanlarda bu Jüpiter özellikle parlak bir ışık yakar. Yeni bir şehir, yeni bir iş, yeni bir disiplin — başlangıçlar bereket getirir.\n\n'
        'Öğreneceğin bilgelik, sabrın kendisi bir eylemdir. Ateşli coşku ile uzun vadeli inşa etme isteği arasındaki köprüyü kurduğunda, başladıklarını da tamamlayan biri olursun. O tamamlama anı, seni yalnızca başlangıçta değil; varışta da ödüllendiren Jüpiterin hediyesidir.',
    'Boga':
        'Jüpiter Boğa burcundayken bolluk, sabır ve topraklılık aracılığıyla gelir. Büyüme seninle birlikte ağır ilerler ama kökleri derine uzanır. Maddi dünyada gerçek zenginlik, kaliteli ilişkiler ve güvenli bir yuva — bu Jüpiterin sana işaret ettiği bereketlerdir.\n\n'
        'Yatırım, birikim ve uzun vadeli planlama alanlarında özellikle şanslısın. Toprakla bağlantılı işler, gıda, finans, sanat ya da el sanatları bu Jüpiterin etki alanındadır. Güzelliğe ve zevk alınan şeylere yatırım yapmak, senin için sadece harcama değil; bir büyüme stratejisidir.\n\n'
        'Öğreneceğin bilgelik, güvenliğin maddi güvenden fazlası olduğudur. Gerçek bolluk içinden başlar; ne biriktiğinden değil, ne hissettiğinden. Zaman zaman konfor zonunu zorlayan fırsatlara kapı açmak, seni beklenmedik ama kalıcı bir büyümeyle ödüllendirir.',
    'Ikizler':
        'Jüpiter İkizler burcundayken büyüme bilgi, iletişim ve bağlantılar aracılığıyla gelir. Ne kadar çok öğrenirsen, ne kadar çok paylaşırsen — o kadar çok kapı açılır. Bu Jüpiter sana engin bir entelektüel ağ, meraktan doğan şans ve çoklu alanlarda yetkinlik kazandırır.\n\n'
        'Yazarlık, gazetecilik, yayıncılık, eğitim, dil öğrenimi ya da dijital iletişim bu Jüpiterin en verimli alanlarıdır. Bir dili geliştirmek, yeni bir beceri öğrenmek ya da bir ağa katılmak beklenmedik kapılar açar. Seyahat ederken ya da farklı kültürlerle temas kurarken büyük fikirler zihni aydınlatır.\n\n'
        'Öğreneceğin bilgelik, derinliğin genişlikten daha büyük değer üretebileceğidir. Çok şeyi yüzeysel bilmek yerine, birkaç şeyi gerçekten ustalaşmış bilmek hem daha büyük bir güven hem de daha kalıcı bir otorite sağlar. Uzmanlık, bu Jüpiterin en yüksek bereketini açar.',
    'Yengec':
        'Jüpiter Yengeç burcunda yücelmesindedir — bu, olağanüstü şefkat, duygusal zeka ve besleyici enerjinin en büyük biçimde genişlediği yerleşimdir. İnsanlara ev hissi vermek, onları karşılamak ve anlayışla sarmalamak senin büyüme yolundaki en güçlü hediyelerinden biridir.\n\n'
        'Aile, yuva, geçmişe verilen onur ve duygusal bağlar bu Jüpiterin güç alanını oluşturur. Psikoloji, sosyal hizmet, ebeveynlik, terapi, beslenme ya da ev tasarımı çalışmaları engin bereket potansiyeli taşır. Geçmişindeki bilgeliği bugüne taşımak da büyük bir güç kaynağıdır.\n\n'
        'Öğreneceğin bilgelik, sevmenin sınır gerektirmediği ama onlarla daha sağlıklı geliştiğidir. Herkesi korumak, kollamak, beslemek için hissettiğin dürtü güçlüdür; ama kendi ihtiyaçlarını da o denklemin içine koymak, hem seni hem yardım ettiklerini daha iyi kılar.',
    'Aslan':
        'Jüpiter Aslan burcundayken yaratıcılık ve özgüven, refahın ana kapısıdır. Görünür olmak, sahneye çıkmak, kalbinden gelen ifadeyi dünyayla paylaşmak bu Jüpiterin sana işaret ettiği büyüme yoludur. İlham vermek hem senin şansını hem de çevrenden geri dönen iyiliği artırır.\n\n'
        'Sanat, performans, eğitim, liderlik ve çocuklarla çalışma alanları bu Jüpiterin bereketli olduğu alanlardır. Sahne almak, teklif yapmak, liderlik pozisyonu üstlenmek — içinin "ben buna hazır değilim" dediği aylarda bile — seni olası en büyük büyümenin eşiğine getirdiği anlardır.\n\n'
        'Öğreneceğin bilgelik, cömertliktir. Sadece almak değil, vermek de bu Jüpiterin kanalındadır. Yeteneklerini, ışığını ve ilhamını paylaşmak seni büküp kırmaz; aksine daha da parlaklaştırır. Gerçek bolluk, sahnede tek başına değil; ışığı başkalarına da yaydığında büyür.',
    'Basak':
        'Jüpiter Başak burcundayken büyüme, hizmet ve ustalık aracılığıyla gelir. Bir şeyi gerçekten iyi yapmayı öğrenmek, işini titizlikle yapmak ve başkalarının hayatını pratik biçimde iyileştirmek bu Jüpiterin en bereketli yollarıdır.\n\n'
        'Sağlık, beslenme, tıp, analiz, mühendislik, araştırma ya da hizmet odaklı iş alanlarında uzmanlaşmak özellikle ödüllendirici olur. Bir sistemi daha verimli hale getirmek, bir süreci optimize etmek ya da karmaşayı düzene kavuşturmak büyük tatmin sağlar. Gündelik alışkanlıklar ve rutinler bile gelişimi hızlandırır.\n\n'
        'Öğreneceğin bilgelik, mükemmeliyetçiliğin zaman zaman büyümenin önünde durduğudur. "Yeterince iyi değil" hissi, harika fırsatları kaçırtabilir. Jüpiter burada şunu söyler: başlamak, mükemmeli beklemekten daha çok büyüme sağlar. Cömert olmak — hem kendine hem hizmet ettiğin kişilere — bu Jüpiterin gerçek bereketini açar.',
    'Terazi':
        'Jüpiter Terazi burcundayken büyüme, ilişkiler ve ortaklıklar aracılığıyla gelir. Doğru insanlarla doğru zamanda buluşmak, seni hem maddi hem manevi anlamda büyütür. Evlilik, iş ortaklığı, hukuki anlaşmalar ya da derin dostluklar bu Jüpiterin özellikle verimli alanlarıdır.\n\n'
        'Estetik, hukuk, müzik, diplomasi ve güzellik alanlarında özel bir şans taşıyabilirsin. Adil davranmak ve herkese eşit fırsatlar sağlamaya çalışmak sana başkalarının desteğini getirirken karman da olumlu döner. Anlaşmazlıkları barışçıl biçimde çözmek hem ilişkilerine hem de dış dünyaya bereket katar.\n\n'
        'Öğreneceğin bilgelik, kendi görüşünden emin olmaktır. "Her iki taraf da haklı olabilir" tutumu özen gerektirse de zaman zaman kararlılık ve netlik, bereketin önündeki son engelin aşılmasını sağlar. Adil olmak, kendi yönünden vazgeçmek değildir; kendi yerini bulmak, başkasına da yer açmaktır.',
    'Akrep':
        'Jüpiter Akrep burcundayken büyüme, derin sular aracılığıyla gelir. Yüzeysel olmayan, köklü bir dönüşüm geçiren, gizemli ve yoğun alanlara dalınca bu Jüpiter genişler. Psikoloji, miras, ortak kaynaklar, araştırma ya da spiritüel pratikler bu Jüpiterin bereketli alanlarıdır.\n\n'
        'Gizli bilgiye ya da başkalarının göremediği gerçeklere ulaşmak, seni hem güçlü hem de yönlendirici bir konuma getirebilir. Finansal kaynaklar, miras, sigorta ya da diğer insanların kaynaklarını yönetmek konularında beklenmedik fırsatlar açılabilir. Yeniden doğuş metaforu bu Jüpiter için mecazi değil; gerçektir.\n\n'
        'Öğreneceğin bilgelik, gücü etik biçimde kullanmaktır. Bu Jüpiter sana büyük bir araştırma ve etkileme kapasitesi verir. Ama bu güç, başkalarına hizmet için kullanıldığında hem daha mutlu bir hayata hem de daha kalıcı bir başarıya dönüşür. Dönüşüm içten başlar ve dışarıya doğru genişler.',
    'Yay':
        'Jüpiter Yay burcunda kendi evindedir — astrolojide en güçlü ve en saf haliyle tezahür ettiği noktadır. Felsefe, seyahat, yüksek öğrenim, din ve yabancı kültürler bu Jüpiterin doğal bereketlerinin kapısıdır. Ufku ne kadar genişletirsen hayat da o kadar genişler.\n\n'
        'İnanç ve anlam arayışı seni motive eder; bir vizyona sahip olmak — ne kadar büyük olursa olsun — seni hayatta tutar. Uzak topraklara yolculuk, farklı bir kültürde çalışmak ya da akademik bir araştırma sürecine girmek bu Jüpiter için bereketle dolu dönemler açar. Öğretmek ve yaymak da Jüpiterin bu biçiminin doğal kanallarıdır.\n\n'
        'Öğreneceğin bilgelik, özgürlüğün sorumsuzluk gerektirmediğidir. Büyük vizyonlar; sürekli kaçmayı değil, kalmayı ve inşa etmeyi de içerir. En kalıcı büyüme, bir yere ait hissedip oradan dünyaya açılmakla gerçekleşir.',
    'Oglak':
        'Jüpiter Oğlak burcundayken büyüme, disiplin ve uzun soluklu kariyer yatırımları aracılığıyla gelir. Kısa vadeli kazançlar değil; yıllarca emek verilen, taştan taşa inşa edilen başarılar bu Jüpiterin bereketini açar. Saygınlık, otorite ve kurumsal yapılar bu Jüpiterin etki alanındadır.\n\n'
        'Devlet kurumları, büyük şirketler, geleneksel meslekler (hukuk, tıp, mühendislik, mimarlık) ve yönetim pozisyonlarında özel bir şans taşıyabilirsin. Sorumluluk almak seni büyütür; çekinen değil yüklenen biri olduğunda kapılar açılır. Erken yaşlarda belki yavaş; ama zamanla çok daha sağlam bir başarıya ulaşırsın.\n\n'
        'Öğreneceğin bilgelik, esnekliğin verimliliği artırdığıdır. Katı yapılar bazen büyümenin önüne geçebilir. İnovasyon ve yaratıcılık, disiplinle çelişmez; onu tamamlar. Jüpiter burada şunu fısıldar: zirve, sadece doğru adımla değil; bazen de doğru adımı bırakan bir esneklikle bulunur.',
    'Kova':
        'Jüpiter Kova burcundayken büyüme, topluluk, ağlar ve kolektif vizyon aracılığıyla gelir. Büyük veri ve büyük bilgeliği birleştirebilirsin; geleceği görmek ve onu şekillendirmek için zemin hazırsın. Teknoloji, sosyal hareketler, aktivizm ve yenilikçi düşünce bu Jüpiterin bereketli alanlarıdır.\n\n'
        'İnsanları biraraya getirmek, aynı vizyonu paylaşan grupları koordine etmek ya da bir topluluğun sesini yükseltmek seni güçlü kılar. Sıra dışı, alışılmamış ya da tartışmalı ama ileri görüşlü fikirlere yatırım yapmak, bu Jüpiter için özellikle ödüllendirici olabilir. Şebeke ekonomisi, dijital platformlar ve kolektif akıl bu Jüpiterin doğal alanlarıdır.\n\n'
        'Öğreneceğin bilgelik, devrimci fikirlerin kalıcı değişimi yalnızca yıkarak değil; inşa ederek yarattığıdır. İnsanlara inanmak önemli; ama onları gerçekten görüp duymak, soyut sevgiden önce gelir. Kökleri insanlara uzanan bir vizyon, seni gerçek bir öncüye dönüştürür.',
    'Balik':
        'Jüpiter Balık burcunda kendi evindedir — şefkat, yaratıcılık ve ruhaniyet alanında en derin bereketini açan konumdur. Yaratıcılık, empati ve manevi gelişim yoluyla büyümek sana en doğal yol gibi hissettirdiği için, çoğu zaman bu büyümenin ne kadar olağanüstü olduğunu fark etmezsin.\n\n'
        'Sanat, müzik, sinema, dans, şiir, terapi, spiritüel öğreti ya da insancıl çalışmalar bu Jüpiterin en verimli alanlarıdır. Büyük bir empatiyle insanları anlama ve onlara yol gösterme kapasiten, zaman içinde seni beklenmedik bir rehbere dönüştürebilir. Hayalin büyüklüğünden korkma; bu Jüpiter visyonun gerçek olabilmesini destekliyor.\n\n'
        'Öğreneceğin bilgelik, verimliliğin içinden de ruhanilik akabileceğidir. Her şeyi bırakmak ya da kaçmak gerekmez; sezgiyi gündelik hayata entegre etmek, gerçek anlamda bolluk yaratır. Sınırlarını güçlendirmek, ruhani büyümenin önünde değil; onun için zemin açar.',
  },

  'Saturn': {
    'Koc':
        'Satürn Koç burcundayken hayat sana sabır ve öz disiplini öğretmek için gelir. Aceleci kararlar, tamamlanmamış başlangıçlar ve ani dürtüler sonrasında yaşanan hayal kırıklıkları, bu Satürnün ana derslerini sunar. Her atılımın ardından durup bakmayı öğrenmek, seni daha güçlü kılar.\n\n'
        'Liderlik ve öncülük içinde taşıdığın ama zamanla ve çabayla inşa edilmesini gerektiren bir kapasitedir. Hayatta en sert öğrendiğin şeyler, hareket etmeden önce düşünmenin değeridir. Sabırsızlığın maliyetiyle yüzleşmek acı verici olabilir ama bu yüzleşmeler seni daha gerçekçi ve güvenilir bir lider yapar.\n\n'
        'Bu Satürnü aşan insanlar, zamanla olağanüstü bir sabır ve stratejik hareket yeteneği geliştirirler. İlk adım kadar ikinci, üçüncü adım da önem taşır. Başlangıcın heyecanı kadar bitmişliğin tatmini de değerlidir. Bu denge, senin en büyük olgunluk armağanındır.',
    'Boga':
        'Satürn Boğa burcundayken hayat sana maddi güvenliği hak etmenin yolunu öğretir. Kısayollar işe yaramaz; gerçek güvenlik, sabırla biriktirilen emek ve tutumlu kararlar aracılığıyla gelir. Maddi sıkışıklık dönemleri, seni hem daha gerçekçi hem de daha minnettarca bir insan haline getirir.\n\n'
        'Güzellik ve konfor için duyduğun ihtiyaç gerçektir; ama Satürn burada, mevcut yaşamını değersiz kılmadan nasıl büyüyebileceğini sormaya iter. Sahip olduklarını değerli görmek ile daha fazlasını istemek arasındaki denge, bu Satürnün en ince dersidir. Gerçek zenginlik içsel bir güvenlik hissiyatından başlar.\n\n'
        'Zamanla bu Satürn sana olağanüstü bir finansal disiplin ve uzun vadeli güvenlik inşa etme kapasitesi kazandırır. Kendi varlıklarını yönetmek, tasarrufu alışkanlık haline getirmek ve somut adımlarla hedeflere ulaşmak — bunlar bu Satürnün olgunluk meyveleridir.',
    'Ikizler':
        'Satürn İkizler burcundayken hayat sana odaklanmayı ve derinleşmeyi öğretir. Çok şey bilmek yerine bir şeyi gerçekten bilmek, yüzeysel bağlantılar kurmak yerine az ama anlamlı ilişkiler geliştirmek — bu Satürnün temel dersleridir.\n\n'
        'İletişimde ve entelektüel ifadede erken dönemlerde özgüven sorunu ya da öğrenme güçlükleri yaşanabilir. Söylediğin şey gerçekten önemli mi, iyi ifade ettim mi gibi sorular seni sessize alabilir. Ama bu titizlik zamanla güçlü bir yazı ya da konuşma ustalığına dönüşür. Sözcüklerini seçerek kullanan insanlar, çok konuşanlardan daha fazla etki bırakır.\n\n'
        'Bu Satürnü taşıyan insanlar, hayatlarının belirli bir döneminde düşüncelerini disiplinli bir şekilde ifade etmeyi öğrendiklerinde inanılmaz bir otorite ve netliğe ulaşırlar. Bir alanda uzman olmak, bilgi çevresini genişletmek yerine derinleştirmek — bu olgunluk sana yazarlık, uzmanlık ya da eğitim alanında kalıcı bir iz bırakma kapasitesi verir.',
    'Yengec':
        'Satürn Yengeç burcundayken hayat sana duygusal bağımsızlık ve kendi güvenliğini içinden üretmeyi öğretir. Erken yaşlarda anne, baba ya da aileyle ilgili zorluklar; ya da güvende hissetmenin zor geldiği dönemler bu Satürnün habercileridir. Dışarıdan onay beklemek sürdürülebilir bir kaynak değildir.\n\n'
        'Koruyuculuk içgüdün güçlüdür ama bu bazen başkalarını değil; öncelikle kendi kırılgan noktalarını koruma anlamına gelebilir. Savunmacılık ve içe kapanma gölge tepkileridir. Gerçek güvenlik, dışarıdan sağlananla değil; kendi içinden ürettiğin bir kararlılıkla inşa edilir.\n\n'
        'Bu Satürnü aşanlar, zamanla hem kendileri hem de başkaları için güvenli bir liman olma kapasitesi geliştirirler. Geçmişin duygusal ağırlığını aşmak ve geriye dönmek yerine ileriye bakmayı seçmek, bu Satürnün olgunluk noktasıdır. O noktaya ulaştığında yaydığın güven hissi, çevrendeki herkese yayılır.',
    'Aslan':
        'Satürn Aslan burcundayken hayat sana dışarıdan onay ihtiyacı olmaksızın var olabilmeyi öğretir. Yaratıcı ifade, liderlik ya da sahnede görünme konularında erken dönemlerde blokaj, onaylanmama korkusu ya da özgüven sorunu yaşanabilir. Bu blokaj gerçek yeteneksizlikten değil, şartlanmışlıklardan gelir.\n\n'
        'İnsanların seni görmesi, takdir etmesi ve onurlandırması için duyduğun ihtiyaç gerçektir. Ama Satürn burada şunu öğretir: bu ihtiyacı başkasından beklediğinde asla doyurulamaz. Gerçek özgüven, başkalarının alkışından değil; kendi zihninin onayından beslenir. Bir eseri, bir kararı ya da bir yolu salt seni mutlu ettiği için seçmek — bu olgunluğun ilk adımıdır.\n\n'
        'Bu Satürnü aşanlar, zamanla hem kendilerine hem de başkalarına ilham veren özgün liderler olurlar. Sahneye çıkmak, liderlik üstlenmek ve görünür olmak artık onay aramak değil; bir sorumluluk ve sevinç hissiyle yapılan seçimler haline gelir.',
    'Basak':
        'Satürn Başak burcundayken hayat sana mükemmeliyetçilikle barışmayı öğretir. "Yeterince iyi değilim", "daha çok çalışmalıyım" ya da "her şey tam olmalı" gibi iç sesler bu Satürnün klasik gölgeleridir. Öz eleştiri bir yol haritası değil; bir kafes haline gelebilir.\n\n'
        'Beden sağlığı ve gündelik rutinler bu Satürnün özel alanlarından biridir. Stres, fiziksel olarak sindirim sistemi, bağışıklık ya da kronik küçük rahatsızlıklar biçiminde kendini gösterebilir. Beden sana mesajlar gönderir; bu mesajları dinlemek hem sağlığını hem de verimliliğini artırır.\n\n'
        'Bu Satürnü aşanlar, zamanla hem kendileri hem de diğerleri için inanılmaz değer yaratan, sağlam standartlara sahip ama öz şefkati ihmal etmeyen uzmanlar hâline gelirler. Analitik zeka, disipline edilmiş alışkanlıklar ve hizmet etme arzusu — tüm bunlar bir arada gerçek bir usta ortaya çıkarır.',
    'Terazi':
        'Satürn Terazi burcundayken hayat sana ilişkilerde gerçek denge ve sorumluluk almayı öğretir. Erken dönemlerde ilişkiler zor gelir; bağlanmak, sınır çizmek ya da kendi ihtiyaçlarını diğerleriyle denge içinde tutmak zorlu süreçler olabilir. Adaleti ararken ne zaman kendinden ödün verdiğini, ne zaman haklarını koruduğunu anlamak ise temel dersindir.\n\n'
        'Kararlılık ve taraf tutmak bu Satürnün zor alanlarıdır. "Her iki taraf da haklı görünüyor" analizi seni hareketsiz bırakabilir. Ama gerçek bir adalet anlayışı, zaman zaman kendi tutumunu net biçimde ortaya koymayı da gerektirir. Kararsızlık bir şeyi adil kılmaz; yalnızca sonucu erteler.\n\n'
        'Bu Satürnü aşanlar, zamanla toplumun en güvenilir arabulucuları, adalet savunucuları ve denge arayıcıları hâline gelirler. Kendi haklarını bilinçli şekilde savunurken başkasının haklarına da gerçek anlamda saygı gösterebilmek — bu denge, bu Satürnün en yüksek olgunluk meyvesidir.',
    'Akrep':
        'Satürn Akrep burcundayken hayat sana güveni inşa etmeyi ve kontrolü bırakmayı öğretir. Güç, para, cinsellik ya da üzerinde kontrol duygusuyla ilgili derin korkular ve sınamalar bu Satürnün alanındadır. İhanet ya da kaybetme deneyimleri, o derin güvensizliği yüzeye çıkarır.\n\n'
        'Birini ya da bir durumu kontrol etme dürtüsü, gerçekte kontrol edemeyeceğinden duyulan korkunun bir yansımasıdır. Güven vermek, açılmak ve kırılgan olmaya izin vermek bu Satürnün en zor ama en dönüştürücü dersleridir. Oyunlar oynamak ya da bilgiyi güç olarak kullanmak kısa vadede işe yarıyor gibi görünse de uzun vadede sizi tecrit eder.\n\n'
        'Bu Satürnü aşanlar, zamanla derin ve gerçek bağlar kurabilen, hem kendi gölgelerini hem de başkalarının gölgelerini saklamadan tutabilen güvenilir insanlara dönüşürler. Dönüşüm onlar için artık bir korku değil; yaşamın kazandırdığı en derin bilgeliktir.',
    'Yay':
        'Satürn Yay burcundayken hayat sana gerçek inancı ve anlam arayışını bulmayı öğretir. Hangi değerlerin gerçekten senin olduğunu anlamak; dogmadan bağımsız ama köklü bir dünya görüşü oluşturmak bu Satürnün temel meselesidir. Erken dönemlerde inanç konusunda katı bir yapıda büyümek ya da tam tersi anlamsızlık hissi yaşamak olası gölgelerdir.\n\n'
        'Özgürlük ihtiyacının kısıtlamalar içinde bile var olabileceğini kavramak, bu Satürn için kritik bir dönüm noktasıdır. Yabancı kültürlere, felsefeye ya da yüksek eğitime açılmak zaman zaman ertelenebilir ya da engellenenebilir. Ama bu engellemeler bir red değil; zamanlamanın uyarısıdır. Doğru zemin hazırlandığında büyüme çarpıcı olur.\n\n'
        'Bu Satürnü aşanlar, zamanla olağanüstü bir bilgelik ve öğretme kapasitesi geliştirir. Kendi deneyimlerinden çıkardıkları dersler, başkaları için derinden anlamlı rehberler hâline gelir. Gerçek inanç, hazır bir dogmadan değil; kişisel bir yolculuktan doğar.',
    'Oglak':
        'Satürn Oğlak burcunda kendi evindedir ve bu, doğal bir otorite ve dayanıklılık enerjisi yaratır. Kariyer ve sorumluluklar hayatın erken dönemlerinden itibaren ağır gelir; belki çok erken büyümek zorundasındır. Bu ağırlık, zamanla olağanüstü bir olgunluk ve sağlamlık kazandırır.\n\n'
        'Başarı sana elde edilmeden gelmez; ama elde edildiğinde kalıcıdır. Zorlukla inşa edilen şeyler en sağlam temellere oturur. Bu Satürnün insanları, sıradan yaşam koşullarında değil; gerçek baskı ve sorumluluk altında en parlak performanslarını gösterirler.\n\n'
        'Gölgen, her şeyi kontrol altına alma ihtiyacı ve sertliğin kibriyet haline gelmesidir. "Ben her şeyin üstesinden kendi başıma gelirim" tutumu, gerçek yardımı reddetmeyi getirebilir. Zayıflığın da bir form olduğunu ve yardım istemenin güçsüzlük değil, stratejik bir seçim olduğunu anlamak bu Satürnün en değerli olgunluk dersidir.',
    'Kova':
        'Satürn Kova burcundayken hayat sana birey ile toplum arasındaki dengeyi öğretir. Özgün olmak ile ait olmak arasındaki gerilim bu Satürnün ana sahnesidir. Erken dönemlerde farklı hissetmek, gruba uymakta zorlanmak ya da grupla çatışmak olası deneyimlerdir.\n\n'
        'Sistemi sorgulamak yerindedir; ama her sistemi reddetmek ise kendi içinde bir başka katılık yaratır. Gerçek özgürlük, kuralları inkâr etmekten değil; hangisinin anlam taşıdığını seçebilmekten gelir. Toplumun beklentilerini değil; kendi değerlerini temel alarak yaşamak bu Satürnün olgunluk yolculuğudur.\n\n'
        'Bu Satürnü aşanlar, zamanla hem bireyselliğini tam anlamıyla yaşayan hem de kolektif sorumluluğunu derin biçimde taşıyan insanlara dönüşürler. Topluma katkı, sisteme kölelik değil; bilinçli bir seçimdir. O bilinçlilik, seni gerçek bir Kova öncüsüne dönüştürür.',
    'Balik':
        'Satürn Balık burcundayken hayat sana sınır çizmeyi ve gerçekçiliği öğretir. Sezginin, hayal gücünün ve şefkatin güçlü olduğu bir doğanla dünyada pratik köprüler inşa etmek bu Satürnün temel meselesidir. Kaçmak, ertelemek ya da "her şey kendiliğinden yoluna girer" tutumu işe yaramaz; dünya somut eylemler ister.\n\n'
        'Fedakarlık içgüdün gerçektir; ama sınır yoksa kendini yitirme tehlikesi de gerçektir. Sürekli başkasının ihtiyaçlarına odaklanmak, bir süre sonra kim olduğunu kaybetmene yol açabilir. Bu Satürn kısıtlamayı değil; saydamlığı öğretir: neyin gerçek neyin hayal olduğunu net görmek.\n\n'
        'Bu Satürnü aşanlar, zamanla olağanüstü sezgilerini yapısal bir forma dökmüş, hem ruhsal hem maddi dünyada gerçekten köklü insanlara dönüşürler. Rüya ile gerçeği birleştiren köprüler kurarlar ve bu köprüler hem kendilerine hem de başka bir sürü insana yol olur.',
  },

  'Uranus': {
    'Koc':
        'Uranüs Koç burcundayken yenilik bir kıvılcım gibi sıfır noktasından başlar. Sistemleri, yapıları ve eski düzeni aniden paramparça eden bir enerji taşırsın — bu kişisel devrim güdüsü hem bireysel hem toplumsal değişimin fitilini ateşleyebilir. Beklenmedik hamlelerin ve ani başlangıçların senin dönüşüm dilidir.\n\n'
        'Bu nesil yerleşimi sana hem kişisel hem kolektif bir miras bırakır: bağımsızlık, öncülük ve cesaret. Toplu olarak deneyimlenen yenilikler, bireyin kendi hayatında da ani kırılmalar olarak yankılanır. Haritanda Uranüs\'ün hangi evde durduğu, bu kırılmaların nerede gerçekleştiğini gösterir.\n\n'
        'Sağlıklı Uranüs Koç enerjisi, yıkmak için değil; daha iyi bir şey inşa etmek için kullanılan yaratıcı isyana dönüşür. Sabırsızlığını yönlendirdiğinde, gerçek bir öncü olursun.',
    'Boga':
        'Uranüs Boğa burcundayken en beklenmedik değişimler en sağlam gördüğün zeminlerde gerçekleşir: para sistemleri, toprak, beden ve maddi değerler. Bu nesil yerleşimi finansal devrimler, doğayla yeniden bağlantı ve beden algısında köklü dönüşümleri simgeler.\n\n'
        'Bireysel hayatında bu, alışkanlıklarda ani kırılmalar, gelir kaynaklarında beklenmedik geçişler ya da değer yargılarının köklü biçimde yeniden şekillenmesi anlamına gelebilir. "Güvenli" sandığın şeylerin nasıl dönüşebileceğini görürsün — bu zorlayıcı ama özgürleştiricidir.\n\n'
        'Uranüs Boğa\'nın armağanı şudur: değişimi direnerek değil, topraklı bir esneklikle karşıladığında, yıkılan her eski yapının yerine çok daha sağlam bir şey gelir.',
    'Ikizler':
        'Uranüs İkizler burcundayken iletişim, bilgi ve zihinsel hareket alanında köklü dönüşümler yaşanır. Bu nesil Internet öncesini, dijital devrimi ya da bilginin sınırsız yayıldığı çağı deneyimleyen kuşakla örtüşür. Nasıl düşündüğünü, nasıl konuştuğunu ve kiminle bağlandığını temelden değiştiren olaylar bu enerjinin alameti farikasıdır.\n\n'
        'Bireysel olarak zihin ani sıçramalar yapar; bir yerde takılıp kalındığında beklenmedik bir fikir ya da bağlantı tıkanan kapıyı aniden açar. Alışılmamış düşünme biçimleri, farklı bakış açıları ve sıra dışı çözümler senin doğal alanındır.\n\n'
        'Bu enerjinin en parlak meyvesi, bilgiyi özgürce dolaştırmak ve başkalarının henüz görmediği bağlantıları işaret etmektir.',
    'Yengec':
        'Uranüs Yengeç burcundayken aile yapıları, yuva kavramı ve duygusal güvenliğin tanımı köklü biçimde sorgulanır. Bu nesil, geleneksel aile modellerinin değiştiğini, "ev"in yeni tanımlar kazandığını deneyimler. Alışılmış aidiyet kalıpları kırılır ve her birey kendi güvenlik kaynağını yeniden tanımlamak zorunda kalır.\n\n'
        'Bireysel olarak bu yerleşim ani taşınmalar, beklenmedik aile dinamikleri ya da duygusal güvenliğin geleneksel olmayan biçimlerde aranması anlamına gelebilir. Duygusal devrimler sessizce ve içeriden yaşanır.\n\n'
        'Bu enerjinin öğretisi şudur: gerçek güvenlik, dışarıdaki koşullar ne olursa olsun içinden üretilen bir şeydir. O iç istikrarı bulduğunda, ev nerede olursa olsun güvendesin.',
    'Aslan':
        'Uranüs Aslan burcundayken yaratıcılık, bireysel ifade ve egonun tanımı devrim geçirir. Bu nesil, geleneksel otoritenin sorgulandığı dönemlerde doğar ve bireysel özgünlüğü kolektif normlara karşı yükseltir. Sahneye çıkmanın, liderliğin ve öz ifadenin tamamen yeni biçimleri ortaya çıkar.\n\n'
        'Bireysel hayatında bu, yaratıcı alanda ani ilham patlamaları, liderlik tarzında beklenmedik değişimler ya da "ben kimim?" sorusunun köklü biçimde yeniden sorulması olarak ortaya çıkabilir. Özgünlük, konformizme en güçlü yanıtındır.\n\n'
        'Haritanda bu enerji aktive olduğunda en büyük katkın; başkalarına da kendi özgün ışıklarını yakmaları için ilham vermektir.',
    'Basak':
        'Uranüs Başak burcundayken çalışma biçimleri, sağlık anlayışı ve hizmet sistemi köklü dönüşüm geçirir. Bu nesil, gündelik hayatın ritimlerini, bedenle ilişkiyi ve emek kavramını yeniden tanımlayan olayları deneyimler. Teknolojinin iş dünyasına girmesi, alternatif tıbbın yükselişi ya da sağlık anlayışındaki devrimler bu neslin izleridir.\n\n'
        'Bireysel olarak rutin konularda ani kırılmalar, sağlık alanında alışılmamış yollar ya da çalışma biçiminde devrimsel değişimler yaşanabilir. Sistematik düşünce ile sıra dışı çözümler bir arada kullanıldığında bu enerji en verimlisini verir.\n\n'
        'Uranüs Başak\'ın en güzel armağanı: detayları, bütünün hizmetinde kullanabilen yaratıcı bir pratisyen olmaktır.',
    'Terazi':
        'Uranüs Terazi burcundayken ilişkilerin tanımı, adalet anlayışı ve ortaklık modelleri köklü biçimde sorgulanır. Bu nesil, evlilik kurumunun dönüştüğü, ilişki biçimlerinin çeşitlendiği ve bireylerin ortaklıkta özerkliklerini talep ettiği dönemleri deneyimler.\n\n'
        'Bireysel hayatında bu, ilişkilerde ani başlangıçlar ve bitiş noktaları, alışılmamış ortaklık modelleri ya da adalet arayışında radikal tutumlar olarak belirginleşir. Özgürlük ve bağlılık arasındaki denge sürekli yeniden müzakere edilir.\n\n'
        'Bu enerjinin olgunluğu şöyle gelir: farklı olmak ile birlikte olmak arasında sağlıklı bir yer bulmak — bu hem senin hem de ortaklarının özgürlüğünü onurlandırır.',
    'Akrep':
        'Uranüs Akrep burcundayken gücün, seksüelliğin, ölümün ve tabuların tanımı kökten sorgulanır. Bu yerleşim, toplumun en derin ve en karanlık konularında köklü bir dönüşüm başlatır. Psikolojik devrimler, gizli güç yapılarının ifşası ve kolektif dönüşümün en yoğun biçimi bu enerjiyle çakışır.\n\n'
        'Bireysel hayatında bu, bastırılmış gerçeklerin ani yüzeye çıkması, güç dinamiklerinde ani kırılmalar ya da ruhsal/psikolojik dönüşüm süreçlerinde hız kazanma olarak deneyimlenebilir.\n\n'
        'Bu enerjinin en derin meyvesi şudur: tabular yıkıldığında ya da gizlilik aydınlığa kavuştuğunda, gerçek özgürlük başlar.',
    'Yay':
        'Uranüs Yay burcundayken inanç sistemleri, eğitim anlayışı ve dünya görüşleri radikal biçimde sorgulanır. Bu nesil, dini otoritenin, kurumsal eğitimin ve "tek doğru" anlayışının çözüldüğünü deneyimler. Farklı felsefelerin, kültürlerin ve inanç biçimlerinin bir arada var olduğu çoğulcu bir dünya bu neslin mirasıdır.\n\n'
        'Bireysel hayatında inanç dünyasında ani dönüşümler, uzak kültürlerle beklenmedik bağlantılar ya da eğitim yolunda alışılmamış rotalar bu enerjinin yansımalarıdır.\n\n'
        'Uranüs Yay\'ın armağanı: farklı doğruların bir arada var olabileceğini kabul etmek ve bu çoğulculuğu bir zenginlik olarak taşımaktır.',
    'Oglak':
        'Uranüs Oğlak burcundayken kurumlar, otoriteler ve toplumsal yapılar köklü dönüşüm geçirir. Bu yerleşim, hükümetlerin, büyük şirketlerin ve geleneksel kariyer anlayışının sorgulandığı dönemlere denk gelir. Disiplin ile devrim bu enerjide bir arada yaşar.\n\n'
        'Bireysel hayatında kariyer alanında ani sıçramalar ya da kırılmalar, otorite figürleriyle beklenmedik gerilimler ya da sistemi içeriden dönüştürme güdüsü öne çıkabilir.\n\n'
        'Bu enerjinin en güçlü biçimi şudur: düzeni bütünüyle reddetmek değil; onu daha adil, daha işlevsel ve daha insancıl hale getirmek için çalışmak.',
    'Kova':
        'Uranüs Kova burcunda kendi evindedir — en saf, en güçlü biçimiyle tezahür eder. Kolektif bilinç, teknoloji, bireysel özgürlük ve insanlığın geleceği bu enerjiyle şekillenir. Bu nesil, internetin, küresel iletişimin ve kolektif hareketlerin doruk noktasını deneyimler.\n\n'
        'Bireysel hayatında bu, topluluklarda ani değişimler, teknoloji aracılığıyla beklenmedik bağlantılar ya da insanlığa hizmet güdüsünün aniden güçlenmesi olarak yaşanabilir.\n\n'
        'Uranüs Kova\'nın en yüksek ifadesi: özgürlüğünü insanlığın özgürlüğüyle birleştirerek devrimci bir yaratıcılık ortaya koymaktır.',
    'Balik':
        'Uranüs Balık burcundayken ruhaniyet, sangu ve kolektif bilinçdışı köklü dönüşüm geçirir. Bu yerleşim, mistisizmin, alternatif ruhsal pratiklerin ve toplumsal empatinin öne çıktığı dönemlere denk gelir. Görünmeyenin nasıl algılandığı, kitle psikolojisinin nasıl işlediği bu nesil tarafından yeniden tanımlanır.\n\n'
        'Bireysel hayatında sezgisel alanlarda ani aydınlanmalar, spiritüel pratiklerde radikal kırılmalar ya da sınırların eriyip yeniden çizildiği derin deneyimler yaşanabilir.\n\n'
        'Bu enerjinin en güzel armağanı: görünmezi görmek ve onu somutlaştırmak için alışılmamış yollar bulmaktır.',
  },

  'Neptune': {
    'Koc':
        'Neptün Koç burcundayken hayaller, vizyonlar ve idealler bir ateş gibi tutuşur. Bu nesil, kolektif olarak güçlü bir kahraman arketipi, yeni bir kimlik arayışı ya da kurtarıcı figürlerine olan özlemin yoğunlaştığı dönemlerde doğar. Bireysellik ruhani bir boyut kazanır; "ben kimim?" sorusu mistik bir çağrıya dönüşür.\n\n'
        'Bireysel hayatında bu enerji, kendini başkalarına adamak ya da büyük bir amaç için yanmak biçiminde tezahür edebilir. Hayal kırıklıkları ise genellikle gerçekleşmesi mümkün olmayan beklentilerden gelir — özellikle liderlik figürlerine ya da kahramanlara yansıtılan idealize edilmiş imgelerden.\n\n'
        'Neptün Koç\'un olgunluğu şudur: ateşi bir ideale değil; bir eyleme dönüştürmek. Hayal görmeyi bırakmadan gerçeği de görmek.',
    'Boga':
        'Neptün Boğa burcundayken maddi dünya ile ruhani alan arasındaki sınır erir. Bu nesil, paranın, doğanın, güzelliğin ve duyusal deneyimin mistik bir değer kazandığı dönemleri yaşar. "Gerçek zenginlik nedir?" sorusu kolektif bilincin gündemine girer.\n\n'
        'Bireysel hayatında bu, maddi kaynaklarla ilgili yanılsamalar, idealleştirilmiş bir "güzel hayat" imgesi ya da doğa ve sanat aracılığıyla deneyimlenen manevi açılmalar olarak kendini gösterebilir.\n\n'
        'Bu enerjinin en güçlü biçimi: maddi dünyayı bir araç olarak değil; ruhani bir pratik olarak yaşamaktır. Güzelliği kutsamak, bu Neptün\'ün en yüksek ifadesidir.',
    'Ikizler':
        'Neptün İkizler burcundayken iletişim, dil ve bilgi mistik bir boyut kazanır. Bu nesil, kelimelerin ve hikayelerin büyük kitleler üzerinde yarattığı büyünün, propagandanın ya da şiirin gücünü deneyimler. Gerçek ile kurgu arasındaki sınır bulanıklaşır.\n\n'
        'Bireysel hayatında bu, sezgisel iletişim, sanatlı bir anlatı yeteneği ya da gerçekleri algılamada zaman zaman yaşanan yanılsamalar biçiminde tezahür edebilir. Duyduğuna hemen inanma eğilimi bu enerjinin gölge yönüdür.\n\n'
        'Neptün İkizler\'in armağanı: kelimeleri ruhun hizmetinde kullanmak — bu şiir, terapi, müzik sözleri ya da anlam yüklü bir anlatı olabilir.',
    'Yengec':
        'Neptün Yengeç burcundayken aile, yuva ve duygusal aidiyet ruhani bir anlam kazanır. Bu nesil, geçmişe, köklere ve ata mirasına derin ama zaman zaman idealleştirilmiş bir bağlılık duyar. "Gerçek yuva"ya duyulan özlem kolektif bir rüyaya dönüşür.\n\n'
        'Bireysel hayatında aile dinamikleriyle ilgili yanılsamalar, "mükemmel ev" hayalleri ya da bakım ve beslenme aracılığıyla deneyimlenen manevi açılmalar bu enerjinin yansımalarıdır.\n\n'
        'Neptün Yengeç\'in olgunluğu, idealize edilmiş geçmişten değil; şimdiki andan beslenen gerçek bir yuva inşa etmektir.',
    'Aslan':
        'Neptün Aslan burcundayken yaratıcılık, sanat ve kişisel karizmanın mistik bir boyut kazandığı dönemler ortaya çıkar. Bu nesil, büyük sanatçıların, efsanevi liderlerin ya da kolektif hayal gücünün doruk noktalarına tanıklık eder. Ego ile ruhanilik arasındaki ince çizgi sürekli müzakere edilir.\n\n'
        'Bireysel hayatında bu, sanatsal alanda derin bir ilham ya da derin bir yanılsama olarak tezahür edebilir. Övgü ve takdire olan ihtiyaç, spiritüel bir kırılganlığa dönüşebilir.\n\n'
        'Bu enerjinin en yüksek ifadesi: yaratmayı sevgi ile üretmek — ne alkış için ne de ego tatmini için, ruhun hareketi olarak.',
    'Basak':
        'Neptün Başak burcundayken hizmet, iyileşme ve gündelik hayatın ritüelleri ruhani bir anlam kazanır. Bu nesil, sağlığın, doğanın şifalı yönünün ve bedenin bilgeliğinin öne çıktığı dönemleri yaşar. Pratik şefkat ve manevi sorumluluk bu neslin kolektif çağrısıdır.\n\n'
        'Bireysel hayatında bu, alternatif şifa yöntemlerine ilgi, hizmet aracılığıyla deneyimlenen manevi anlam ya da mükemmellik ile yanılsama arasında gidip gelen bir döngü olarak kendini gösterebilir.\n\n'
        'Neptün Başak\'ın en güçlü armağanı: bedenin ruhun tapınağı olduğunu hafızaya getirmek ve buna göre yaşamaktır.',
    'Terazi':
        'Neptün Terazi burcundayken ilişkiler, güzellik ve adalet idealize edilmiş bir sis perdesine bürünür. Bu nesil, aşkın ne olduğuna dair derin ama zaman zaman gerçeklikten kopuk idealler taşır. "Kusursuz ilişki" hayali kolektif bir özleme dönüşür.\n\n'
        'Bireysel hayatında romantik yanılsamalar, idealize edilmiş partnerler ya da ilişkide kendini fedaya yönelik güçlü bir eğilim bu enerjinin gölgeleridir. Karşı taraftaki gerçek insanı görmek zaman zaman zorlu olabilir.\n\n'
        'Neptün Terazi\'nin olgunluğu: koşulsuz sevgiyi sağlıklı sınırlarla dengelemek ve gerçek ilişkinin mükemmel olmadığını ama yine de güzel olabileceğini kabullenmektir.',
    'Akrep':
        'Neptün Akrep burcundayken güç, cinsellik ve dönüşümün mistik boyutları öne çıkar. Bu nesil, tabuların manevi yönlerini araştırır; ölüm, yeniden doğuş ve ruhun dönüşümü kolektif bilincin merkezine yerleşir. Okültizm, psikoloji ve derin ruhanilik bu dönemin izleridir.\n\n'
        'Bireysel hayatında bu, güçlü ama yanıltıcı bağlantılara yatkınlık, bastırılmış gölgelerin ruhani bir biçimde yüzeye çıkması ya da dönüşüm süreçlerinin gizemli bir çekim alanı yaratması olarak deneyimlenebilir.\n\n'
        'Neptün Akrep\'ın en derin öğretisi: karanlıkta bile bir ışığın bulunabileceğidir — ve o ışık çoğu zaman karanlıkla dürüstçe yüzleşmekten doğar.',
    'Yay':
        'Neptün Yay burcundayken inanç, felsefe ve anlam arayışı mistik bir boyut kazanır. Bu nesil, büyük spiritüel hareketlerin, evrensel bir dinin ya da mistik deneyimin merkeze geldiği dönemleri yaşar. "Gerçeğin sonu nedir?" sorusu kolektif bir yanılsama alanı yaratır.\n\n'
        'Bireysel hayatında kutsal ya da kaçamak arayışında yanılsamalar, yabancı bir kültür ya da inanç sistemine idealize edilmiş bir yaklaşım bu enerjinin gölgesidir. Anlam arayışı bazen gerçeklikten kopuşa dönüşebilir.\n\n'
        'Bu enerjinin en olgun biçimi: derin bir inanca sahip olmak ama onu dogmaya dönüştürmemek; ruhaniyeti hem içsel hem gündelik bir pratiğe taşımaktır.',
    'Oglak':
        'Neptün Oğlak burcundayken kurumlar, kariyer ve toplumsal yapılar ruhani bir boyut ile yanılsama arasında salınır. Bu nesil, maddi başarının ve kurumsal gücün ne anlama geldiğini derin biçimde sorgular. Kapitalizmin, devletin ve geleneksel otoritenin mistik bir çöküş ya da dönüşüm geçirdiği dönemler bu neslin mirasıdır.\n\n'
        'Bireysel hayatında kariyer alanındaki idealler ile gerçeklik arasındaki derin uçurum, sisteme duyulan hem büyülü hem hayal kırıklığı yaratan inançlar bu enerjinin yansımalarıdır.\n\n'
        'Neptün Oğlak\'ın olgunluğu: somut adımlarla ruhani bir amaca hizmet eden bir kariyer inşa etmek.',
    'Kova':
        'Neptün Kova burcundayken kolektif bilinç, insanlığın geleceği ve teknolojinin ruhu üzerindeki etkisi mistik bir anlam kazanır. Bu nesil, dijital dünyanın gerçeklik algısını nasıl bulanıklaştırdığını ve kolektif hayallerin nasıl kitleleri şekillendirdiğini deneyimler.\n\n'
        'Bireysel hayatında çevrimiçi kimliklere ya da kolektif hareketlere idealize edilmiş bir bağlılık, toplumsal yanılsamalar ya da insanlığa duyulan mistik bir umut bu enerjinin yansımalarıdır.\n\n'
        'Bu enerjinin en güçlü biçimi: teknolojiyi bir araç, insanlığı ise bir amaç olarak görmek ve bu bilgeliği pratiğe dökmektir.',
    'Balik':
        'Neptün Balık burcunda kendi evindedir — bu en güçlü, en derin ve en saf halidir. Kolektif empati, ruhani eriş ve görünmeyenin varlığı bu dönemde doruk noktasına ulaşır. Bu nesil, sınırların eridiği, bütünlük hissinin yoğunlaştığı ve mistik deneyimlerin normalleştiği bir dünyada doğar.\n\n'
        'Bireysel hayatında bu, derin manevi deneyimler, güçlü sezgisel algı ya da kişisel sınırların korunmasında ciddi zorluklar biçiminde tezahür edebilir. Gerçek ile hayal arasındaki çizgi zaman zaman kaybolur.\n\n'
        'Neptün Balık\'ın en yüce ifadesi: şefkati ve ruhaniyeti, kendini yitirmeden yaşamak. Bu enerjiyle taşınanlar, gördükleri şefkati somut bir iyiliğe dönüştürdüklerinde gerçek anlamda ışık saçarlar.',
  },

  'Pluto': {
    'Koc':
        'Plüton Koç burcundayken dönüşüm ateşten başlar; savaş, güç ve kimlik kolektif düzeyde köklü biçimde yeniden şekillenir. Bu nesil, büyük çatışmaların, kolektif kimlik krizlerinin ve bireyin gücünün test edildiği dönemlerde doğar. Bireysellik, hem en büyük güç hem de tehlikeli bir silah olarak deneyimlenir.\n\n'
        'Bireysel hayatında bu enerji, öfkenin ya da güçlü tutkunun dönüştürücü bir araç haline gelmesi, yıkıcı başlangıçların ardından güçlü bir yeniden inşa süreci olarak kendini gösterir. Her fırtınanın ardında bir temizlik gizlidir.\n\n'
        'Plüton Koç\'un en yüce ifadesi: ateşi yıkmak için değil; arındırmak için kullanmak. Gerçek güç, savaşmakta değil; neyin korunmaya değer olduğunu seçmekte yatar.',
    'Boga':
        'Plüton Boğa burcundayken maddi dünya, değerler ve güvenlik sistemleri köklü dönüşüm geçirir. Bu nesil, ekonomik sistemlerin çöküşünü, doğal kaynakların sınırını ya da mülkiyet anlayışının kökten sorgulanmasını deneyimler. Güvenli sandıklarını kaybedip daha kalıcı bir şeyle yeniden inşa edenler bu neslin simgesidir.\n\n'
        'Bireysel hayatında finansal dönüşümler, değerlerin derin biçimde yeniden biçimlenmesi ya da maddi dünyaya karşı güç ve güçsüzlük arasında gidip gelen bir ilişki yaşanabilir.\n\n'
        'Bu enerjinin olgunluğu: toprak gibi güçlü, derin ve donmayan bir bağ — yani kendini sarsılmaz kılmak değil; sarsıldıktan sonra yeniden köklenebilmek.',
    'Ikizler':
        'Plüton İkizler burcundayken zihin, iletişim ve bilgi sistemleri derin bir güç mücadelesi yaşar. Bu nesil, bilginin nasıl kontrol edildiğini, propagandanın nasıl inşa edildiğini ya da dilin nasıl silah haline gelebildiğini deneyimler. Kelimeler iktidar üretir; bu nesil bu gerçeği çok iyi bilir.\n\n'
        'Bireysel hayatında bu, derin araştırma güdüsü, konuşma biçimindeki ya da düşünce yapısındaki köklü dönüşümler ya da gizli bilgilere ulaşma ihtiyacı olarak tezahür edebilir.\n\n'
        'Plüton İkizler\'in armağanı: kelimeleri hakikat için kullanmak, manipülasyona değil; arındırmaya hizmet eden bir iletişim inşa etmektir.',
    'Yengec':
        'Plüton Yengeç burcundayken aile sistemi, anne arketipi ve duygusal kökler derin bir dönüşüm geçirir. Bu nesil, aile yapılarının köklü biçimde değiştiği, ata mirasının sorgulandığı ya da kolektif duygusal travmaların yüzeye çıktığı dönemlerde doğar.\n\n'
        'Bireysel hayatında bu, aile gölgeleriyle yüzleşmek, güvenlik anlayışının köklü biçimde yeniden inşa edilmesi ya da koruma güdüsünün çok güçlü ya da çok bastırılmış biçimler alması olarak kendini gösterebilir.\n\n'
        'Plüton Yengeç\'in olgunluğu: geçmişin ağırlığını taşıyarak değil; ondan öğrenerek ilerlemek. Köklerin seni sabitle değil; besleyen bir kaynak olmasına izin vermektir.',
    'Aslan':
        'Plüton Aslan burcundayken ego, yaratıcılık ve iktidar derin bir dönüşüm geçirir. Bu nesil — Savaş Sonrası nesil olarak da bilinen Plüton Aslan kuşağı — güç ile bireysel kimlik arasındaki gerilimi kolektif anlamda deneyimledi. Kahraman figürleri yükselir, yerinden edilir ve yeniden tanımlanır.\n\n'
        'Bireysel hayatında bu, güçlü bir liderlik güdüsü, ego ve otantiklik arasındaki derin mücadele ya da sahneye çıkma ile geri çekilme arasında yaşanan köklü döngüler olarak tezahür edebilir.\n\n'
        'Bu enerjinin en yüksek noktası: gücünü başkalarını küçültmek için değil; onları yükseltmek için kullandığında ortaya çıkar.',
    'Basak':
        'Plüton Başak burcundayken çalışma sistemleri, sağlık anlayışı ve hizmet etme biçimi köklü bir dönüşüm geçirir. Bu nesil, iş dünyasının, sağlık sistemlerinin ve gündelik hayatın rutinlerinin kökten sorgulandığı ya da yeniden yapılandığı dönemleri yaşar.\n\n'
        'Bireysel hayatında bu, işine ya da sağlığına yönelik köklü kırılmalar, mükemmeliyetçilikle bozulan ilişkinin dönüşümü ya da bedenin gönderdiği mesajları nihayet duymak olarak kendini gösterebilir.\n\n'
        'Plüton Başak\'ın en güçlü armağanı: analiz kapasitesini iyileşme hizmetine koşmak — hem bedenin hem sistemin hem de ruhun şifasına adanmak.',
    'Terazi':
        'Plüton Terazi burcundayken ilişkiler, güç dengeleri ve adalet anlayışı köklü bir dönüşüm yaşar. Bu nesil, klasik ilişki modellerinin, evlilik kurumunun ve toplumsal sözleşmelerin köklü biçimde sorgulandığı dönemlerde doğdu. Güç ilişkilerdeki en sessiz ama en belirleyici unsur haline gelir.\n\n'
        'Bireysel hayatında bu, ilişkilerde derin güç mücadeleleri, adalet arayışının obsesif bir boyut alması ya da ortaklık dinamiklerinin köklü biçimde yeniden tanımlanması olarak tezahür edebilir.\n\n'
        'Plüton Terazi\'nin olgunluğu: adaleti yalnızca dışarıda aramak değil; önce ilişkilerinde ve ardından kendinle kurduğun bağda bulmak.',
    'Akrep':
        'Plüton Akrep burcunda kendi evindedir — bu en saf ve en yoğun konumdur. Güç, dönüşüm ve ölümün tanımlarının kolektif bilinçte köklü biçimde sorgulandığı bu dönem; AIDS krizi, nükleer korku ve psikolojik derinliğin ana akıma girişinin yaşandığı kuşakla örtüşür.\n\n'
        'Bireysel hayatında bu, bastırılmış güçlerin şiddetli biçimde yüzeye çıkması, derin ama dönüştürücü krizler ya da ruhsal arınmanın en yoğun biçimleri olarak kendini gösterebilir.\n\n'
        'Plüton Akrep\'ın en yüce ifadesi: karanlıkla o kadar dürüstçe yüzleşmek ki, onu bir düşman olarak değil; bir dönüşüm fırıncısı olarak deneyimlemek.',
    'Yay':
        'Plüton Yay burcundayken inanç sistemleri, eğitim ve anlam arayışı derin bir güç mücadelesi içindedir. Bu nesil, küreselleşmenin, din savaşlarının ve farklı inançların çarpıştığı büyük tarihsel dönemleri deneyimler. Gerçek nedir, kim söyler ve kimin için geçerlidir — bu sorular kolektif bilincin merkezine oturur.\n\n'
        'Bireysel hayatında inanç sistemindeki köklü kırılmalar, anlam arayışının obsesif ya da sarsıcı biçimler alması ya da eğitim yolundaki ciddi dönüm noktaları bu enerjinin yansımalarıdır.\n\n'
        'Bu enerjinin olgunluğu: inancını gerçekten kendin bulmak — dogmaları miras almak değil, deneyimin içinden çıkartmak.',
    'Oglak':
        'Plüton Oğlak burcundayken kurumsal güç, otorite yapıları ve kariyer sistemleri derin bir dönüşüm geçirir. Bu nesil — 2008 sonrası dünyada yetişenler — küresel ekonomik çöküşe, siyasi yapıların çözülmesine ve otoritenin yeniden tanımlanmasına tanıklık eder.\n\n'
        'Bireysel hayatında kariyer alanında köklü kırılmalar, otorite figürleriyle derin güç dinamikleri ya da sistemin içinden onu dönüştürme güdüsü öne çıkabilir.\n\n'
        'Plüton Oğlak\'ın en güçlü tezahürü: sistemi içeriden yenilemek için gereken cesareti bulmak ve bunu sahici bir sorumlulukla taşımak.',
    'Kova':
        'Plüton Kova burcundayken kolektif bilinç, teknoloji ve özgürlük anlayışı köklü bir güç dönüşümü yaşar. Bu gelecek yerleşimi, insanlığın nasıl örgütlendiğini, bilginin nasıl paylaşıldığını ve bireyin kolektif içindeki yerini temelden yeniden şekillendirir.\n\n'
        'Bireysel hayatında bu, özgürlük ile kontrol arasındaki derin mücadele, kolektif hareketlerdeki güç dinamikleriyle yüzleşme ya da insanlığa hizmet güdüsünün hayatı şekillendiren bir güce dönüşmesi olarak tezahür edebilir.\n\n'
        'Plüton Kova\'nın en yüksek ifadesi: devrimi birlikte yapmak — ne tek başına ne de kaybolarak, ama özgün bir birey olarak kolektifin içinde.',
    'Balik':
        'Plüton Balık burcundayken kolektif bilinçdışı, empati ve manevi sistemler köklü bir dönüşüm geçirir. Bu enerji, görünmeyenin görünür kılındığı, ruhani güçlerin ve kolektif gölgelerin yüzeye çıktığı dönemlere işaret eder.\n\n'
        'Bireysel hayatında bu, güçlü ama zaman zaman bunaltıcı empati, ruhani dönüşüm süreçlerindeki şiddetli kırılmalar ya da sınırların tamamıyla erimesiyle başlayan ve yeniden inşayla sonuçlanan döngüler olarak deneyimlenebilir.\n\n'
        'Bu enerjinin en yüksek ifadesi: şefkati bir güç olarak, sınırı ise bir özgürlük olarak kavramak. İkisi bir arada yaşandığında Plüton Balık gerçek anlamda dönüştürür.',
  },

  'NorthNode': {
    'Koc':
        'Kuzey Ay Düğümü Koç burcundayken ruhsal evrimin yönü, bağımlılıktan bağımsızlığa, sürüden bireye, belirsizlikten netliğe doğru işaret eder. Geçmiş yaşamlardan ya da erken dönem koşullanmalardan gelen Terazi enerjisi — uzlaşma, başkasının isteğine göre şekillenme, karar erteleme — artık dönüştürülmesi gereken bir kalıptır.\n\n'
        'Bu yaşamda sana çağrı şudur: kendi önceliklerini ilk sıraya koy. İlk adımı atmak, tek başına karar vermek ve gerektiğinde "hayır" demek hem ürkütücü hem de özgürleştirici gelecektir. Bu ürkeklik geçmişin mirası, bu cesaret ise geleceğin davetiyesidir.\n\n'
        'Düğümünle uyum sağladığında hayat sana enerjik bereket, netlik ve sahici bir kimlik duygusu geri verir. Başkalarını mutlu etmek yerine, kendin olmaya cesaret etmek bu ömrün en büyük armağanıdır.',
    'Boga':
        'Kuzey Ay Düğümü Boğa burcundayken ruhsal evrim, sarsılmazlığa, güvenliğe ve şimdiki anın bereketini sindirebilmeye yönelir. Karşıt kutup olan Akrep\'in enerjisi — yoğun dönüşüm, güç mücadeleleri, hiçbir şeye tutunamamak — artık bırakılmaya hazır olan kalıpları simgeler.\n\n'
        'Bu yaşamda sana çağrı şudur: sabır, basitlik ve güzelliği fark etme pratiği. Mevcut olanı takdir etmek, istikrarlı adımlar atmak ve bedenin içinde var olmak bu ömrün en derin dersleridir. Derin krizlerden değil; gündelik ritüellerin sessiz mucizesinden beslenmek öğrenilecek şeydir.\n\n'
        'Düğümünle uyum sağladığında, sahici güveni ve bolluğun sadeliğini hem içinde hem de dışında deneyimlersin.',
    'Ikizler':
        'Kuzey Ay Düğümü İkizler burcundayken ruhsal evrim, iletişime, öğrenmeye ve zihinsel sevinçe yönelir. Karşıt kutup olan Yay\'ın enerjisi — kesin cevaplar aramak, tek bir büyük doğruya bağlanmak, hareket etmeden anlam bulmak — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: soruları cevaplardan çok sevmek. Öğrenmek, bağlantı kurmak, fikir alışverişi yapmak ve yakın çevrendeki mirası keşfetmek bu ömrün ana akışıdır. Büyük felsefeler yerini küçük ama anlam yüklü gündelik bağlantılara bırakır.\n\n'
        'Düğümünle uyum kurduğunda zihin hafifler, merak bir zevke dönüşür ve bilgi paylaşmak derin bir tatmin verir.',
    'Yengec':
        'Kuzey Ay Düğümü Yengeç burcundayken ruhsal evrim, kök salmaya, beslenmeye ve duygusal güvenliğe yönelir. Karşıt kutup olan Oğlak\'ın enerjisi — sert performans, duygusal mesafe, her şeyi kontrol altında tutma — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: zayıflığına izin vermek; hem başkalarından bakım almak hem de kendi iç çocuğuna güvenli bir ev sunmak. Başarı ve performans yerine, besileyici ilişkiler ve duygusal dürüstlük hakiki tatminin kaynağıdır.\n\n'
        'Düğümünle uyum kurduğunda, hem kendi hem de başkalarının güvenli sığınağı haline gelirsin. Bu yumuşaklık zayıflık değil; en derin gücündür.',
    'Aslan':
        'Kuzey Ay Düğümü Aslan burcundayken ruhsal evrim, özgün öz ifadeye, sahneye çıkmaya ve kendi ışığını keşfetmeye yönelir. Karşıt kutup olan Kova\'nın enerjisi — gruba karışmak, arka planda kalmak, kendi ihtiyaçlarını kolektife feda etmek — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: görünmekten çekinme. Kendi yaratıcılığına, beğenine ve özgün kişiliğine güven. Ne hissettiğini, ne sevdiğini sahiplenmek bu ömrün temel pratiğidir.\n\n'
        'Düğümünle uyum kurduğunda, hem kendini hem etrafındakileri ısıtan bir ışık kaynağı olursun.',
    'Basak':
        'Kuzey Ay Düğümü Başak burcundayken ruhsal evrim, alçakgönüllü hizmete, uzmanlığa ve gündelik hayatın ritüellerine yönelir. Karşıt kutup olan Balık\'ın enerjisi — sürüklenme, kaçış, sınırsız fedakarlık, gerçeklikten kopuş — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı: somut olmak, sistematik düşünmek ve bedenle, düzenle dost olmak. Büyük vizyonlar yerini küçük ve tutarlı adımlara bırakır. Hizmet ederek büyümek, bu ömrün en derin kaynaklarından biridir.\n\n'
        'Düğümünle uyum kurduğunda, hem kendin hem de çevrende anlam ve düzen inşa eden bir varlık haline gelirsin.',
    'Terazi':
        'Kuzey Ay Düğümü Terazi burcundayken ruhsal evrim, gerçek ortaklığa, uzlaşıya ve adalet arayışına yönelir. Karşıt kutup olan Koç\'un enerjisi — her şeyi tek başına yapmak, başkalarına ihtiyaç duymamak, ilk sıraya sürekli kendini koymak — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: gerçek anlamda dinlemeyi, uzlaşmayı ve ortak bir vizyon inşa etmeyi öğrenmek. İlişkiler hem aynandır hem de büyüme alanındır. Güçlü ol; ama yanında biriyle.\n\n'
        'Düğümünle uyum kurduğunda, her iki tarafı da onurlandıran adil bağlar kurarsın ve bu bağlar hem seni hem de karşındakini özgürleştirir.',
    'Akrep':
        'Kuzey Ay Düğümü Akrep burcundayken ruhsal evrim, derinleşmeye, dönüşüme ve gizem alanlarına yönelir. Karşıt kutup olan Boğa\'nın enerjisi — konforlu rutinlere tutunmak, maddi güvenliği tehdit altındaymış gibi hissetmek, değişime direnç — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: bırakmaya cesaret etmek. Güvende hissettiğin ama artık büyümeni durduran her şeyi bırakmak ve dönüşümün sularına girmek. Ölüm bir son değil; yeniden doğuşun kapısıdır.\n\n'
        'Düğümünle uyum kurduğunda güç, anlam ve derin bağlar seni bekler. En yüksek noktanda; başkalarının da dönüşümüne rehberlik edersin.',
    'Yay':
        'Kuzey Ay Düğümü Yay burcundayken ruhsal evrim, büyük anlama, felsefeye ve ufuk genişletmeye yönelir. Karşıt kutup olan İkizler\'in enerjisi — bilgi toplamak ama anlam üretememek, zihinsel meşguliyet içinde gerçek sorudan kaçmak — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: inançsallık, vizyon ve büyük resme bakabilmek. Kısa mesafeli bilginin ötesine geçip yaşamına rehberlik edecek derin bir anlayış bulmak bu ömrün davetiyesidir.\n\n'
        'Düğümünle uyum kurduğunda, hem öğretir hem de ilham verirsin. Hayat daha geniş ve daha dolu hissettirmeye başlar.',
    'Oglak':
        'Kuzey Ay Düğümü Oğlak burcundayken ruhsal evrim, olgunlaşmaya, yapı inşa etmeye ve kalıcı bir miras bırakmaya yönelir. Karşıt kutup olan Yengeç\'in enerjisi — duygusal güvensizliklere sürüklenmek, geçmişe yapışmak, aile ya da kök dinamiklerinde kaybolmak — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: disiplinle ilerlemek, kendi otoriteni inşa etmek ve dışarıdan onay beklemeden sorumluluk almak. Kariyer ve toplumsal katkı bu ömrün biçimlendiği alanlardır.\n\n'
        'Düğümünle uyum kurduğunda, kendin için değil; arkanda bırakacakların için çalışmanın derin tatminini yaşarsın.',
    'Kova':
        'Kuzey Ay Düğümü Kova burcundayken ruhsal evrim, kolektife katkıya, özgünlüğe ve insanlığı daha geniş bir gözle görmeye yönelir. Karşıt kutup olan Aslan\'ın enerjisi — bireysel ego üzerine aşırı odaklanma, sürekli takdir ve onay arayışı, küçük sahnede var olmak — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: birinden fazlasına ait olmak. Topluluğa, sürüden farklı düşünen gruplara ve geleceğe yatırım yapmak bu ömrün büyüme metodudur.\n\n'
        'Düğümünle uyum kurduğunda, hem kendi özgünlüğünü yaşayan hem de yalnız olmayan birisin. Fark yaratan katkın, gerçek tatminin adresidir.',
    'Balik':
        'Kuzey Ay Düğümü Balık burcundayken ruhsal evrim, şefkate, sezgiye ve görünmeyene teslim olmaya yönelir. Karşıt kutup olan Başak\'ın enerjisi — aşırı analiz, mükemmeliyetçilik, her şeyi kontrol etme ihtiyacı — dönüştürülmesi gereken kalıplardır.\n\n'
        'Bu yaşamda sana çağrı şudur: akmaya bırakmak. Cevabı bilmeden ilerlemek, belirsizliği bir tehdit olarak değil; bir alan olarak deneyimlemek ve sezgine güvenmek bu ömrün en derin pratiğidir.\n\n'
        'Düğümünle uyum kurduğunda, şefkat dolu bir varlık olarak hayata dahil olursun ve başkalarının en derin korkularını da taşıyabilecek bir dinginlik kazanırsın.',
  },

  'SouthNode': {
    'Koc':
        'Güney Ay Düğümü Koç burcundayken ruhun derin bir miras taşır: hızlı karar alma, tek başına hareket etme ve hayatta kalmak için gereksiz yere mücadele etme. Bu örüntüler geçmişte — ister bu hayatta ister önceki dönemlerde oluşmuş olsun — gerçek bir koruyuculuk işlevi gördü. Ama şu an o savaş havasını taşıdığın yerde, aslında savunmaya gerek yoktur; tehlike artık burada değil.\n\nBu yaşamda Güney Ay Düğümü\'nün enerji çekimi güçlüdür: zor olduğunda tek başına yol almak, geri adım atmayı yenilgi saymak ve başkalarına güvenmeyi zayıflık zannetmek refleks olarak devreye girer. Ama asıl büyüme, Kuzey Düğümü yönündedir: ortaklık, diğerlerini de daha güçlü kılmak ve "ben" yerine "biz" diyebilmek.\n\nMücadele içgüdün hâlâ bir kaynak; onu köreltmek değil, bilinçle yönlendirmek söz konusu. Ne zaman savaşacağını ve ne zaman geri çekilerek alan açacağını seçebilmek — bu, Koç Güney Düğümü\'nün en olgun ifadesidir. Cesaretini başkalarını güçlendirmek için kullandığında, geçmişinin mirası gerçek bir armağana dönüşür.',
    'Boga':
        'Güney Ay Düğümü Boğa burcundayken ruhun bir önceki düzeyde derin bir güvenlik arayışı içinde olmuş: konfor, maddi istikrar ve tahmin edilebilir bir dünyada tutunma. Bu kalıplar gerçek bir zemin sağladı; bedensel zevkler, dokunsal güzellik ve sahip olmak yoluyla bir güvenlik hissi inşa edildi. Ama bir noktada bu tutunma, büyümeye yer bırakmayan bir kısıtlamaya dönüşebilir.\n\nBu yaşamda değişime direnmek, sağlam olduğu yerde kalmak ve kolay olan tercihlerle devam etmek güçlü bir refleks olarak çalışır. Ancak Kuzey Düğümü büyük resmi göstermeye, anlamı maddi güvenliğin ötesinde aramaya ve daha derin bir paylaşıma davet eder. Kontrolü bırakmak senin için gerçek bir cesaret eylemidir.\n\nBu yaşamda beraberinde getirdiğin sağlam bir temel var; bunu inkar etmek değil, onu derinleşmenin hizmetine koşmak söz konusu. Maddi dünyayla olan sağlam ilişkin hâlâ bir güç — onu şimdi manevi ve duygusal dönüşümün kapısını açmak için kullanabilirsin. Güvenlikten değil, seçimden büyümek — işte Boğa Güney Düğümü\'nün bu yaşamdaki en güçlü dersi budur.',
    'Ikizler':
        'Güney Ay Düğümü İkizler burcundayken ruhun hız ve çok yönlülük üzerine kurulu bir geçmişten geliyor: hızlı veri işleme, birden fazla kanalda aynı anda var olma ve bilgi aracılığıyla esneklik kazanma. Bu beceriler gerçekten işe yaradı; ama belirli bir noktada yüzeysellik, derinliğin önünde bir engel haline geldi.\n\nBu yaşamda zihni meşgul etmek, sürekli bilgi toplamak ve her soruya hızlıca yanıt üretmek güçlü bir alışkanlık olarak kendini dayatabilir. Ama asıl büyüme, Yay yönünde bekliyor: tek bir şeye derinlemesine odaklanmak, bilgiden anlama doğru bir sıçrama yapmak ve felsefi bir perspektif geliştirmek.\n\nZekân asla eksilmez — derinlikle buluştuğunda daha da güçlenir. Her soruya cevap bulmak yerine doğru soruyla uzun süre oturmayı öğrenmek, İkizler Güney Düğümü\'nün bu yaşamdaki en olgunlaştırıcı pratiğidir. Geniş bilmek değil; gerçekten anlamak bu ömrün çağrısıdır.',
    'Yengec':
        'Güney Ay Düğümü Yengeç burcundayken ruhun derin bir duygusal beslenme ve koruma geçmişini taşıyor: aileye adanmışlık, geçmişe bağlılık ve her şeyden önce duygusal güvenliği önceleme. Bu kalıplar gerçek bir sıcaklık ve aidiyet yaratmış olabilir; ama aynı zamanda duygusal örüntülere takılı kalmayı, eski acıları yeniden yaşamayı ve bırakmayı zorlaştırmayı da beraberinde getirebilir.\n\nBu yaşamda duygusal dalgalanmalar güçlü olabilir; aile dinamikleri ya da bakım ilişkileri karmaşık bir yer kaplar. Ancak Oğlak yönündeki Kuzey Düğümü daha yapısal, daha uzun vadeli ve bireysel disipline dayalı bir büyümeye çağırır. Duyguları yönetmek değil, onları anlamak ve kendi hedeflerin için bir yakıt haline getirmek bu yaşamın işidir.\n\nDuygusal zekanı inkar etmeden, onu yapısal bir amaca koşmak mümkündür. Hissetmeyi bırakmak değil; hislerden değil, niyetten hareket etmeyi öğrenmek bu ömrün çağrısıdır. Geçmişinle barışmak hem seni özgür bırakır hem de geleceğini gerçekten inşa etmene zemin açar.',
    'Aslan':
        'Güney Ay Düğümü Aslan burcundayken ruhun bireysel kimlik ve yaratıcı ifade etrafında dönen güçlü bir geçmiş taşıyor. Sahneye çıkmak, takdir görmek ve benzersiz bir şekilde parlamak derin bir ihtiyaç olarak yerleşmiş. Bu enerji gerçek bir karizmatik güç yarattı; ama sahne ışığına olan bağımlılık, bazen ego ve gerçek kimlik arasındaki sınırı bulanıklaştırdı.\n\nBu yaşamda dikkat çekmek ya da merkez olmak istemek refleks gibi hissedebilir. Ama Kova yönündeki Kuzey Düğümü kolektife ait olmayı, bireysel ışığı toplulukla paylaşmayı ve "benim" yerine "bizim" demede anlam bulmayı çağırıyor. Asıl güç, sahne ışığını grup için kullandığında ortaya çıkıyor.\n\nKarizman ve yaratıcı ifaden hâlâ değerli birer kaynak — onları törpülemek değil, başkalarını da güçlendirmek için kullanmak söz konusu. Kendi ışığının başkalarını karartmak zorunda olmadığını içselleştirdiğinde, bu Güney Düğümü\'nün mirası gerçek bir liderlik armağanına dönüşür.',
    'Basak':
        'Güney Ay Düğümü Başak burcundayken ruhun titizlik, hizmet ve mükemmeliyetçilik üzerine kurulu derin bir birikim taşıyor. Ayrıntılara dikkat etmek, doğru olanı yapmak için çok çalışmak ve sistemi işler tutmak için kişisel ihtiyaçlarını arka plana atmak bu geçmişin iz bıraktığı alanlardır. Bu kalıplar seni güvenilir ve yetenekli kıldı; ama aynı zamanda sürekli eleştirme, hiçbir şeyin yeterli olmaması ve takdir görmeksizin hizmet etme döngüsünü de yarattı.\n\nBu yaşamda mükemmel olmaya çalışmak, hataları küçük felaketler gibi hissetmek ve başkalarının gereksinimlerini kendi ihtiyaçlarından önce tutmak güçlü bir refleks olarak çalışır. Balık yönündeki Kuzey Düğümü ise bütünü görmeye, sezgiyi devreye sokmaya ve bazen süreci bırakarak akışa teslim olmaya davet eder. Tüm cevaplara sahip olmak zorunda değilsin.\n\nEleştirel düşüncen hâlâ bir güç; ama onun yanına sezgi, merhamet ve büyük resmi görme kapasitesini eklediğinde gerçek büyüme başlar. Detaylara olan bağlılığın, anlam arayışıyla buluştuğunda — sadece güvenilir değil, aynı zamanda dönüştürücü bir güç haline gelirsin.',
    'Terazi':
        'Güney Ay Düğümü Terazi burcundayken ruhun ilişkisellik, uzlaşma ve başkalarının perspektifini ön planda tutma üzerine kurulu bir geçmiş taşıyor. Barışı korumak, her iki tarafa da adil davranmak ve uyumu sürdürmek bilinçdışı bir öncelik haline gelmiş olabilir. Bu beceriler gerçek bir diplomatik zeka yarattı; ama zaman zaman kendi ihtiyaçlarını o denklemden çıkartma pahasına.\n\nBu yaşamda başkasının istediği olmak, çatışmadan kaçınmak ve kendi fikrini ortaya koymak yerine uzlaşıcı kalmak güçlü bir çekim yaratır. Koç yönündeki Kuzey Düğümü ise kendi merkezini kurmayı, kendi sesini bulmayı ve zaman zaman "bu benim görüşüm" diyebilme cesaretini gerektirir. Bu cesareti göstermek seni bencil yapmaz; seni tam yapar.\n\nDiplomasik zekân hâlâ değerli; ama bu sefer sen de o denklemin tam bir parçasısın. Hem kendin hem başkaları için adil bir alan açmak, Terazi Güney Düğümü\'nün bu yaşamdaki en derin evrimidir. Kendi ihtiyaçlarını dile getirmek — ilişkileri bitirmez; gerçek bir bağlantıya zemin açar.',
    'Akrep':
        'Güney Ay Düğümü Akrep burcundayken ruhun yoğun dönüşüm döngülerinden geçmiş: güç oyunları, derin psikolojik savaşlar, kayıplar ve yeniden doğuşlar. Kontrol ya da kontrol edilme dinamiği hayatın temasına sinmiş olabilir. Bu geçmiş seni psikolojik açıdan güçlü, sezgisel ve gizemi anlayan biri yaptı; ama aynı zamanda güvensizliği, savunmacılığı ya da kapıyı kapatmayı da beraberinde getirebilir.\n\nBu yaşamda insanları sınamak, niyetlerinden şüphe etmek ve kontrolü elde tutmak için geri planda oyun kurmak bilinçdışı bir savunma mekanizması olarak devreye girebilir. Boğa yönündeki Kuzey Düğümü ise sadeliği, güveni ve somut gerçekliğin içinde kalmayı çağırıyor. Her şeyin bir gizemi olması gerekmez; bazı şeyler göründüğü kadar basittir.\n\nDerin sezgin ve psikolojik zekân hâlâ güçlü araçlar — ama bu sefer onları şüpheyi değil, güveni inşa etmek için kullan. Bırakmayı öğrenmek, Akrep Güney Düğümü\'nün bu yaşamda verdiği en büyük şifa eylemidir. Dönüşümün artık kaybetmek zorunda kalmaksızın da gerçekleşebileceğini kabul etmek — bu farkındalık her şeyi değiştirir.',
    'Yay':
        'Güney Ay Düğümü Yay burcundayken ruhun büyük fikirler, idealist vizyonlar ve felsefi özgürlük etrafında dönen bir geçmişten geliyor. Anlam aramak, her deneyimi bir öğretiden süzmek ve ufku hep geniş tutmak bu geçmişin temel refleksleridir. Bu kalıplar seni ufuklu, meraklı ve özgür ruhlu biri yaptı; ama bazen büyük resme o kadar odaklandı ki küçük adımlar, gündelik sorumluluklar ve somut sonuçlar geri planda kaldı.\n\nBu yaşamda taahhütten kaçınmak, ayrıntıyı önemsizleştirmek ya da her zorlandığında "daha yüksek bir anlam" arayışına sığınmak bir refleks olarak çalışabilir. Ama İkizler yönündeki Kuzey Düğümü şunu söylüyor: gerçek bilgi, somuta dokunmakta; gerçek anlam, gündelik bağlantılarda ve küçük doğrularda da gizlidir.\n\nYüksek hedeflerin hâlâ geçerli — ama bu sefer ayrıntı da senin dostundur. Büyük vizyonu küçük ve tutarlı adımlara taşımak, Yay Güney Düğümü\'nün bu yaşamdaki en derin olgunluğunun ifadesidir. Anlam her yerde — hem zirvede hem de toprağa basan ayaklarının altında.',
    'Oglak':
        'Güney Ay Düğümü Oğlak burcundayken ruhun yüksek sorumluluk, disiplin ve başarıya adanmışlık içinde yoğrulmuş bir geçmişi taşıyor. Toplumsal sistemlerin içinde yükselmek, kurumların fal taşı olmak ve otoritenin beklentilerini karşılamak için büyük bir öz fedakarlık gösterilmiş olabilir. Bu kalıplar seni güçlü, güvenilir ve yetenekli kıldı; ama çoğu zaman duygusal gereksinimlerin, zaafiyetin ve sıcaklığın pahasına.\n\nBu yaşamda performans göstermek, görünmez kalıpları takip etmek ve duygusal ihtiyaçlarını "sonraya bırakmak" kuvvetli bir refleks olarak çalışabilir. Yengeç yönündeki Kuzey Düğümü ise tam tersine davet ediyor: duygusal dünyaya kapıyı aralama, bakım almak ve vermek, ve başarının ötesinde gerçek bir bağlantı kurmak.\n\nBaşarı zekân hâlâ seninle — ama bu sefer onun yanına yürek ekle. Kırılganlığını saklamak seni daha güçlü yapmaz; onu sahiplenmek, hem seni hem de çevrendeki insanları gerçekten besleyen bir bağa zemin açar. İşin değil, varlığın seni sevilmeye layık kıldığını anlamak — Oğlak Güney Düğümü\'nün en derin hediyesidir.',
    'Kova':
        'Güney Ay Düğümü Kova burcundayken ruhun kolektif hareketler, ideolojik ağlar ve toplumsal kimlikler içinde var olmuş bir geçmişi taşıyor. "Biz" için düşünmek, kişisel ihtiyaçlarını sistemin gereksinimlerine feda etmek ve bireysel sesi grubun sesiyle eritmek derin bir kalıp olarak yerleşmiş olabilir. Bu geçmiş seni kolektif bilinçle bağlantılı ve ufuklu biri yaptı; ama bireysel kimliğin, kişisel arzuların ve özgün sesin pahasına.\n\nBu yaşamda grupla özdeşleşmek, kalabalığın içinde eriyip gitmek ya da bireysel seçimleri kolektif normlarla meşrulaştırmak güçlü bir refleks olarak devreye girebilir. Aslan yönündeki Kuzey Düğümü ise sana netçe soruyor: sen kim olduğunu bilmeden başkalarına nasıl yön vereceksin?\n\nToplumsal bilinç hâlâ güçlü bir kaynağın; ama bu sefer sen de o kolektifin içinde tam anlamıyla kendi kimliğinle görünürsün. Kalabalığın dışında da var olabileceğini, kendi sesin olmadan kimsenin gerçekten kazanmadığını kabul etmek — Kova Güney Düğümü\'nün bu yaşamda seni götürdüğü en özgürleştirici alan budur.',
    'Balik':
        'Güney Ay Düğümü Balık burcundayken ruhun derin empati, öz fedakarlık ve sınırsız bir merhamet içinde yoğrulmuş bir geçmişi taşıyor. Başkalarının acısını kendi acısı gibi hissetmek, kişisel ihtiyaçlarını arka plana atmak ve gerçeklikten zaman zaman sislerin içine çekilmek bu geçmişin izleridir. Bu kalıplar seni derin bir şefkat sahibi yaptı; ama aynı zamanda sınırlar koymayı, "hayır" demeyi ve kendi varlığını korumayı zorlaştırdı.\n\nBu yaşamda başkalarının enerjisini emmek, gerçeklikten kaçmak için hayal dünyasına ya da manevi kaçışlara sığınmak ve sınır koymakta zorlanmak güçlü refleksler olarak çalışabilir. Başak yönündeki Kuzey Düğümü ise pratik dünyaya, sağlığa, niyetli hizmete ve somut sınırlara davet ediyor. Her şeyi hissetmek yükümlülüğün değil; onu yönetmeyi öğrenmek ise bu yaşamın işi.\n\nŞefkatin hâlâ değerli — ama bu sefer kendin de o şefkatin alıcıları arasındasın. Sınır koymak sevgisizlik değildir; gerçek bakımın kendini de kapsadığını görmek, Balık Güney Düğümü\'nün bu yaşamdaki en derin dönüşümüdür.',
  },

  'Chiron': {
    'Koc':
        'Kiron Koç burcundayken yaranın merkezi kimlik, inisiyatif ve var olma hakkı alanındadır. Kendini ortaya koymak, ilk adımı atmak ya da "ben buradayım" demek derinden ürkütücü gelebilir. Bu yara çoğu zaman erken dönemde — belki de doğduğun andan itibaren — var olma hakkının ya da özgün kimliğinin sorgulandığı hissinden doğmuştur. Savaşmak zorunda hissetmek, kendini kanıtlamak ya da tam tersine görünmez kalmak bu hassasiyetin ikiz yüzleridir.\n\nAma Kiron\'un paradoksu şudur: yara bulunduğu yerde şifa da barınır. Koç Kiron\'la çalışan insanlar zamanla inanılmaz bir cesaret ve inisiyatif kaynağına dönüşür. Kendi kırılganlığını utançla değil, merakla sahiplendiğinde — ne için burada olduğunu gerçekten hissedebilirsin. Kimliğini inşa etmek için başkasının onayına ihtiyacın olmadığını zaman içinde öğrenirsin.\n\nBir gün fark edersin ki, kendine dönük o derin şüpheyi en derinlemesine anlayan birisin. Ve bu anlayış, aynı yükü taşıyan başkalarına cesaret bağışlamanın kapısını açar. Koç Kiron\'un şifacılığı sessiz değildir — çoğu zaman önceki gider, sonra diğerleri gelir.',
    'Boga':
        'Kiron Boğa burcundayken yaranın merkezi güvenlik, öz değer ve bedensellik alanındadır. Maddi yetersizlik korkusu, bedenle zorlu bir ilişki ya da "gerçekten değerliyim" sorusu derin bir hassasiyet noktasını oluşturur. Bu yara çoğu zaman erken dönemde karşılanmamış temel ihtiyaçlardan, bedeni yeterince güvenli bulmamaktan ya da değerinin koşullara bağlı olduğunu öğrenmekten kaynaklanır.\n\nParadoks olarak aynı bu alan, iyileşmenin de yaşandığı yerdir. Bedenin güvenli bir yuva olduğunu keşfetmek — hem dokunsal hem de varoluşsal düzeyde — Boğa Kiron\'un dönüşüm sürecin merkezindedir. Kendi öz değerini, başkasının onayından ya da hesap bakiyenden bağımsız olarak hissetmek bu iyileşmenin en güçlü işaretidir.\n\nBu Kiron\'la gelen kişiler çoğu zaman başkalarına değer ve güzelliği hatırlatmada benzersiz bir yeteneğe sahiptir. Kendi yaranı anladıkça, başkalarının kendi değerini bulmalarına da sessizce rehberlik edersin. Bu şifa ne bir anda gelir ne de gürültülüdür — ama kökten ve kalıcıdır.',
    'Ikizler':
        'Kiron İkizler burcundayken yaranın merkezi iletişim, zihin ve söz alanındadır. Söz söyleme korkusu, yanlış anlaşılma kaygısı ya da düşüncelerini yetersiz bulma bu hassas bölgenin görünür izleridir. Erken dönemde sesinin değersizleştirildiği, fikrinin ciddiye alınmadığı ya da ne söylersen söyle yanlış yorumlandığı deneyimler olmuş olabilir. Bu da zamanla sessizliği ya da sürekli kendini açıklama kaygısını doğurmuştur.\n\nBu yara aynı zamanda iyileşmenin kapısıdır. Zamanla kelimeleri bir şifa aracına dönüştürebilirsin — terapi, yazı, öğretme ya da sadece tam ve dürüst bir konuşma yoluyla. Sesini bulmak hem senin hem de dinleyenler için özgürleştiricidir; çünkü söyleyemediklerini söylemek için benzersiz bir kapasiten var.\n\nKiron İkizler\'de olanlar sıklıkla kelimelerle şifa veren insanlara dönüşür: danışman, yazar, öğretmen ya da sadece o an tam doğru şeyi söyleyen biri. Kendi zihnindeki yaraları tanıdıkça, başkalarının da sesini bulmasına yer açarsın.',
    'Yengec':
        'Kiron Yengeç burcundayken yaranın merkezi aidiyet, beslenme ve annelik arketipi alanındadır. Güvende hissetmek, gerçekten beslendiğini hissetmek ya da "ait olduğum bir yer var" demek derinden zorlu gelebilir. Erken dönemde duygusal ihtiyaçların karşılanmaması, bakım ilişkisindeki kırılmalar ya da "eve" döndüğünde bile evsiz hissetmek bu hassasiyetin kökenini oluşturur.\n\nGüvenli bir duygusal alan aramak hem en büyük acı noktası hem de en güçlü büyüme kapısıdır. Bu Kiron\'la çalışmak — içindeki çocuğa yeniden bir yuva bulmak demektir. Dışarıda bulamadığın güvenliği kendi içinde inşa etmek, bu yolculuğun en zorlu ve en dönüştürücü adımıdır.\n\nBu iyileşme gerçekleştiğinde, Yengeç Kiron\'lu bireyler başkaları için olağanüstü güvenli alanlar yaratma kapasitesine kavuşur. İçinde gerçek bir yuva inşa edildiğinde, başkalarına da ev olabilirsin — hem ailede hem toplulukta hem de anlık bir temas anında.',
    'Aslan':
        'Kiron Aslan burcundayken yaranın merkezi görünürlük, yaratıcı ifade ve öz değer alanındadır. Sahneye çıkmak, takdir görmek ya da "ben değerliyim" demek derinden ürkütücü gelebilir. Öz değer onay almadan inşa edilmek için can atar ama içeriden hep bir şüphe sesi yükselir: "Gerçekten yeterince iyi miyim? Görünmeyi hak ediyor muyum?"\n\nBu yara çoğu zaman erken dönemde yaratıcılığın küçümsenmesinden, sahneye çıkmaya verilen tepkilerden ya da koşulsuz takdir görmemekten beslenir. Zamanla kendi ışığı saklanmaya başlanır — ya aşırı performans ya da tam geri çekilme olarak tezahür edebilir. Her iki uç da aynı yaranın iki farklı yüzüdür.\n\nAma bu yara aynı zamanda büyük bir ilham kaynağına dönüşme potansiyeli taşır. Kendi yaratıcılığını kucaklamak, başkalarına da özgünlüklerini bulmalarını ilham verir. Aslan Kiron\'un en derin armağanı: ışığın fark edildiğinde ve sahiplenildiğinde dünyaya katabileceğin şeyin, herhangi bir performanstan çok daha değerli olduğudur.',
    'Basak':
        'Kiron Başak burcundayken yaranın merkezi mükemmeliyetçilik, bedensel yeterlilik ve hizmet alanındadır. "Yeterince iyi değilim", "bedenimi doğru kullanmıyorum" ya da "hata yapmamalıyım" gibi derin iç sesler bu hassasiyetin yüzeye çıkışıdır. Erken dönemde eleştirilmek, hizmetlerin yeterli bulunmaması ya da bedensel bir zorlukla başa çıkmak zorunda kalmak bu yaranın zeminini oluşturur.\n\nMükemmeliyetçilik hem kalkan hem de köstek işlevi görür: bir yandan seni güvenilir ve detaycı kılar, öte yandan hiçbir şeyin yeterince iyi olmaması hissiyle yorar. Öz şefkat ile titizlik arasındaki denge, bu Kiron\'un yaşam boyu süren temel egzersizidir. Her hatayı bir felaket olarak görmek yerine, onu bir bilgi olarak çerçevelemek bu dönüşümün kilididir.\n\nBu yara aynı zamanda şifalı hizmetin kapısını açar. Kendi mükemmeliyetçiliğinle öz şefkatle barıştığında ve "yeterince iyi" demesini öğrendiğinde; başkalarının da aynı baskıyı hissetmeden büyümesine yardımcı olan nadir bir şifacıya dönüşürsün.',
    'Terazi':
        'Kiron Terazi burcundayken yaranın merkezi ilişkiler, adalet ve gerçek bağlantı alanındadır. Gerçekten bağlanmak, eşit ve adil bir ilişkide tam anlamıyla var olmak ya da kendi ihtiyaçlarını bir ilişki içinde dile getirmek derinden zorlu gelebilir. Erken dönemde ilişkilerde dengesizlik, adaletsizlik ya da başkasının ihtiyaçları için kendinden vazgeçme kalıpları bu yaranın kökenini oluşturur.\n\nAdalet duygusunun bu kadar güçlü olması aynı zamanda en hassas noktası: haksızlık karşısında derin bir acı ve kendi payı için savaşmakta güçlük çekmek bu Kiron\'un iki yüzüdür. Gerçek denge, mükemmel bir partnerde değil; bilinçli bir seçim ve net bir sınırlama kapasitesinde yatar.\n\nBu yara, birlikte var olmanın ne anlama geldiğini derinlemesine araştırmanı sağlar. Zamanla ilişkilerde sağlıklı bir model inşa edersin — hem kendin için hem de başkaları için. Adaletli bir bağlantının nasıl hissettirdiğini keşfettiğinde, artık onu modellemek için gerçek bir kapasiten olmuş demektir.',
    'Akrep':
        'Kiron Akrep burcundayken yaranın merkezi güven, kayıp, ihanet ve derin dönüşüm alanındadır. İhanet, terk edilme ya da kontrolün elinden kayması bu hassas bölgenin tetikleyicileridir. Derinliği arayan bir ruh, tam da o derinliğin en ağır yüklerini taşımak zorunda kalmıştır — güvendikleri zarar vermiş, kaybettikleri yıkmış ya da görünmez güçler hayatın akışını değiştirmiştir.\n\nBu yara kişiyi ya tam yüzleşme ya da tam kaçınma yönüne iter: ya hayatının her karanlık köşesini bilen biri ya da her pahasına kontrolü elinde tutan biri. Gerçek iyileşme ise bu iki ucun arasında yer alır — ne koruyucu duvarlar ne de sınırsız şeffaflık; ancak bilinçli bir güven ile mümkün olan bir yakınlık.\n\nBu yara iyileştiğinde, en güçlü şifacılar ortaya çıkar. Karanlıkla dürüstçe yüzleşen, onu başkalarının da görebilmesi için ışığa çıkaran bir rehber olma kapasitesi bu Kiron\'un en derin armağanıdır. Kendi gölgeni tanıdıkça, başkalarının gölgesinde de kaybolmadan yürüyebilirsin.',
    'Yay':
        'Kiron Yay burcundayken yaranın merkezi inanç, anlam ve özgürlük alanındadır. "Neden buradayım?" sorusu hem en büyük acı noktası hem de en güçlü büyüme kapısıdır. Dogma ile anlamsızlık arasında sıkışmışlık hissi, ya inançlara körce sarılmak ya da hiçbir şeye inanamamak olarak kendini gösterebilir. Erken dönemde inanç sistemleriyle yaşanan travmalar, öğretilenlerin hayatı açıklamaması ya da anlamsızlık ortamında büyümek bu yaranın kökeninde olabilir.\n\nBu yara nihayetinde kendi inancını ve felsefeyi kendi deneyiminden yoğurma cesaretini doğurur. Başkasının verdiği cevaplar değil, kendi sorularınla oturmak — ve nihayetinde kendi tutumuyla yaşamak. Bu kolay değildir ama bir kez gerçekleştiğinde, hem en özgürleştirici hem de en sağlam bir yaşam zemini oluşur.\n\nBulduğun anlam hem senin şifandır hem de başkalarına yol gösteren bir meşaledir. Yay Kiron\'lu bireyler sıklıkla anlam arayışındaki insanlar için gerçek bir kılavuz haline gelir — dogmasız, ama derin; kurallar değil; yaşanmış bilgelik taşıyan biri olarak.',
    'Oglak':
        'Kiron Oğlak burcundayken yaranın merkezi otorite, başarı ve sosyal meşruiyet alanındadır. Yeterince başarılı olmamak, sisteme ait hissedememek ya da liderlik rolünde kendini meşru görmemek derin bir hassasiyet noktasını oluşturur. Erken dönemde yetki figürlerinden yeterli destek görmemek, prestijin koşulsuz sevilmekten önce geldiği bir ortamda büyümek ya da ağır sorumlulukların omuzlara erken yüklenmesi bu yaranın zeminini oluşturur.\n\nBaşarı ve tanınma için duyulan derin istek, zaman zaman hiçbir şeyin yeterli olmadığı bir iç sese dönüşür. Ya aşırı çalışarak kendini kanıtlama ya da sisteme olan güvensizlik nedeniyle çabalamamak — bu iki uç aynı yaranın farklı görünümleridir. Gerçek iyileşme ise korkudan değil, değerden gelen bir otorite anlayışı inşa etmekle mümkündür.\n\nBu yara, zamanla gerçek bir liderlik bilgeliğine dönüşür — ne güçten ne de korkudan değil, sahici sorumluluktan gelen bir lider anlayışı. Oğlak Kiron\'la şifaya kavuşanlar, sistemleri dışarıdan değil içeriden dönüştürür. Hem onurlu hem de insani bir otoriteyi mümkün kılar.',
    'Kova':
        'Kiron Kova burcundayken yaranın merkezi aidiyet, özgünlük ve topluluk alanındadır. "Gerçekten ait olduğum bir topluluk yok" ya da "tam olarak anlaşılmıyorum" hissi bu hassas noktanın yüzeyidir. Farklı olmanın yarattığı yalnızlık, özellikle erken dönemde, derin izler bırakmış olabilir. Grupla birlikte olmak ya eriyen bir benliği ya da sürekli tetikte kalmayı gerektirmiş olabilir.\n\nBu yara özgünlüğü hem en büyük güç hem de en büyük acı noktası haline getirir: tam senin olduğunu hissetsek de tam kabul görmemek, "anlaşılmıyor" hissini kronikleştirebilir. İyileşme, kendi özgünlüğünü utanç değil armağan olarak görmeye başladığında başlar. Herkes tarafından anlaşılmak değil; gerçekten anlayan birkaç kişiyle derin bir bağ kurmak bu Kiron\'un şifasıdır.\n\nBu yara aynı zamanda insanlığa olan sevginin kapısını açar. Kendi "ait olmama" deneyimini dönüştüren biri, toplumun kenarında kalan herkese köprü olur. Kova Kiron\'un en derin armağanı: farklılığını özgürce taşıyarak, benzer yükü taşıyanlara hem ilham hem de sığınak olmaktır.',
    'Balik':
        'Kiron Balık burcundayken yaranın merkezi sınır, kimlik ve ruhsal kayıp alanındadır. Sınırlar koymak, "hayır" demek ya da kendi ihtiyaçlarını öncelikli görmek derin bir suçluluk ya da çaresizlik hissiyle birlikte gelir. Başkalarının acısını engelleyememek ayrı bir ağırlık taşır; empati hem en büyük güç hem de en büyük yük haline gelmiştir.\n\nBu Kiron bazen kimlik sınırlarının belirsizleşmesine yol açar: nerede bitiyor, başkası nerede başlıyor? Bu bulanıklık hem sanatsal ve spiritüel bir armağan hem de egonun tam anlamıyla korunmaması gibi işleyebilir. İyileşme, empatiyi açık bir yara olarak değil, bilinçli olarak kullanılan bir araç olarak taşımayı öğrenmekle başlar.\n\nBu yara iyileştiğinde, empatiyi bir güç olarak kullanan nadir bir varlık ortaya çıkar — hem manevi hem pratik, hem şefkatli hem sınırlı. Balık Kiron\'un en derin armağanı: görünmezi görmek, söylenmeyeni duymak ve bunu başkalarına şifa vericek şekilde aktarabilmek.',
  },

  'Fortune': {
    'Koc':
        'Şans Noktası Koç burcundayken hayatındaki en derin tatmin ve bereket, girişim, cesaret ve inisiyatif dolu adımlar attığında açılır. Beklemek, planlamak ya da onay almak değil — harekete geçmek sana özgü bereket kapısıdır. Risk almayı seçtiğinde, güçlü bir kimlik duygusuyla ilerlediğinde ve "önce ben" diyebildiğinde bu noktanın enerjisi tam olarak akar.\n\nMaddi ve manevi bolluk için en verimli zeminler: öncü projeler, bağımsız girişimler, fiziksel aktivite, liderlik rolleri ve yeni başlangıçlar. Başkalarının nereye gittiğine bakma — sen ne zaman ilk adımı attın, işte bolluk orada başladı.\n\nKoç Şans Noktası\'nda bereketin sırrı, benliğini küçümsemeden ve savaşa girmeden, ama tam güçle yaşamaktır. Ne için savaşmaya değer bulduğunu bilmek — ve o uğurda tereddütsüz ilerleyebilmek — bu noktanın yüksek ifadesidir.',
    'Boga':
        'Şans Noktası Boğa burcundayken tatmin ve bereket, sabır, istikrar ve güzelliğe olan bağlılıkla açılır. Acele etmeden güzel şeyler biriktirmek, bedenine ve duyularına özen göstermek, değerlerinle uyumlu yaşamak bu noktanın bereketini besler. Koşuşturma içindeyken değil; oturup nefes alırken gelen sezgiler çoğu zaman en değerli yönlendirmeleri taşır.\n\nMaddi bolluk için en verimli zeminler: doğa, zanaat, estetik, finansal tutarlılık ve uzun vadeli yatırımlar. Hızlı kazanç değil; zaman içinde derinleşen ve kök salan şeyler bu Şans Noktasını gerçekten besler.\n\nBoğa Şans Noktasının derin mesajı: sahip olduklarının değerini görmek zaten bir bolluktur. Minnet ile başlayan bir bakış, dışarının da açılmasını sağlar. Kök salmak, hem harfî hem mecazî olarak, bu noktanın en bereketli eylemidir.',
    'Ikizler':
        'Şans Noktası İkizler burcundayken hayatındaki en derin tatmin ve bereket bilgi paylaştığında, bağlantı kurduğunda ve merakını izlediğinde gelir. Öğrenmek ile öğretmek arasındaki akış, okumak, yazmak, konuşmak ve fikirler arasında köprü kurmak bu Şans Noktasının en bereketli kanallarıdır.\n\nMaddi ve manevi bolluk için en verimli zeminler: iletişim meslekleri, eğitim, yazı, kısa yolculuklar, yerel ağlar ve birden fazla alanın kesişimi. Tek bir şeye hapsolmak değil; çok yönlü merakını aktif tutmak bu nokta için hayatî önem taşır.\n\nİkizler Şans Noktasının sırrı: "bilmek yeterlidir" değil, "paylaştıkça çoğalır." Fikirleri canlı tutmak, insanları birbirine bağlamak ve ortamındaki zihin ağını beslemek — bu eylemler hem sana hem çevrendeki dünyaya bolluk taşır.',
    'Yengec':
        'Şans Noktası Yengeç burcundayken tatmin ve bereket duygusal bağlar, aile duygusu ve gerçek bir "ev" hissiyle açılır. Başkalarını beslemek, güvenli bir alan yaratmak ve köklerinle temasın zengin duygusal dünyanda var olmak bu noktanın bereketini çoğaltır. Kendi duygusal gerçekliğinle dürüst temas kurmak, bereketin akışını hızlandıran en güçlü anahtarlardan biridir.\n\nMaddi ve manevi bolluk için en verimli zeminler: yuva, aile, besleyici ilişkiler, bakım meslekleri, yaratıcı projeler ve geçmişe derin bir saygı. Ev ortamına yatırım yapmak — hem fiziksel hem duygusal olarak — bu Şans Noktasının en doğrudan karşılığını bulduğu alandır.\n\nYengeç Şans Noktasının derin mesajı: gerçekten besleyebildiğin her an, hem sen hem de etrafındakiler için bereketin kaynağı olur. İçinde güvenli hissettiğinde, dışarısı da sana güvenli bir yer haline gelir.',
    'Aslan':
        'Şans Noktası Aslan burcundayken hayatındaki en derin tatmin ve bereket, özgün yaratıcılığını ifade ettiğinde ve kendini tam anlamıyla gösterdiğinde açılır. Sahneye çıkmak — hem gerçek anlamda hem de mecazî olarak — kalbinden gelen ışığı dışarıya yansıtmak ve bunu utanmadan yapmak bu noktanın bereketini serbest bırakır. Takdir görmek için değil; var olmanın sevinci için yaratmak bu Şans Noktasını en derin şekilde besler.\n\nMaddi ve manevi bolluk için en verimli zeminler: sanat, eğitim, çocuklarla çalışma, liderlik, sahne, eğlence ve her türlü yaratıcı ifade alanı. Kalbini koyduğun projelerde bereket, planladığından çok daha hızlı ve beklenmedik yollarla gelir.\n\nAslan Şans Noktasının sırrı: kendin olduğunda dünya seni çok daha kolay bulur. Rol yapmak değil, tam anlamıyla var olmak — işte bu noktanın bereket kapısını açan tek anahtar.',
    'Basak':
        'Şans Noktası Başak burcundayken tatmin ve bereket, hizmet aracılığıyla, uzmanlık geliştirerek ve günlük hayata düzen getirerek açılır. Gerçekten işe yarayan bir şey yapmak, bir sorunu çözmek, sağlığa yatırım yapmak ve bedenini onurlandırmak bu noktanın bereketini besler. Küçük ama tutarlı eylemler, beklenmedik büyük sonuçlar doğurur.\n\nMaddi ve manevi bolluk için en verimli zeminler: sağlık alanları, analiz, yazı, zanaat, verimlilik geliştirme ve başkalarına somut destek. Titizlik ve detay yeteneğin hem kariyer hem ilişki hem de kişisel büyüme için paha biçilmez bir kaynak haline gelir.\n\nBaşak Şans Noktasının derin mesajı: mükemmel değil, faydalı olmak yeterlidir. Her günkü küçük ritüeller ve bilinçli alışkanlıklar, zamanla hayatında kalıcı ve gerçek bir bolluk zemini oluşturur.',
    'Terazi':
        'Şans Noktası Terazi burcundayken hayatındaki en derin tatmin ve bereket gerçek ortaklıklar, dengeli ilişkiler ve estetik uyum yoluyla açılır. Hem alabildiğin hem verebildiğin işbirlikleri, güzelliği fark etmek ve paylaşmak, ve ilişkilerde adil bir denge kurmak bu noktanın bereketini çoğaltır.\n\nMaddi ve manevi bolluk için en verimli zeminler: sanat, tasarım, hukuk, danışmanlık, evlilik ve birebir ortaklıklar. Tek başına ilerlemek değil; gerçek bir ittifak içinde yürümek, hem başarıyı hem tatmini katlar. İlişkiye yatırım yapmak, bu Şans Noktasının en güçlü bereket kanallarından biridir.\n\nTerazi Şans Noktasının sırrı: hem verme hem alma kapasiteni açık tutmak. Sadece veren ya da sadece alan olmak bu noktanın enerjisini kısıtlar — gerçek denge her iki yönde de akış demektir.',
    'Akrep':
        'Şans Noktası Akrep burcundayken tatmin ve bereket, derin dönüşümler, ortak kaynaklar ve cesur içsel yolculuklar aracılığıyla açılır. Derinliğe atlamak, gizemi araştırmak, bırakmayı öğrenmek ve yaşamın sırlarını kurcalamak bu noktanın bereketli alanlarındandır. Yüzeyde kalmak, bu Şans Noktasına göre en büyük kısıtlamadır.\n\nMaddi ve manevi bolluk için en verimli zeminler: psikoloji, araştırma, miras, ortak finansal yapılar, derin ilişkiler ve mistik bilgi alanları. Başkalarıyla derin güven ortaklarına dönüşmek — hem duygusal hem maddi anlamda — bu noktanın bereketini gerçek anlamda aktive eder.\n\nAkrep Şans Noktasının derin mesajı: kontrolü bıraktığında kazanırsın. Tutunmak değil; derin güven ile harekete geçmek, korkuyu aşmak ve dönüşüme izin vermek — bu noktanın en zengin bereket akışını bu yollarla bulursun.',
    'Yay':
        'Şans Noktası Yay burcundayken hayatındaki en derin tatmin ve bereket anlam, seyahat ve büyük ufuklar yoluyla açılır. Farklı kültürlere açılmak, felsefeyi yaşamak, eğitimde derinleşmek ve bir inanca ya da büyük bir misyona sahip olmak bu noktanın bereketini besler. Dar düşünmek ve dar yaşamak bu Şans Noktasına en büyük engeli oluşturur.\n\nMaddi ve manevi bolluk için en verimli zeminler: yükseköğretim, yayıncılık, uzak seyahatler, öğretmenlik, felsefe ve dinlerarası diyalog. Bir dünya görüşünü başkalarıyla paylaşmak, ufku genişletmek ve ilham vermek — bu eylemler hem bereket hem de anlam getirir.\n\nYay Şans Noktasının sırrı: yaşamını büyük sorular etrafında örgülemek. "Neden buradayım?" sorusuna kendi cevabını bulmak ve onunla yaşamak — bu noktanın en kalıcı bereket biçimidir.',
    'Oglak':
        'Şans Noktası Oğlak burcundayken tatmin ve bereket, disiplinle inşa edilmiş kariyer ve uzun vadeli başarılar aracılığıyla açılır. Sabırla örgülmüş çaba, sorumluluğu sahiplenmek ve gerçekten değer inşa etmek bu noktanın bereketini zamanla ve kalıcı biçimde ortaya çıkarır. Kısa vadeli düşünmek, bu Şans Noktasına göre en büyük bereket engelidir.\n\nMaddi ve manevi bolluk için en verimli zeminler: yönetim, mühendislik, mimarlık, hukuk ve köklü kurumsal yapılar. Uzun vadeli hedeflere adanmak, güvenilir ve saygın bir isim inşa etmek ve her adımın bir öncekinin üzerine sağlamca oturmasını beklemek bu noktanın doğal ritmidir.\n\nOğlak Şans Noktasının derin mesajı: ekilmeden biçilmez. Ama bir kez gerçekten ekersen — tohumlar kalıcıdır. Başkaları bir sezon sonuçlarını aldığında, sen bıraktığın mirastan yıllar sonra beslenmeye devam edersin.',
    'Kova':
        'Şans Noktası Kova burcundayken hayatındaki en derin tatmin ve bereket topluluk, yenilik ve kolektif bir amaca katkı yoluyla açılır. İnsanlığa hizmet etmek, özgün bir bakış açısını dünyayla paylaşmak ve "insan" ölçeğinde düşünmek bu noktanın bereketini seslendirir. Sadece kişisel kazanım peşinde koşmak bu Şans Noktasını kısıtlar; kolektif anlam ise onu özgür bırakır.\n\nMaddi ve manevi bolluk için en verimli zeminler: teknoloji, aktivizm, sosyal girişimcilik, araştırma, kalabalık ağlar ve alışılmışın dışında meslekler. Başkalarının henüz görmediği bir şeyi görmek ve bunu cömertçe paylaşmak, hem sana hem dünyaya bereket getirir.\n\nKova Şans Noktasının sırrı: gelecek için düşünmek. Şimdiki neslin sorularını soran değil; henüz sorulmamış soruların içinde yürüyen biri olmak — bu noktanın en derin bereket biçimini taşır.',
    'Balik':
        'Şans Noktası Balık burcundayken tatmin ve bereket, derin empati, yaratıcı ifade ve ruhsal bağlılık yoluyla açılır. Sanata kendini vermek, şefkatle hizmet etmek, sezgine güvenmek ve görünmez dünyayla bağlantıda kalmak bu noktanın bereketini besler. Akılcılık ön plana çıktığında ve sezgi bastırıldığında bu Şans Noktası sesi kısılır.\n\nMaddi ve manevi bolluk için en verimli zeminler: sanat, müzik, terapi, spiritüel rehberlik, hastaneler, yardım kuruluşları ve deniz ile ilgili alanlar. Hayal gücüne ve içsel bilgeliğe alan açmak, bu noktanın en güçlü bereket kanallarından biridir.\n\nBalık Şans Noktasının derin mesajı: akışa teslim olmak, teslimiyetin ta kendisi değil — bilinçli bir tercih. Göremediğin ama hissettiğin şeylere güvenmek ve hayatını bu sezgiyle şekillendirmeye cesaret etmek, bu noktanın en derin armağanını açar.',
  },

  'Juno': {
    'Koc':
        'Juno Koç burcundayken ideal ortaklık enerjik, bağımsız ve cesur biriyle yaşanır. Seni körü körüne onaylayan değil; seni meydan okumaktan çekinmeyen, yanında duran ama kendi kişiliğinden ödün vermeyen biri seni tam anlamıyla doldurur. Bağımlılık değil; karşılıklı güçten doğan bir aşk arayışındasın.\n\nİlişkide seni küçülten değil; daha iyi biri olmaya iten birini beklersin. İki bağımsız bireyin seçimle bir arada olması, bu Juno\'nun idealidir. Biri olmak için birleşmek değil; zaten birisi olarak birleşmek.\n\nKoç Juno\'nun en zor dersi: bağlanmak güç değil, zayıflık olduğunu kabul edebilmek. Kırılganlığını bir ilişkide paylaşmak, seni daha az güçlü yapmaz — seni gerçek anlamda mevcut kılar.',
    'Boga':
        'Juno Boğa burcundayken ideal ortaklık güvenlik, sadakat ve duyusal bir bağ üzerine kurulur. Güvenilir, kalıcı ve fiziksel dünyayı seninle paylaşan — yemek, doğa, müzik veya sadece birlikte oturmak — bir partner en derin tatmini sağlar. İlişki bir sığınak gibi hissettirmek zorundadır; hem maddi hem duygusal anlamda güvenli bir zemin.\n\nHız, yoğun bir başlangıç ya da anlık tutkular bu Juno için yeterli değildir. Zaman içinde derinleşen, güven üzerine inşa edilen ve tutarlılığını kaybetmeyen bir bağ — gerçek ortaklığının tanımı burada yatar.\n\nBoğa Juno\'nun en zor dersi: statik bir konfor içinde kalmak ile sağlam bir zemin üzerinde büyümek arasındaki farkı yaşamak. İlişki hem güvenli hem de seni büyütebilir — bu ikisi birbirini dışlamaz.',
    'Ikizler':
        'Juno İkizler burcundayken ideal ortaklık entelektüel bağlantı ve sürekli bir zihinsel diyalog üzerine inşa edilir. Seninle düşünen, seni güldüren, farklı fikirler üreten ve zihni canlı tutan biri ideal partnerin profilidir. Sohbet bir ilişkinin çimentosudur; sessizlik bile anlam taşımalıdır.\n\nPartnerinden merak, esneklik ve çeşitlilik beklersin. Rutine teslim olan, düşüncelerini paylaşmayan ya da seni zihinsel olarak uyarmayan biri zamanla yük gibi hissettirmeye başlar. İki ilginç insanın birlikte ilginç bir hayat sürmesi — bu Juno\'nun aşk tanımıdır.\n\nİkizler Juno\'nun en zor dersi: derinlemesine bağlanmak, merakı öldürmez. Gerçekten tanınan biri olmak, keşfedilmeyi bekleyen birinden çok daha ilgi çekicidir.',
    'Yengec':
        'Juno Yengeç burcundayken ideal ortaklık derin duygusal güven, beslenme ve karşılıklı bakım üzerine kurulur. Seni gerçekten gören, içindeki çocuğu kabul eden ve birlikte bir yuva — hem fiziksel hem duygusal — inşa edebileceğin biri ideal partnerin özüdür.\n\nSoğuk, analitik ya da tutarsız duygusal varlığa sahip birinin bu Juno için gerçek bir tatmin yaratması güçtür. Seninle ağlayabilen, seninle gülebilen ve evde olmanın güvenliğini yaşatan biri — işte aradığın bağın özü budur.\n\nYengeç Juno\'nun en zor dersi: bakım almak verdiğin kadar önemlidir. Sadece besleyen değil; beslenmeye de izin veren biri olmak, gerçek bir ortaklığın temelini oluşturur.',
    'Aslan':
        'Juno Aslan burcundayken ideal ortaklık karşılıklı takdir, tutku ve yaratıcı alışveriş üzerine inşa edilir. Seni olduğun gibi gören, yaratıcılığına alan açan ve hem verebilen hem alabilen biri ideal partnerin profilidir. İlişkide sahne ışığı her iki tarafa da düşmelidir; biri her zaman arka planda kalamazsa denge bozulur.\n\nPartnerinden seni görünür kılmasını, seni onurlandırmasını ve seni coşkuyla karşılamasını beklersin. Ama sen de bunu ona verirsin — bu Juno paylaşılan ışıkla parlayan bir ilişki istiyor. Birinin şanının diğerini gölgelediği bir tablo bu Juno için gerçek bir aşk değildir.\n\nAslan Juno\'nun en zor dersi: takdir görmek için yaratmak yerine, birlikte bir şeyler yaratmanın tadını almak. İlişki bir izleyici kitlesi değil; ortak bir sahne olabilir.',
    'Basak':
        'Juno Başak burcundayken ideal ortaklık güvenilirlik, karşılıklı gelişim ve pratikte dürüstlük üzerine kurulur. Söz verdiğini yerine getiren, küçük ayrıntılara önem veren ve birlikte büyümek için çalışmaya razı biri ideal partnerinin özüdür. İlişkiyi sadece hissedilen bir şey olarak değil; inşa edilen bir şey olarak görürsün.\n\nDüzensiz, belirsiz ya da sorumsuz biri bu Juno için gerçek bir yakınlık zemini oluşturamaz. Günlük hayatta uyum, hem tutkuyu hem de güveni besler. Birlikte yaşamak, birlikte çalışmak ve birbirini geliştirmek bu Juno\'nun ideal tablodur.\n\nBaşak Juno\'nun en zor dersi: mükemmel partner yoktur. Büyüyen, çabalayan ve dürüst olan biri, kusursuz görünen birinden çok daha değerlidir.',
    'Terazi':
        'Juno Terazi burcundayken ideal ortaklık denge, adalet ve estetik uyum üzerine inşa edilir. Her iki tarafın da hem veren hem alan olduğu, uyumun çatışmadan değil bilinçli seçimden geldiği ve güzelliğin birlikte takdir edildiği bir ilişki bu Juno\'nun ideal tablosudur.\n\nPartnerinden dürüstlük, zarafet ve gerçek bir karşılıklılık beklersin. Dengesiz, sadece alan ya da söz hakkını tanımayan biri bu Juno için derin bir tatmin yaratamaz. İlişki hem adil hem güzel hem de akışkan olmalıdır.\n\nTerazi Juno\'nun en zor dersi: denge, anlaşmazlığı ortadan kaldırmak değildir. Gerçek bir birliktelikte her iki ses de duyulur — ve bu seslerin çatıştığı anlarda dahi ilişki ayakta durabilir.',
    'Akrep':
        'Juno Akrep burcundayken ideal ortaklık derin bağlılık, dürüstlük ve birlikte dönüşüm üzerine kurulur. Sırlarını taşıyabilen, seni görmekten korkmayan ve birlikte büyümek için derinlere dalmaya hazır olan biri ideal partnerindir. Yüzeysel ilişkiler bu Juno için doymayan bir açlık bırakır.\n\nPartnerinden hem yoğunluk hem de bağlılık beklersin. Kaçan, duygusal derinliği engelleyen ya da güven sorunlarını yüzeyde bırakan biri zamanla bu Juno için gerçek bir yakınlık zemini oluşturamaz. Kaybetme korkusunu bile birlikte taşıyabilmek, bu ilişkinin güzelliğidir.\n\nAkrep Juno\'nun en zor dersi: kontrolü bırakmak gücü kaybetmek değildir. Gerçek bir partnere güvenmek, savunmasız kalmayı değil; asıl gücünü bulmayı sağlar.',
    'Yay':
        'Juno Yay burcundayken ideal ortaklık ortak vizyon, özgürlük ve birlikte büyüme üzerine inşa edilir. Seni kısıtlamayan, farklı dünyaları seninle keşfeden, inançlarına saygı gösteren ve kendi ufkunu genişletmende sana eşlik eden biri ideal partnerin özüdür. İlişki seni daha küçük değil; daha büyük hissettirmelidir.\n\nYaşamı birlikte anlamlandırmak, ortak seyahat etmek — hem coğrafi hem felsefi olarak — ve birbirinin büyümesini desteklemek bu Juno\'nun ilişki dili. Kendi alanını daraltmak zorundalık gibi hissettiren bir tablo bu Juno için gerçek bir bağ değildir.\n\nYay Juno\'nun en zor dersi: bağlanmak özgürlüğü öldürmez. Seçilmiş bir bağlılık, onaylanmış değerler üzerine inşa edildiğinde en özgür hissiyatı verir.',
    'Oglak':
        'Juno Oğlak burcundayken ideal ortaklık kararlılık, uzun vadeli bağlılık ve ortak hedefler üzerine kurulur. Sorumluluğunu bilen, kariyer ve hayatı ciddiye alan ve yan yana inşa etmeyi seven biri ile ilişki en kalıcı ve doyurucu biçimini alır. İlişkiyi sadece romantizm olarak değil; bir ortak proje olarak da görebilirsin.\n\nPartnerinden güvenilirlik, tutarlılık ve uzun vadeli bir bakış açısı beklersin. Anlık tutku arzulayabilirsin; ama ilişkinin çimentosu sadakat, disiplin ve karşılıklı saygıdır. Yıllar sonra da yanında olacak, söz tutacak ve senin için çalışacak biri — bu Juno için gerçek bir bağın tanımıdır.\n\nOğlak Juno\'nun en zor dersi: kontrolü ve zamanı bırakmak. Aşk da her zaman planlı gelmez; bazen bitmemiş projelerin ortasında, hiç beklenmediğinde kapıyı çalar.',
    'Kova':
        'Juno Kova burcundayken ideal ortaklık özgürlük, entelektüel bağ ve özgünlük üzerine inşa edilir. Seni olduğun gibi kabul eden, alışılmamış bir ilişki modelini birlikte yazmaya açık olan ve bireyselliğini kısıtlamayan biriyle yaşam anlam kazanır. Geleneksel kalıpların içine sıkışmak bu Juno için gerçek bir tatmin değildir.\n\nPartnerinden hem özgürlük hem bağlılık — çelişkili gibi görünse de — bu Juno için bir arada var olabilir. Birbirini tam anlamasalar bile, birbirini tam anlamıyla görüyorlarsa bu ilişki güçlüdür. Zihinsel bir arkadaşlık, bu Juno için romantizmden daha kalıcı bir çimento işlevi görür.\n\nKova Juno\'nun en zor dersi: yakın olmak yabancılaşmayı gerektirmez. Gerçekten bağlı iki özgün insan, birbirlerini kaybetmeden birbirlerine ev olabilir.',
    'Balik':
        'Juno Balık burcundayken ideal ortaklık derin empati, şefkat ve ruhani bir birliktelik üzerine kurulur. Seni hisseden, ruhsal dünyanda seninle buluşan ve hem savunmasızlığını hem de gücünü taşıyabilen biri ideal partnerinin özüdür. Sadece akılcı, yüzeysel ya da duygusal derinlikten yoksun bir ilişki bu Juno için bir tür susuzluktur.\n\nGörünmezin görünür kıldığı bir bağ — rüyaları paylaşmak, sessizliklerde bile anlamak ve birbiri içinde kaybolmaksızın birbirinde erimek — bu Juno\'nun aşk dilidir. Manevi uyum, bu ilişkinin en güçlü çimentolarından biridir.\n\nBalık Juno\'nun en zor dersi: sınır koymak sevgisizlik değildir. İdeal bir partnerde hem yumuşaklık hem netlik, hem empati hem sınır arar — ve bunu önce kendin taşıdığında, karşına da aynı bütünlüğü taşıyan biri çıkar.',
  },

  'MC': {
    'Koc':
        'MC Noktası Koç burcundayken kariyer ve kamu kimliğin cesur, öncü ve liderlik odaklı bir enerjiyle şekillenir. Topluma yönelik en büyük katkın hareketi başlatmak, yeni yollar açmak ve diğerlerine cesaret vermektir. Girişimci ruhun, bağımsız kariyer yolları, rekabetçi alanlar ya da öncü projeler aracılığıyla en parlak ifadesini bulur. Başkalarının henüz denemediği şeyi ilk sen yaparken bulursun kendini.\n\nBaşarı senin için bir varış noktası değil; sürekli yenilenen bir başlangıç noktasıdır. Kariyer yolunda duraksamamak, risk almayı seçmek ve belirsizliğe rağmen ileri yürümek bu MC\'nin en doğal dışavurumlarıdır. Yetki figures ile gerilim yaşayabilirsin; çünkü kendi otoriteni kendin yazmak istersin.\n\nKoç MC\'nin en derin mesajı: kim olduğunu kanıtlamak için başkasının onayına ihtiyacın yok. Cesaretini bir yön olarak seçtiğinde — hem kariyer hem kamu kimliği olarak — dünya seni zaten karşılar.',
    'Boga':
        'MC Noktası Boğa burcundayken kariyer güvenlik, estetik ve uzun vadeli inşa üzerine şekillenir. Topluma en büyük katkın, kaliteli, kalıcı ve gerçekten değerli bir şey yaratmaktır. Sanat, müzik, finans, doğa ile ilgili alanlar, mimarlık, gıda ya da elle dokunulabilir güzellik yaratan her mes lek bu MC\'de ses bulur. Hız değil; derinlik ve kalite senin marka kimliğini oluşturur.\n\nSabır en güçlü kariyer stratejindir. Belki yavaş ama sağlam adımlar atarsın; inşa ettiğin şey uzun süre ayakta kalır. Güvenilir, tutarlı ve gerçekten iyi olan biri olarak tanınmak, bu MC için en asil kamu kimliğidir. Anlık başarılar değil; zamanla kökleşen saygınlık bu MC\'yi besler.\n\nBoğa MC\'nin en derin mesajı: değer, aceleyle gelmez. Senin zamanında, kendi temponda ve gerçek kalite standartlarında inşa ettiğin şey — hem sana hem topluma kalıcı bir armağan olur.',
    'Ikizler':
        'MC Noktası İkizler burcundayken kariyer iletişim, bilgi paylaşımı ve çok yönlülük üzerine inşa edilir. Yazarlık, gazetecilik, eğitim, medya, dijital iletişim, halkla ilişkiler ya da birden fazla alanı bağlayan pozisyonlar bu MC\'nin en parlak yollarındandır. Söz, ses ya da metin aracılığıyla fikirler üretmek ve yaymak kamuya açık kimliğinin temel gücüdür.\n\nTek bir kariyer yoluna hapsolmak bu MC için en büyük kısıtlamadır. Kariyer boyunca birden fazla alanda faaliyet göstermek, konular arasında köprü kurmak ve sürekli öğrenerek üretmek bu MC\'ye en doğal gelir. İletişim ağın kariyer sermayendir — kimlerle konuştuğun, kimlerle fikir alış verişi yaptığın, ürettiğin içerikler yıllarca çalışır.\n\nİkizler MC\'nin en derin mesajı: söylediğin şeyler, yaptığın şeylerden daha uzağa gider. Sesin dünyaya katkın, bu MC\'de en güçlü ve en kalıcı izdir.',
    'Yengec':
        'MC Noktası Yengeç burcundayken kariyer bakım, beslenme ve duygusal destek alanlarına yönelir. Psikoloji, hemşirelik, eğitim, sosyal hizmetler, çocuk gelişimi, konut, gıda ya da topluluk inşa etmek — hepsi bu MC\'de anlam kazanır. İnsanları güvende hissettiren ve karşılanmış duygusunu yaşatan bir alan içinde çalıştığında en canlı ve en verimli hâlini bulursun.\n\nKamu kimliğin sıcak, koruyucu ve besleyici bir aura taşır. İnsanlar sana hem profesyonel olarak hem de insan olarak güvenebileceklerini hisseder. Hangi pozisyonda olursan ol, çevrendeki insanlar için bir "güvenli zemin" yaratırsın — bu seni sıradan bir kariyer sahibinden ayıran özelliktir.\n\nYengeç MC\'nin en derin mesajı: kariyer zaman zaman seni annesi ya da babası gibi hissettirdiğinde, doğru yoldaki olduğunu bil. Gerçek liderlik burada: insanların büyümesine alan açmak.',
    'Aslan':
        'MC Noktası Aslan burcundayken kariyer yaratıcılık, liderlik ve kamuya görünürlük üzerine inşa edilir. Sanat, eğlence, eğitim, yönetim, koçluk, danışmanlık ya da ilham verici konuşmacılık bu MC\'de en parlak ifadesini bulur. Ne yaptığın kadar nasıl yaptığın da dikkat çeker; tarzın ve özgünlüğün kendisi bir değer taşır. Hem lider hem öğretmen hem de ilham kaynağı olma kapasitesi bu MC\'de bir arada var olur.\n\nKamu kimliğin etkileyici ve karizmatiktir; insanlar seni yalnızca ne yaptığın için değil, varlığın için de takip eder. Sahneye çıkmaktan çekinmemek, mesleğinde asli bir araçtır. Başkalarının görünürlüğünden çekinen değil; ışığından başkalarını aydınlatan biri olarak bilinmek bu MC\'nin yüksek ifadesidir.\n\nAslan MC\'nin en derin mesajı: gösteriş için değil, gerçek bir tutkuyla yaptığında kalabalıklar seni bulur. Karizman, sahte bir performans değil; içten gelen bir ısı — ve bu ısı uzaktan hissedilir.',
    'Basak':
        'MC Noktası Başak burcundayken kariyer hizmet, uzmanlık ve analitik zekanın bir arada kullanıldığı alanlarda anlam kazanır. Tıp, hukuk, araştırma, yazarlık, danışmanlık, veri analizi, sağlık hizmetleri ya da sistem geliştirme bu MC\'nin en bereketli alanlarıdır. Bir şeyi gerçekten iyi yapmak — yüzeyden değil, derinlemesine bilmek — bu MC\'nin kariyer felsefesidir.\n\nKamu kimliğin güvenilir, titiz ve pratiktir. İnsanlar sena gerçek bir uzmanlıkla yaklaşır; çünkü "bu kişi gerçekten biliyor" izlenimi senden kendiliğinden gelir. Herhangi bir göreve ya da karmaşıklığa sahip çıkma yeteneğin, kariyerinde kalıcı bir otorite inşa eder. Mükemmeliyetçilik burada güç değil; meslek aracı haline gelir.\n\nBaşak MC\'nin en derin mesajı: hizmet etmek, küçük görünmek değildir. Gerçek uzmanlıkla sunulan hizmet en büyük kamu katkısıdır ve zamanla seni hem saygın hem de ödüllendirilen biri kılar.',
    'Terazi':
        'MC Noktası Terazi burcundayken kariyer ilişkiler, adalet ve estetik üzerine şekillenir. Hukuk, tasarım, diplomasi, danışmanlık, moda, sanat yönetimi ya da insanlar arasında köprü kuran meslekler bu MC\'nin en parlak alanlarındandır. Güzellik ve denge yaratmak; hem ürünlerinde hem de süreçlerinde var olan bir kaygı olarak çalışır.\n\nKamu kimliğin zarif, adil ve uyumu temsil eden bir aura taşır. İnsanlar seni hem güvenilir hem de estetik açıdan ilham verici bulur. Gerilimli ortamları yatıştırma, farklı taraflar arasında ortak zemin bulma ve karmaşık ilişkileri yönetme yeteneğin, birçok kariyer alanında nadir ve değerli bir beceri haline gelir.\n\nTerazi MC\'nin en derin mesajı: güzelliği savunmak, yüzeysel değildir. Dünyanın daha adil, daha zarif ve daha dengeli olması için çalışmak — bu MC\'nin en asil kariyer motivasyonudur.',
    'Akrep':
        'MC Noktası Akrep burcundayken kariyer derinlik, araştırma ve dönüşüm alanlarında anlam kazanır. Psikoloji, dedektiflik, araştırmacı gazetecilik, cerrahi, finansal analiz, kriz yönetimi ya da perde arkasında güç dinamiklerini yöneten pozisyonlar bu MC\'nin bereketli alanlarındandır. Başkalarının görmediğini görmek, bu MC\'nin en keskin kariyer aracıdır.\n\nKamu kimliğin yoğun, gizemli ve derinlikli bir aura taşır. İnsanlar senin görmediklerini gördüğünü sezinler. Bu algı hem çekim hem de güç yaratır; seni kolay elde edilemeyen, ama ulaşıldığında son derece etkili biri yapar. Kariyer yolundaki büyük dönüşümler beklenmedik anlarda gelir — ve sen bu dönüşümlere hazırsın.\n\nAkrep MC\'nin en derin mesajı: gücünü gizlemek zorunda değilsin. Ama onu nasıl ve neden kullandığın — bu MC\'nin miras bıraktığı şeyi belirler.',
    'Yay':
        'MC Noktası Yay burcundayken kariyer anlam arayışı, eğitim ve kültürlerarası alanlarda anlam kazanır. Öğretmenlik, felsefe, hukuk, yayıncılık, seyahat sektörü, din ya da kültürel elçilik bu MC\'nin en bereketli alanlarındandır. Kamunun önüne çıktığında sadece bilgi aktarmaz; bir bakış açısı, bir vizyon ve bir anlam çerçevesi sunarsın.\n\nKamu kimliğin iyimser, ilham verici ve büyük ufukları temsil eden bir enerji taşır. İnsanlar sende sadece bir uzman değil; bir rehber ve hikaye anlatıcısı görür. Kariyer yolun boyunca öğrenmek ve büyümek, motivasyonun ana kaynağı olmaya devam eder — durağan ortamlar seni daraltır.\n\nYay MC\'nin en derin mesajı: kariyer senin için sadece bir pozisyon değil; bir misyon. İnsanları büyük resmi görmeye davet ettiğinde — hem onlar hem sen büyümüş olur.',
    'Oglak':
        'MC Noktası Oğlak burcundayken kariyer disiplin, uzun vadeli yapı inşası ve otorite üzerine şekillenir. Yönetim, mühendislik, hukuk, finans, mimarlık, siyaset ya da köklü kurumsal yapılar bu MC\'nin en verimli alanlarıdır. Sabırla, adım adım ve her zaman uzun vadeye bakarak inşa edersin — çabuk parlayan değil; zamanla silinmez iz bırakan biri olursun.\n\nKamu kimliğin ciddi, güvenilir ve otoriter bir aura taşır. Kariyer yolun erken dönemde yavaş ve zorlu ilerleyebilir; ama zamanla inşa ettiğin şey sağlamdır ve saygındır. Ağır sorumlulukları taşımak, zor kararlar almak ve otoriteni hak ederek kazanmak bu MC\'nin doğal ritmidir.\n\nOğlak MC\'nin en derin mesajı: zirve sahte değil, gerçekten hak edilmiş bir yer olacak. Sabırla inşa ettiğin kariyer bir gün hem sana hem gelecek nesile kalıcı bir miras bırakır.',
    'Kova':
        'MC Noktası Kova burcundayken kariyer yenilik, teknoloji ve toplumsal dönüşüm alanlarında anlam kazanır. Teknoloji, aktivizm, sosyal girişimcilik, fütürizm, araştırma, sivil toplum ya da alışılmadık yollarla dünyayı değiştirmeye çalışan her meslek bu MC\'nin en parlak alanlarındandır. İnsanlığın geleceğiyle ilgili bir şey yapıyorsan, doğru yoldaki.\n\nKamu kimliğin özgün, ilerici ve çağın ötesini gören bir aura taşır. İnsanlar sende bir düşünür, katalizör ve değişimin öncüsünü görür. Toplumun henüz tartışmaya başlamadığı konuları sen zaten ele almış, ya da alışılmadık çözümler üretiyor olursun. Bu seni öncü yapar — bazen erken, bazen yalnız, ama her zaman önemli.\n\nKova MC\'nin en derin mesajı: zamanın ötesinde düşünmek, şimdinin içinde yanlış görünebilir. Ama mirasın, zamanın kendisi tarafından anlaşılır.',
    'Balik':
        'MC Noktası Balık burcundayken kariyer sanat, şifa ve ruhaniyet alanlarında anlam kazanır. Sinema, müzik, dans, terapi, spiritüel rehberlik, sağlık hizmetleri ya da hayırseverlik odaklı kariyer alanları bu MC\'de gerçek bir tatmin ve etki yaratır. Görünmez olana ses vermek, bu MC\'nin en asil kariyer eylemlerinden biridir.\n\nKamu kimliğin yumuşak, sezgisel ve ilham veren bir aura taşır. İnsanlar sende ne yaptığından çok kim olduğunu görür — ve bu "olmak" hâlinin çekimi, kariyer alanında güçlü bir mıknatıs gibi çalışır. Derin empatin ve sezgisel anlayışın, başkalarının göremediği ihtiyaçları fark etmeni sağlar.\n\nBalık MC\'nin en derin mesajı: şifa işi hiçbir zaman tam anlamıyla kariyer gibi hissettirmez — çünkü hayatın kendisiyle iç içe geçmiştir. Ama dünyaya bıraktığın iz, ne dayanılmaz ne de silinebilir.',
  },
};

// ──────────────────────────────────────────────────────────────────────────────
// 2. Ev içerikleri: 12 ev
// ──────────────────────────────────────────────────────────────────────────────

const Map<int, String> houseContentMap = {
  1:
      '1. Ev — Benlik, Kimlik ve Dış Görünüş\n\n'
      'Doğum haritasının en kişisel noktası olan 1. ev, seni sen yapan özü ve dünyaya sunduğun ilk katmanı taşır. '
      'Yükselen burcun bu evin tam kapısında durur; nasıl yürüdüğünü, nasıl göründüğünü, bir odaya girdiğinde çevreye hangi enerjiyi yaydığını belirler. '
      'Bu sadece dış görünüş meselesi değildir — doğum anında ufkun üzerinde yükselen burç, ruhunun o bedeni seçişinin ilk izini taşır. '
      'Bedenin, duruşun ve genel sağlığın da 1. ev\'in görüş alanına girer; beden ile kimlik burada birdir.\n\n'
      'Bu evde gezegen bulunuyorsa, o gezegenin enerjisi doğrudan kişiliğine ve dışarıya yansıttığın imaja renk katar. '
      'Mars burada güçlü, dinamik ve rekabetçi bir varlık izlenim bırakır; Venüs zarif, çekici ve estetik duyarlı bir enerji taşır. '
      'Satürn ciddiyeti ve olgunluğu, Jüpiter ise neşe ve genişlemeyi ön plana çıkarır. '
      'Gezegen olmasa bile, 1. evi kaplayan burcun niteliği hayatın boyunca kimliğinin arka planı olarak çalışır.\n\n'
      'Kendinle ilgili yaptığın her içsel yolculuk bu evden kaynaklanır. '
      'Kendinle nasıl ilişki kurduğun, özgüveninin hangi koşullara bağlı olduğu ve dünyaya sunduğun maskenin arkasında gerçekte ne yattığı 1. ev\'den okunur. '
      'Bu evi derinlemesine tanımak, hayatın geri kalanını da düzene sokan bir ayna tutar sana.',

  2:
      '2. Ev — Kaynaklar, Değerler ve Öz Güven\n\n'
      '2. ev para ile başlar ama çok daha köklü bir soruya yanıt arar: "Benim için gerçekten değerli olan ne?" '
      'Sahip olduğun şeyler, para kazanma ve harcama biçimin, mülkiyet anlayışın ve en önemlisi — öz değer duygun bu evde barınır. '
      'Maddi güvenlik ihtiyacın ve bunu karşılama stratejin de 2. ev\'in sınırları içindedir. '
      'Bu ev, senin dünyayla kurduğun maddi sözleşmenin imzalandığı yerdir.\n\n'
      'Bu evdeki burç ve gezegenler maddi dünyayla ilişkini renklendirir. '
      'Boğa ya da Venüs etkisi konforu, dokunsal zevkleri ve güzelliği ön plana çıkarır. '
      'Akrep burcunun ya da Plüton\'un varlığı kaynakları dönüşüm, miras veya ortak varlıklar yoluyla deneyimlemeye işaret eder. '
      'Jüpiter burada maddi bereketle gelir ama aynı zamanda savurganlığa dikkat çeker; Satürn disiplinli bir bütçe ve çalışarak kazanma anlayışını işaret eder.\n\n'
      'Öz değerin yükseldikçe 2. evin maddi gerçekliği de berraklaşır — içindeki değer hissi, dışındaki kaynakları çeker. '
      'Bu evi ihmal etmek; parasız kalmak değil, kendi değerini küçümsemek demektir. '
      'Ne istediğini netleştiren, neye hayır diyebildiğinle ölçülen gerçek bir öz saygı geliştirmek 2. ev\'in ömür boyu süren çalışmasıdır.',

  3:
      '3. Ev — İletişim, Öğrenme ve Yakın Çevre\n\n'
      '3. ev zihnin, dilin ve sokak düzeyindeki bilginin evidir. '
      'İlk okul öğrenme deneyimi, kardeşlerle ilişki, komşuluk bağı, kısa yolculuklar, gündelik yazışmalar ve konuşmalar hepsi bu evin sınırları içinde şekillenir. '
      'Nasıl öğrendiğin, ne tür sorular sorduğun ve çevreni nasıl algıladığın 3. ev\'in diliyle yazılır. '
      'Bu ev, düşünceni harekete geçiren çevre ile senin arandaki köprüdür.\n\n'
      'Bu evde güçlü etkiler varsa; yazmak, konuşmak, öğretmek ya da öğrenmek hayatının merkezine girebilir. '
      'İkizler burcunun ve Merkür\'ün doğal evidir; hız, çok yönlülük ve merak bu ev için normdur. '
      'Merkür burada keskin bir zekayı işaret ederken Satürn derinliği ve methodikliği, Neptün ise sezgisel ve yaratıcı bir iletişim tarzını ortaya çıkarır. '
      'Kardeş ilişkilerindeki kalıplar da bu evden okunur — erken dönemde kurulan sibling dinamikleri iletişim biçimini şekillendirir.\n\n'
      'Düşüncelerini nasıl ifade ettiğin, bilgiyle nasıl ilişki kurduğun ve yakın çevrenle nasıl bağlandığın 3. ev hikayenden anlaşılır. '
      'Sözcükler hem senaristin hem de aracındır; bu evi geliştirmek, anlatma gücünü ve dünyayı yorumlama kapasiteni büyütmektir. '
      'Yazmaya, merak etmeye ve düşünceni dile getirmeye devam et — 3. ev\'de en çok bunlar büyütür.',

  4:
      '4. Ev — Kök, Aile ve Duygusal Temel\n\n'
      '4. ev haritanın tam tabanında, en derininde yer alır; köklerine, geçmişine ve duygusal temeline işaret eder. '
      'Büyüdüğün ortam, anne ya da birincil bakımveren figürüyle ilişkin, "yuva" kavramını nasıl hissettiğin ve iç dünyanda taşıdığın duygusal güvenlik hissi bu evde saklıdır. '
      'Ev dendiğinde içinde hangi duygu uyanır? O duygu 4. ev\'in sana yazdığı hikayedir. '
      'Bu ev aynı zamanda hayatın son dönemlerini ve mirasını — hem nereden geldiğini hem de geride ne bıraktığını — de kapsar.\n\n'
      'Güçlü 4. ev enerjisi derin bir aidiyet ihtiyacı doğurur; ev — hem fiziksel hem duygusal — bu kişiler için kutsal bir mekan haline gelir. '
      'Yengeç burcunun doğal evidir; Ay\'ın etkisiyle duygusal bellek, çocukluk anıları ve geçmiş bu evde yaşar. '
      'Satürn buradaysa aile sorumluluğu ağır gelebilir; Neptün ise idealize edilmiş ya da belirsiz bir aile geçmişine işaret eder. '
      'Plüton burada güç dinamiklerinin olduğu, dönüştürücü bir köken hikayesini anlatır.\n\n'
      'Hayatın hangi temeller üzerine inşa edildiğini, nereye ait hissettiğini ve geçmişinin bugününü nasıl biçimlendirdiğini anlamak için bu evi oku. '
      'Duygusal köklerini tanımak hem geçmişinle barışmanı hem de sağlam bir iç temel kurmanı sağlar. '
      '4. ev, gerçek güvenliğin dışarıda değil, içinde inşa edildiğini hatırlatan evdir.',

  5:
      '5. Ev — Yaratıcılık, Sevinç ve Romantizm\n\n'
      '5. ev oyunun, yaratıcılığın ve saf sevincin evidir. '
      'Çocuklarla ilişki, romantik ilişkilerin ilk filizlenme dönemi, sanatsal ifade, eğlence, oyun ve saf güzellik burada dans eder. '
      'Kendinle en özgür hissettiğin, dışarıya yansımak için değil salt var olmak için yarattığın anlar 5. ev\'in topraklarındadır. '
      'Bu ev aynı zamanda risk alma kapasiteni — hem maddi hem duygusal — de barındırır.\n\n'
      'Bu evde canlı gezegenler ya da Aslan izi varsa; ifade etmek, yaratmak, sevmek ve sevilmek hayatının en parlak noktaları olur. '
      'Aslan burcunun doğal evidir; güneş enerjisi ve sahnede yer alma arzusu burada doğal hissedilir. '
      'Venüs burada büyük bir estetik keyif ve flört enerjisi getirir; Mars tutku ve cesur romantizm; Jüpiter yaratıcılığı ve sevinci katlar. '
      'Çocuklara ve gençlere yönelik ilişkiler de bu ev üzerinden okunur — 5. ev dolu olan biri için bu ilişkiler son derece anlamlıdır.\n\n'
      'Kendinle oynadığında, yarattığın şeyi paylaştığında ve yaşamanın saf keyfine vardığında 5. ev aktive olur. '
      'Bu evi ihmal etmek hayatı renksizleştirmektir; bu evi beslemek ise seni yeniden doğurur. '
      'Büyük sorular sormayı bırak — ne seni güldürüyor, ne seni yaşatıyor? Oraya git.',

  6:
      '6. Ev — Günlük Hayat, Sağlık ve Hizmet\n\n'
      '6. ev rutinlerin, sağlık alışkanlıklarının, iş günlüğünün ve hizmet anlayışının evidir. '
      'Çalışma biçimin, beslenmene verdiğin önem, bedenini nasıl dinlediğin, hayvanlarla kurduğun ilişki ve küçük gündelik görevleri nasıl yerine getirdiğin — hepsi 6. ev senaryosunun parçasıdır. '
      'Bu ev, büyük yaşam hedeflerinin küçük günlük tuğlalarla nasıl örüldüğünü gösterir. '
      'Benliğini ifade ettiğin 5. ev\'den sonra 6. ev, o ifadenin hayatta kalabilmesi için gerekli disiplini öğretir.\n\n'
      'Başak burcunun doğal evidir; Merkür ve Chiron burada detaycılık, tahlil ve iyileşme süreçlerini yönetir. '
      'Kötü yönetilen 6. ev sağlık sorunları, tükenmişlik ve aşırı mükemmeliyetçilik kalıplarına dönüşebilir. '
      'Satürn burada sıkı bir iş disiplini ve sorumluluk anlayışı getirir; Neptün ise spirituel bir hizmet yönelimi ya da sınırları belirsiz çalışma koşulları ile kendini gösterir. '
      'Plüton buradaysa çalışma yaşamın köklü dönüşümlerle dolu olabilir.\n\n'
      'Bedenine ve rutinlerine özenle bakmak bu evin armağanını açar. '
      'Küçük ama tutarlı alışkanlıklar zamanla büyük sonuçlar doğurur; monoton görünen ritüeller aslında büyük hedeflerin tuğlalarıdır. '
      '6. evi anlamak, kendine karşı nazik ama disiplinli olmayı öğrenmektir — hem beden için hem ruh için.',

  7:
      '7. Ev — Ortaklıklar, İlişkiler ve Denge\n\n'
      '7. ev resmi ilişkilerin, evliliğin, birebir iş ortaklıklarının ve açık rekabetin evidir. '
      'Bu ev sadece kiminle birlikte olduğunu değil, ilişki içinde nasıl davrandığını, ne beklediğini ve ne verdiğini de anlatır. '
      'Yansıtma ve aynalama dinamiği burada güçlüdür: seçtiğin partnerler çoğu zaman haritanda bilinçsizce taşıdığın ama sahiplenmediğin parçalarını temsil eder. '
      'Bu nedenledir ki 7. ev en dürüst öğretmenlerden biridir.\n\n'
      'Terazi burcunun doğal evidir; karşılıklılık, adalet, uzlaşı ve denge bu evin temel sözcükleridir. '
      'Venüs burada uyumlu ve çekici ilişkiler getirir; Satürn sorumluluk ve ciddiyetle dolu ama bazen kısıtlayıcı ilişkiler; Mars ise tutkulu ama çatışmalı bağlar yaratır. '
      'Jüpiter burada harika genişletici partnerlikler için olumlu bir işaret taşır; Plüton ise dönüştürücü, derin ve yoğun ilişkileri simgeler. '
      'Ortaklığın salt romantik boyutuyla sınırlı kalmadığını unutma — yasal, ticari her iki taraflı sözleşme burada okunur.\n\n'
      'İlişkilerin sana ayna tutuyorsa 7. evi anla. '
      'Çünkü partnerlerde "dışarıda" gördüğün şey, içinde henüz bütünleştiremediğin bir parçandır. '
      'Bu evi çalışmak, sadece daha iyi ilişkiler değil — daha bütünleşik bir benlik inşa etmektir.',

  8:
      '8. Ev — Dönüşüm, Güç ve Derinlik\n\n'
      '8. ev haritanın en yoğun, en özel ve en dönüştürücü köşesidir. '
      'Ölüm ve yeniden doğuş temaları, ortak kaynaklar ve mali bağlar, miras, derin yakınlaşma, gizli bilgi ve ruhsal dönüşüm burada yaşanır. '
      'Bu ev seni "sahte ölümlere" — eski kimliklerden kopuş, ilişki bitişleri, köklü yaşam değişiklikleri — davet eder. '
      'Kolay değildir ama her dönüşüm bir öncekinden daha güçlü çıkmanı sağlar.\n\n'
      'Akrep burcunun doğal evidir; Plüton ve Mars bu evde güç dinamiklerini, sınır deneyimlerini ve köklü değişimleri yönetir. '
      'Plüton burada son derece güçlü etkiler bırakır — hayatın boyunca birden fazla köklü yeniden doğuş yaşayabilirsin. '
      'Neptün karanlık ile mistik arasındaki sınırı eritir; Chiron yaraların iyileştirici bir güce dönüştüğü bir süreç anlatır. '
      'Bu evdeki Ay duygusal yoğunluk ve sezgisel derinlik yaratırken Güneş burada bulunan kişiyi varoluşun gerçek doğasıyla yüzleşmeye davet eder.\n\n'
      'Bu evi anlamak kolay değildir ama ödülü çok büyüktür. '
      '8. ev\'i yüzeyden anlayan biri yüzeysel bir hayat yaşar; onu derinlemesine anlayan ise gerçek dönüşümün sırrına erer. '
      'Korkularının tam içine gir — 8. ev orada seni bekliyor.',

  9:
      '9. Ev — Felsefe, Keşif ve Anlam Arayışı\n\n'
      '9. ev büyük soruların, uzak yolculukların, yükseköğretim, inanç sistemleri ve evrensel hakikat arayışının evidir. '
      '"Neden buradayım?" ve "Hayatın anlamı ne?" soruları 9. ev\'in sorumluluğundadır. '
      'Yabancı kültürlerle temasın, dini ve spiritüel inançların, felsefi düşüncenin ve uzak seyahatlerin yarattığı ufuk genişlemesi burada yaşanır. '
      'Bu ev 3. ev\'in kardeşidir — 3. ev yerel ve günlük bilgiyle ilgilenirken 9. ev evrensel ve derinleştirilmiş anlayışla.\n\n'
      'Yay burcunun ve Jüpiter\'in doğal evidir; ufkunu genişletmek, farklı dünya görüşleriyle diyalog ve anlam bulmak burada merkezdedir. '
      'Jüpiter burada yüksek öğrenim, uzak seyahat ve kültürel zenginlikle dolu bir hayatı işaret eder. '
      'Satürn\'ün etkisi altında bu evi taşıyan biri inançlarını ciddi ve titiz bir araştırmayla şekillendirir; Neptün ise derin spritüel arayışlara ya da ideolojik yanılgılara yol açabilir. '
      'Uranus burada geleneksel din ve felsefeye meydan okuyan özgün bir dünya görüşünü ortaya koyar.\n\n'
      'Hayatının anlamını bulmak istiyorsan 9. eve bak — oraya seni ne çekiyorsa, seni en dolu hissettiren şey odur. '
      'Bir kitap, bir yolculuk, bir felsefe ya da sessiz bir meditasyon pratiği — 9. ev bunların hepsinde büyür. '
      'Büyük sorulardan korkma; bu ev onların içinde yüzdükçe seni derinleştirir.',

  10:
      '10. Ev — Kariyer, Kamu Kimliği ve Miras\n\n'
      '10. ev haritanın zirvesinde, tam tepesinde yer alır; topluma verdiğin katkıyı, kariyer yolunu, otorite figürleriyle ilişkini ve dünyada bırakmak istediğin izi taşır. '
      'Bu sadece mesleğinle değil — nasıl hatırlanmak istediğinle, hangi rolde insanlara yol gösterdiğinle ve kamuya açık kimliğinle ilgilidir. '
      'MC — Midheaven ya da Gökyüzü Ortası — bu evden okunur; doğum anında gökyüzünün tam zirvesinde ki nokta sana kamuya yönelik yüzünü gösterir.\n\n'
      'Oğlak burcunun ve Satürn\'ün doğal evidir; disiplin, uzun vadeli inşa, sorumluluk ve başarıya adanmışlık bu evin mihenk taşlarıdır. '
      'Jüpiter burada kariyer alanında büyük fırsatlar ve tanınan bir isim getirir; Mars hırs ve rekabetçi bir güdü; Neptün ise sanata, yardım mesleklerine ya da spiritüel alanlara yönelimi işaret edebilir. '
      'Güneş burada olduğunda kişi kamuoyunda parlak ve görünür olmaya meyillidir; Satürn ise başarının soluk ödüllerle ama kalıcı bir mirasla geleceğini söyler.\n\n'
      'Kamuya açık başarılar, kariyer seçimleri ve "nasıl hatırlanmak istiyorsun?" sorusunun cevabı bu evde gizlidir. '
      'Ama unutma — 10. ev\'in zaferleri, 4. ev\'in güçlü temelleri üzerine inşa edilir. '
      'Dışarıda ne kadar yükselmek istediğin, içeride ne kadar kök saldığınla doğru orantılıdır.',

  11:
      '11. Ev — Topluluk, Umutlar ve Gelecek Vizyonu\n\n'
      '11. ev arkadaşlıkların, kolektif hedeflerin, topluluk bağlarının, aktivizmin ve geleceğe yönelik umutların evidir. '
      '"Dünyayı nasıl daha iyi hale getirebilirim?" sorusu bu evde rezonans bulur. '
      'Bu ev kişisel kazanımları — 10. ev\'den gelenler — alır ve evrensele, kolektife doğru genişletir. '
      'Ait olduğun gruplar, paylaştığın davalara verdiğin destek ve insanlığa olan vizyonun burada yaşar.\n\n'
      'Kova burcunun ve Uranüs\'ün doğal evidir; özgünlük, toplumsal yenilik, devrimci düşünce ve kolektif değişim burada hak iddia eder. '
      'Jüpiter burada geniş, çeşitli ve zengin bir sosyal ağ getirir; Satürn seçici ama güvenilir ve uzun vadeli arkadaşlıkları temsil eder. '
      'Neptün idealist ama zaman zaman yanıltıcı sosyal çevrelere dikkat çeker; Plüton ise bağlı olduğun grupların gücünü ve dönüşümünü katlayabilir. '
      'Bu evdeki Ay arkadaşlıkları duygusal beslenmenin kaynağına dönüştürür.\n\n'
      'Tek başına ulaşamayacağın hedefler, 11. ev\'in ağı sayesinde mümkün olur. '
      'Bul, bağlan, büyü. Ama şunu da bil: kolektif içinde kaybolmadan kolektife katkı vermek bu evin en zor sanatıdır. '
      'Kendi vizyonunu koruyarak diğerleriyle aynı yöne yürümek — işte 11. ev\'in gerçek başarısı bu.',

  12:
      '12. Ev — Gizem, Bilinçdışı ve Ruhsal Derinlik\n\n'
      '12. ev görünmezin, sesizsizin ve kavranmazın evidir: gizlenmiş korkular, bastırılmış anılar, tekrar eden rüyalar, inziva anlarında bulunan güç ve mistik deneyimler burada barınır. '
      'Balık burcunun ve Neptün\'ün doğal evidir; bu ev neye göre yaşadığını değil, nasıl hissettiğini yönetir. '
      'Sınırların eridiği, bireyin evrenle buluştuğu o derin noktayı taşır. '
      'Bu nedenle 12. ev diğer tüm evlerin ötesinde, döngünün kapanış ve yeniden açılış noktasıdır.\n\n'
      'Bu evde güçlü gezegenler, kişiyi derin sorulara, manevi arayışlara ve iç dünyasının karanlık köşelerini keşfetmeye yöneltir. '
      '12. ev kötü değildir — sadece görünmeyenin dili burada konuşulur. '
      'Neptün burada sanatsal ilham, mistik sezgi ya da gerçeklikten kaçış eğilimini artırır. '
      'Satürn bu evde bilinçdışı korkuları ve geçmişten gelen kısıtlamaları açık eder; Plüton ise ayırt edilmez bir dönüşümü derinlemesine inşa eder. '
      'Chiron buradaysa iyileştirici gücün sessizlikte ve manevi bağlantıda saklı olduğunu anlatır.\n\n'
      'Sanatla, meditasyonla, içsel çalışmayla ya da yalnızlıkla geçirilen kaliteli zamanda 12. ev dolar. '
      'Bu evi ihmal etmek, bilinçdışının kontrolü ele alması anlamına gelir — kaçmaya çalıştıklarının seni yönetmesi gibi. '
      'Ama bu evi onurlandırmak; görünmezin içinde en derin özgürlüğü bulmaktır.',
};

// ──────────────────────────────────────────────────────────────────────────────
// 3. Açı içerikleri: açı türüne göre genel içerik
// ──────────────────────────────────────────────────────────────────────────────

const Map<String, String> aspectContentMap = {
  'conjunction':
      'Kavuşum Açısı — İki Güç Tek Noktada\n\n'
      'Kavuşum, iki gezegenin aynı noktada ya da birbirinden 0-8° uzaklıkta buluşmasıdır. '
      'Bu, haritanın en güçlü açılarından biridir; iki gezegenin enerjisi birleşir, pekişir ve neredeyse tek bir bilinç gibi işler. '
      'Kavuşumdaki gezegenler birbirinden ayrı hareket edemez — biri devreye girdiğinde diğeri de otomatik olarak aktive olur. '
      'Bu yoğun birlik bazen bir süper güç yaratır, bazen de kör nokta: ilgili alan o kadar içselleştirilmiştir ki dışarıdan görmek zorlaşır.\n\n'
      'Hangi gezegenlerin kavuştuğu bu açıyı iyileştirici ya da zorlu kılar. '
      'Güneş ile Merkür kavuşumu parlak bir iletişim zekası getirir; bu kişiler kelimeleri sezgisel olarak doğru kullanır. '
      'Ay ile Satürn kavuşumu ise duygusal kısıtlamalar, soğukluk ya da aşırı sorumluluk yüküyle gelir. '
      'Venüs ile Jüpiter kavuşumu sevinç ve bolluğu, Venüs ile Plüton ise derin ve sarsıcı aşk deneyimlerini işaret eder. '
      'Mars ile Uranüs kavuşumu ani patlamalar ve radikal cesaret; Neptün ile herhangi bir gezegen ise idealizasyon ve silikleşme riskini taşır.\n\n'
      'Haritanda hangi kavuşumun bulunduğunu bul ve o iki gezegenin enerjisini nasıl tek ses gibi dışa vurduğunu gözlemle. '
      'Hayatında hangi alanlarda aşırı yoğunluk yaşadığın, hangi konuların hiç sorgulamadan sana "olağan" geldiği — bu kavuşumun parmak izi taşır. '
      'Kavuşumu anlamak, içgüdülerinden birini bilince çıkarmaktır.',

  'sextile':
      'Altmışlık Açı — Kullanılmayı Bekleyen Fırsat\n\n'
      'Altmışlık açı (60°), iki gezegen arasında akıcı ama harekete geçirilmesi gereken bir potansiyeli simgeler. '
      'Üçgen açı gibi otomatik değildir — bir miktar bilinçli çaba olmadan bu enerji arka planda beklemeye devam eder. '
      'Ama aktive edildiğinde, üçgenden daha değerli olabilir çünkü emekle kazanılmışlığı taşır. '
      'Altmışlık açı, "sende var ama kullanmıyorsun" diyen bir astroloji mesajıdır.\n\n'
      'Bu açı genellikle farklı elementlerden iki burç arasında oluşur — Ateş ile Hava, ya da Toprak ile Su — ve bu da tamamlayıcı ama farklı enerjilerin işbirliğini gerektirir. '
      'Merkür ile Venüs altmışlığı güzel ve ikna edici bir iletişim yeteneği taşır; Mars ile Jüpiter altmışlığı hırsı motivasyonla birleştirir. '
      'Ay ile Merkür altmışlığı duygusal zekayı söze döküş kapasitesiyle harmanlar; Güneş ile Uranüs altmışlığı özgün kimlik ve yaratıcı isyan için verimli bir zemin yaratır. '
      'Bu açının olduğu alanlar "çalışılırsa açılır" başlığıyla işaretlenmiş alanlardır.\n\n'
      'Haritandaki altmışlık açılar sana hangi yeteneklerin uyuyakaldığını gösterir. '
      'Bu potansiyeli harekete geçirmek için kasıtlı adımlar atmak gerekir — bir ders, bir pratik, bir adım. '
      'Fırsatlar kapıda beklemiyor; senin kapıyı açmana bakıyor.',

  'square':
      'Kare Açı — Büyümenin Sürtünmesi\n\n'
      'Kare açı (90°), iki gezegen arasında gerilim, çatışma ve içsel sürtünme yaratır. '
      'Bu açı haritanın en dürüst seslerinden biridir; seni zorlayan, duraksatan ve büyümek zorunda bırakan alanları işaret eder. '
      'Kare açıdaki iki gezegen birbirini engeller gibi görünür; ama aslında her ikisi de farklı yönlerden aynı anda harekete geçmek ister. '
      'Bu içsel çatışma, fark edildiğinde ve çalışıldığında en büyük güç kaynağına dönüşür.\n\n'
      'Kare açılar kolayca çözülmez; bunlar zaman, bilinçli çalışma ve tekrar eden sürtünmeyle dönüştürülür. '
      'Mars ile Satürn karesi hırs ile kısıtlama arasındaki gerilimi yaşatır; enerji var ama bir kapı yok gibi hissedilir — ta ki disiplin ve sabır devreye girene kadar. '
      'Güneş ile Ay karesi benlik ile duygusal ihtiyaçlar arasındaki içsel çatışmayı, Merkür ile Neptün karesi ise rasyonel düşünce ile sezgi arasındaki gidip gelmeyi yaratır. '
      'Venüs ile Plüton karesi ilişkilerde yoğunluk ve güç mücadelesi; Jüpiter ile Satürn karesi büyüme ile kontrol arasındaki klasik gerilimi simgeler.\n\n'
      'Haritanın en büyük başarı hikayelerini çoğu zaman kare açılar yazmıştır. '
      'Zorluk seni öldürmez — seni ne olduğunu öğretir. '
      'Kare açını kabul et, onunla kavga etme; o enerjiyi kanallamayı öğrendikçe en büyük özelliğine dönüşür.',

  'trine':
      'Üçgen Açı — Doğal Akış ve İçsel Armağan\n\n'
      'Üçgen açı (120°), iki gezegen arasındaki en akıcı ve uyumlu bağlantıdır. '
      'Bu açıda iki gezegen genellikle aynı elementten iki burçta bulunur — ateş ile ateş, toprak ile toprak gibi — ve bu da ortak bir doğa dili konuştuklarını gösterir. '
      'Enerjiler birbirini kolayca destekler; herhangi bir çaba gerekmeksizin yetenekler açılır, akışlar kurulur. '
      'Üçgen açı, haritanın "bu sende zaten var" dediği alandır.\n\n'
      'Güneş ile Jüpiter üçgeni özgüven ve bereket hissini neredeyse doğal kılar; bu kişiler hayatın genellikle yanlarında olduğunu hisseder. '
      'Ay ile Neptün üçgeni sezgiyi ve empatiyi eforsuzca çalıştırır; Merkür ile Satürn üçgeni derin ve titiz düşünceyi; Venus ile Ay üçgeni ise nazikliği ve duygusal uyumu hayata geçirir. '
      'Mars ile Jüpiter üçgeni fiziksel enerji ile cesaret arasında güzel bir koordinasyon yaratır. '
      'Ancak üçgen açının tuzağı tam da burada gizlidir: çok kolay geldiği için geliştirilmeden, test edilmeden bırakılabilir.\n\n'
      'Bu açı bir armağandır — ama armağanlar kullanılmazsa solar. '
      'Üçgen açının bulunduğu alanda kendini zorlamak, kapasitenin gerçek boyutunu keşfettirir. '
      'Doğal olarak gelen şeyi bilinçle büyütmek, üçgen açının tam potansiyelini açar.',

  'opposition':
      'Karşıtlık Açısı — Ayna, Denge ve Entegrasyon\n\n'
      'Karşıtlık açısı (180°), tam karşı kutuplarda duran iki gezegenin birbirini yüzleştirdiği en dramatik gerilimdir. '
      'Bu açı içsel bölünmeyi temsil eder: iki farklı ihtiyaç, iki farklı dürtü, aynı anda doyurulmayı bekler. '
      'Çoğu zaman bu gerilim dışa yansır — karşıtlık açısı ilişkilerde, partnerlik dinamiklerinde ve karşımıza çıkan insanlarda belirgin biçimde tezahür eder. '
      '"Onda neden beni bu kadar rahatsız eden şey var?" sorusu genellikle bir karşıtlık açısının sesidir.\n\n'
      'Güneş ile Ay karşıtlığı bilinçli benlik ile duygusal ihtiyaçlar arasındaki bölünme hissi yaratır; bu kişiler ne kendileri için ne başkaları için olmak arasında gidip gelir. '
      'Venüs ile Mars karşıtlığı çekim ile çatışma arasında sürekli salınım; Jüpiter ile Satürn karşıtlığı özgürlük ile sorumluluk; Merkür ile Jüpiter ise detay ile büyük resim gerilimini yaşatır. '
      'Güneş ile Neptün karşıtlığı kimliği sisler içinde eritir; Ay ile Satürn ise duyguları bastırı soğuklukla örter. '
      'Bu gerilimler yok sayıldığında dışa yansır — fark edildiğinde ise içsel entegrasyonun hammaddesi olur.\n\n'
      'Karşıtlık açınla barışmak, hayatındaki zıtlıklara sahip çıkmak demektir. '
      'İki ucun birbirini dışlamadığını, birbirini tamamladığını gördüğünde bu açı haritanın en değerli denge noktalarından birine dönüşür. '
      'Bütünleşme yolunu gösteren denge, zıtlık açısının gerçek armağanıdır.',
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
      ? 'Üç burcun da $elem1 elementinde olması bu kombinasyona nadir bir yoğunluk ve odak katar. '
            'Hayatın büyük bölümünde bu elementin gücü belirleyici rol oynar; aynı zamanda zaman zaman dengelemek için zıt elementlere ihtiyaç duyarsın.'
      : 'Güneşin $elem1, Ayın $elem2 ve Yükselenin $elem3 elementini taşıması '
            'seni içten zengin ama bazen çelişkili bir kişi yapar. '
            'Bu üç farklı enerji hem yaratıcı bir gerilim hem de olağanüstü bir esneklik kaynağıdır.';

  return 'Güneş $sunDisplay · Ay $moonDisplay · Yükselen $ascDisplay\n\n'
      '$elemNote\n\n'
      'Güneş $sunDisplay kimliğinin çekirdeğini oluşturur: ${_sunEssence(sunSign)}\n\n'
      'Ay $moonDisplay duygusal iç dünyanı şekillendirir: ${_moonEssence(moonSign)}\n\n'
      'Yükselen $ascDisplay dışarıya verdiğin ilk izlenimi çizer: ${_ascEssence(ascSign)}\n\n'
      'Bu üç enerji birlikte çalışır; bazen uyum içinde, bazen yaratıcı bir gerilimle. '
      'Güneş seni kim olacağın konusunda; Ay seni ne hissettiğin konusunda; Yükselen ise seni başkalarının gözünde kim olduğun konusunda şekillendirir. '
      'Bu üç katmanı anlamak, hem kendini hem de başkalarıyla ilişkini çok daha net görmenin anahtarıdır. '
      'Haritanın geri kalanını keşfederek bu enerjilerin hayatında nasıl dans ettiğini ve birbirini nasıl tamamladığını görebilirsin.';
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
    'Koc':
        'cesaret ve direkt hareket senin varoluş biçimindir. İlk olmak, lider olmak ve sınırları zorlamak için doğuştan bir dürtü taşırsın. En iyi versiyonun, sabırsızlığını stratejik bir harekete dönüştürdüğünde ortaya çıkar.',
    'Boga':
        'güzellik, güvenlik ve kalıcı değerler üzerine inşa edilmiş bir kimlik taşırsın. Maddi ve duygusal istikrar seni besler. Değer verdiğin şeylere sarsılmaz bir bağlılık gösterirsin; en derin gücün ise sabır ve kararlılığındadır.',
    'Ikizler':
        'zihinsel merak ve iletişim senin kimliğinin bel kemiğini oluşturur. Çok yönlülük bir servet; eksik olan ise derinlik. En büyük versiyonun, genişliğini seçilmiş bir alanda odaklandırdığında belirir.',
    'Yengec':
        'duygusal bağlar, koruma güdüsü ve derin bellek ile kimliğini tanımlarsın. Sevdiklerini beslemek ve korumak en doğal eylemlerinden biridir. En güçlü anın ise hem sevmenin hem de sınır koymanın mümkün olduğunu keşfettiğin andır.',
    'Aslan':
        'yaratıcılık ve içten gelen ışık senin özündedir. Sahneye çıkmak, ilham vermek ve sevdiklerine liderlik etmek doğal eğilimlerdir. En büyük gücün, o ışığı onaylanmak için değil; seve seve yaydığında ortaya çıkar.',
    'Basak':
        'analiz, hizmet ve iyileştirme arzusuyla anlam bulursun. Dünyayı daha iyi hale getirmek hem amacın hem de tatmin kaynağındır. Mükemmeliyetçiliğini öz şefkatle dengelediğinde gerçek ustalığa ulaşırsın.',
    'Terazi':
        'denge, adalet ve ilişkilerin zengin dokusuyla var olursun. Başkaları var olduğunda sen de daha tam hissedersin. En derin büyümen, kendi kimliğini kaybetmeden gerçek ortaklık kurduğunda yaşanır.',
    'Akrep':
        'derinlik, dönüşüm ve güç arayışıyla kimliğine kök atarsın. Sıradan yaşamın altında akan gerçeği görürsün. En güçlü anın, o derinliği inşa etmek için değil; iyileştirmek için kullandığında gelir.',
    'Yay':
        'anlam, macera ve vizyon peşinden giderek var olursun. Ufku daraltan her şey seni kısıtlar. En büyük büyümen, geniş vizyonu somut hedeflere dönüştürme cesaretini bulduğunda gerçekleşir.',
    'Oglak':
        'disiplin, uzun vadeli inşa ve sorumlulukla kendin olursun. Kararlılık ve dayanıklılık seni tanımlayan özelliklerdir. Sertliğini öz şefkatle yumuşattığında hem daha insani hem de daha güçlü bir lider olursun.',
    'Kova':
        'özgünlük, kolektif vizyon ve sıradan kalıpları yıkarak kendini tanımlarsın. Geleceği görmek, kural kırmak ve kimliğini özgürce ifade etmek temel ihtiyaçlarındır. En büyük gücün, bu özgünlüğü birleştirici bir kuvvete dönüştürdüğünde açığa çıkar.',
    'Balik':
        'empati, sezgi ve sınırların ötesindeki bağlantıyla var olursun. Başkalarının acısını ve sevincini içinde taşıma kapasitenle benzersizsin. En güçlü anın, bu derin duyarlılığı kendini yitirmeden yaşadığında gelir.',
  };
  return map[sign] ??
      'kendine özgü, derin ve benzersiz bir enerjiyle var olursun.';
}

String _moonEssence(String sign) {
  const map = {
    'Koc':
        'anlık, yoğun hisler ve eylemle duygusal tatmin ararsin. Beklemek duygusal hayal kırıklığına yol açabilir; harekete geçmek seni rahatlatır. Öfkeyi hızlı yaşar, hızlı bırakır; bu dürüstlük ama zaman zaman kontrolsüzleştirilmesi gerekir.',
    'Boga':
        'istikrar, dokunsal konfor ve güvenli bağlarla içten beslenirsin. Rutinleri sevmek zayıflık değil; sağlam bir temel ihtiyacının göstergesidir. Değişim ve belirsizlik duygusal dengesini sarsabilir; güven yavaş oluşur ama bir kez kurulunca derindir.',
    'Ikizler':
        'zihinsel uyarı, sohbet ve çeşitlilikle duygusal dünyanda dengeyi bulursun. Sıkılmak seni negatif kılar; yeni bilgi ve bağlantılar seni canlandırır. Duyguları kelimelerle ifade etmek senin için rahatlatıcıdır; sustuğunda biriken gerilimi not al.',
    'Yengec':
        'aidiyet, yuva ve derin duygusal bağlarla tatmin olursun. Güvende hissettiğinde açılırsın; tehdit altında içe çekilirsin. Belleğin güçlü ve duygusal tarihin yoğundur; duygusal izleri uzun süre taşırsın — bunların çözülmesine izin vermek iyileşmenin anahtarıdır.',
    'Aslan':
        'takdir görmek, yaratmak ve tam anlamıyla sevilmekle duygusal olarak dolarsin. Görmezden gelinmek en derin yaralarından birini açar. Sevgini coşkuyla verirsin; karşılıklı onur ve saygı bu sevginin sürmesinin temelidir.',
    'Basak':
        'yararlı olmak, düzenlemek ve bir sisteme katkı sunmakla iç huzurunu bulursun. Kaos seni rahatsız eder; bir çözüm üretmek seni sakinleştirir. Öz eleştiri en yakın gölgen; iç sesin ne söylediğine dikkat et, o ses bazen çok serttir.',
    'Terazi':
        'uyum, adalet ve gerçek bağlantıyla duygusal denge kurarsın. Çatışma seni tüketir; barışçıl ilişkiler seni besler. Kendi ihtiyaçlarını başkalarının ihtiyaçları kadar öncelikli görmek, bu Ayın olgunluk derslerinden biridir.',
    'Akrep':
        'derin güven, yoğun bağlar ve dönüşümle beslenirsun. Yüzeysel ilişkiler duygusal tatmin sağlamaz; derine gitmeden bağlanamazsın. Korku ile güven arasındaki gerilim süreklidir — güveni adım adım seçmek, bu Ayın en güçlü büyüme yoludur.',
    'Yay':
        'özgürlük, anlam ve keşifle duygusal olarak canlanırsın. Sıkışmak, rutin olmak ya da anlamsız bir yerde durmak duygusal çöküşe yol açabilir. Hem özgür olmak hem de derin bir bağlılık içinde olmak istiyorsun; bu dengeyi bulmak senin özel yolculuğun.',
    'Oglak':
        'kontrol, sorumluluk ve somut başarıyla duygusal güvenlik inşa edersin. Duygularını ifade etmek zor gelebilir; bunun yerine eylem yoluyla ilgiyi gösterirsin. Başarı duygusal tatmin sağlar; ama yalnızca başarı yoluyla sevilmek yeterli değildir — bu fark kritiktir.',
    'Kova':
        'bağımsızlık, entelektüel bağlantı ve özgünlükle duygusal alanını korursun. Yakınlık ile mesafe arasındaki denge hassastır; çok yakınlaştığında kaçınma içgüdüsü devreye girebilir. Gerçek yakınlık kırılganlık gerektirir — bu en büyük ama en verimli duygusal dersindir.',
    'Balik':
        'ruhaniyet, empati ve yaratıcılıkla duygusal dünyana derin bir anlam katarsın. Başkalarının hislerini çok kolayca içine alırsın; bu seni hem güçlü hem savunmasız yapar. Sınır çizmek sevilmemek değil; tam tersine daha sağlıklı sevilmek için zemin hazırlamaktır.',
  };
  return map[sign] ?? 'kendine özgü ve derin bir his dünyası taşırsın.';
}

String _ascEssence(String sign) {
  const map = {
    'Koc':
        'enerjik, direkt ve harekete hazır görünürsün. İlk izlenim güçlü ve kendinden emin; insanlar seni lider figürü olarak sezebilir. Enerji dolu vücudun ve keskin bakışın seni tanımlayan fiziksel özellikler.',
    'Boga':
        'sakin, güvenilir ve estetik bir izlenim verirsin. İnsanlara güven ve konfor hissettirirsin; fiziksel görünümünde çekicilik ve doğal bir çekicilik dikkat çeker. Yavaş ısınırsın ama bir kez yakınlaştın mı sıcağın kalıcıdır.',
    'Ikizler':
        'meraklı, canlı ve iletişime açık bir aura yayarsın. Çevre koşullara hızlı uyum sağlarsın; ellerinin ve yüzünün hareketliliği dikkat çeker. İnsanlar seni ilk bakışta akıllı ve eğlenceli bulur.',
    'Yengec':
        'yumuşak, koruyucu ve içten bir ilk izlenim bırakırsın. İnsanlar yanında güvende hisseder. Göz temasın derin ve sezgiseldir; yüzün duygu değişimlerini net biçimde yansıtır. Kişileri tanıyana kadar içe dönük görünebilirsin.',
    'Aslan':
        'karizmatik, ısıtıcı ve unutulmaz bir varlık olarak odaya girersin. Duruşun belirgin, tarzın özenli ve ifaden görkemlidir. İnsanlar seni fark eder; aslında sen fark edilmek için oradasın gibi bir his bırakırsın çevrendeki herkeste.',
    'Basak':
        'titiz, erişilebilir ve pratik bir dışsal kimlik sunarsın. Sağlıklı, düzenli ve özenle hazırlanmış bir görünüm çoğunlukla dikkat çeker. Analitik bakışın ve dikkatli dinleyişin insanlara güven verir.',
    'Terazi':
        'zarif, uyumlu ve bağ kurmaya açık görünürsün. Estetik bir çekicilik ve hoş bir aura seni ilk izlenimde olumlu kılar. İnsanlar seninle konuşmaya çekilir; ortama uyum sağlama becerinle pek çok ortamda hızla kabul görürsün.',
    'Akrep':
        'yoğun, gizemli ve derinlikli bir izlenim bırakırsın. Bakışların insanların içine işler; gizem ve çekim seni çevreleyen görünmez bir enerjidir. İnsanlar seni çekici bulur ama tam olarak anlaşılamadığın hissini de verir.',
    'Yay':
        'iyimser, özgür ruhlu ve maceracı bir enerji yayarsın. Geniş sırtlı ve açık jestli fiziksel bir aura; sesinin ayak seslerinde bile bir enerji vardır. İnsanlar seni dinlemeye çekilir çünkü anlattıkların her zaman daha büyük bir hikayenin parçası gibi hissettirir.',
    'Oglak':
        'ciddi, güvenilir ve otoriter bir izlenim verirsin. Erken yaşlardan itibaren yaşından büyük görünme eğilimin olabilir. Zaman içinde daha serbest ve enerjiyle dolarsın; bu Yükselen zamanla gençleşir gibidir. Sorumlu duruşun güven telkin eder.',
    'Kova':
        'alışılmadık, özgün ve ilerici bir profil çizersin. Tarzın ve ifade biçimin başkalarından farklıdır; bu farklılık dikkat çeker, merak uyandırır. İnsanlar seni modernin ötesinde bir yerde konumlandırır; geleceğin sesini duyururmuşsun gibi görünürsün.',
    'Balik':
        'yumuşak, sezgisel ve kaçamak bir aura yayarsın. Gözlerin büyük ve derin; bakışın uzaklara dalmış gibi hissedilebilir. İnsanlar bir enerji çekimi ve şefkat hisseder; zaman zaman ne düşündüğünü tahmin edemezler ama yanında huzurlu hissederler.',
  };
  return map[sign] ?? 'özgün ve akılda kalan bir ilk izlenim bırakırsın.';
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
