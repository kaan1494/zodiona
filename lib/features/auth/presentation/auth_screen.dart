import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../models/app_user.dart';
import '../../../services/auth_service.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../home/presentation/home_screen.dart';

const String _policyContent = '''
Kişisel Verilerin Korunmasına İlişkin Sözleşme
Son Güncelleme: 14 Mart 2025

Zodiona, kişisel bilgilerinizi üçüncü taraflara satmaz veya doğrudan pazarlama amaçları için üçüncü taraflara kişisel bilgilerinizi açıklamaz. Zodiona ("Zodiona", "şirket", "biz", "bize" ve "bizim") sizinle paylaştığınız kişisel bilgileri korumak için taahhütte bulunmuştur. Bu gizlilik politikası ("Gizlilik Politikası"), Zodiona'nın kişisel bilgilerinizi nasıl toplayabileceğini, depolayabileceğini, kullanabileceğini ve konumlandırabileceğini açıklar. Bu Gizlilik Politikası, mobil uygulamalarımız ("Uygulamalar"), web sitemiz web sitelerimiz ("Web Siteleri"), hizmetlerimiz ("Hizmetler") ve kurumsal faaliyetlerimiz için geçerlidir. Bize bilgi sağlayarak (Web Sitemiz, Uygulamalarımız, Hizmetlerimiz veya başka şekillerde), bu Gizlilik Politikası'nda tarif edildiği gibi bilgilerinizin toplanmasına, depolanmasına, kullanılmasına ve açıklanmasına izin verirsiniz.

Sizden edindiğimiz bilgiler
Kişisel bilgilerinizi isteğe bağlı olarak bize sağladığınızda veya belirli bilgiler sizden otomatik olarak toplanır. Servislerimiz hakkında bilgi almak, Servislerimize kaydolmak, iş başvurusunda bulunmak veya danışman olmak veya soru sormak gibi çeşitli nedenlerle bilgilerinizi bize sağlayabilirsiniz.

BİZE SAĞLADIĞINIZ BİLGİLER
Sağlayabileceğiniz bilgiler arasında adınız, e-postanız, mobil numaranız, Facebook veya Apple kullanıcı adınız, doğum tarihiniz, doğum yeriniz ve doğum saatiniz ile giriş veya hesap adınız ve diğer kişisel bilgiler yer alabilir. Eğer hizmetlerimizden veya ürünlerimizden satın alırsanız, kredi veya banka kartı bilgilerinizi sağlayabilirsiniz. Zodiona, ödemeleri işlemek için üçüncü taraflar kullanır ve bu bilgileri doğrudan toplamaz veya saklamaz.
Kullanıcı, platformda paylaşılan veya paylaşılacak herhangi bir bilginin içeriğinden tamamen sorumludur ve Zodiona, platformda paylaşılan herhangi bir gizli bilgi veya içeriğin güvenliğini garanti etmez.

CİHAZLARDAN OTOMATİK OLARAK TOPLANAN BİLGİLER
Websitelerimize, Uygulamalarımıza veya Hizmetlerimize eriştiğinizde, bilgisayarınız, telefonunuz veya diğer cihazınıza bağlantılı olan ancak doğrudan kişisel olarak sizi tanımlamayan bilgileri otomatik olarak toplayabiliriz. Bu bilgiler, IP adresiniz, işletim sistemi ve sürümü, yerel saat dilimi, tarih, saat ve isteğinizin etkinliği, cihaz tipi (ör. masaüstü, dizüstü, tablet, telefon, vb.), cihaz üreticisi, ekran boyutu ve dil tercihi gibi bizimle etkileşim halindeyken davranışınız ve etkinliğinizle ilgili bilgileri içerir.
Çoğu web sitesiyle uyumlu olarak, çerezler ve piksel etiketleri kullanırız. Çerezler, bilgi toplamak için kullanılan küçük metin dosyalarıdır ve pikseller ise kullanıcıların Web sitelerimizle nasıl etkileşimde bulunduklarını anlamamıza izin veren saydam görüntülerdir. Web siteleri gerekli çerezleri ve analiz çerezlerini kullanır.

Bilgileri nasıl kullanıyoruz
Gizli bilgiler, yasalara uygun olarak mahkeme veya idari makamlara açıklanabilir, ancak zaten kamuya açık olan bilgiler bu hükümden çıkarılır. Bize sağladığınız kişisel bilgileri aşağıdaki amaçlar için kullanabiliriz:

Hizmetlerimiz ve ürünlerimiz hakkında sorularınıza ve/veya taleplerinize yanıt vermek

Sizi ilgilendirebileceğini düşündüğümüz Hizmetlerimiz, ürünlerimiz, tekliflerimiz ve haberlerle ilgili bilgi veya materyaller göndermek

Kayıt yoluyla kullanıcı hesapları ve/veya profilleri oluşturmak ve kullanıcı iletişimlerini içe aktarmak

Hizmetleri ve ilgili bildirimleri sağlamak

Hizmetlerinizin kullanımıyla doğrudan ilgili işlem metin mesajları göndermek (örneğin, hesabınızı onaylama ve şifrenizi sıfırlama)

Hizmetleri analiz etmek, geliştirmek ve özelleştirmek ve Uygulamalarımızdaki kullanıcılar için daha iyi bir deneyim yaratmak

Uygulamalar, Web Siteleri, Hizmetler için müşteri ve teknik destek sağlamak;

Anketler, araştırmalar ve denetimler yapmak

Kullanıcı geri bildirimlerini almak ve yanıtlamak

Web siteleri üzerinden yapılan herhangi bir siparişi yerine getirmek (ödeme bilgilerinizi işlemek, nakliye düzenlemek ve fatura ve/veya sipariş onayları sağlamak dahil)

İş başvurunuzu işlemek, iş başvurunuzu değerlendirmek, referans kontrolü yapmak ve uygun yasalar çerçevesinde arka plan kontrolü yapmak (eğer size bir pozisyon teklif edersek)

Yasal, muhasebe veya güvenlik gereksinimlerine uymamıza yardımcı olmak için avukatlarımız, muhasebecilerimiz ve diğer temsilcilerimize ve/veya danışmanlarımıza bilgi sağlamak

Kişisel bilgilerinizle ilgili taleplerinizi veya bu Gizlilik Politikası hakkında sahip olabileceğiniz sorularınızı doğrulamak ve yanıtlamak

Hizmetlerle ilgili gerçek veya şüpheli dolandırıcılık, hackleme, ihlal veya diğer suistimalleri tespit etmek, önlemek ve soruşturmak için; ve toplama sırasında belirtilen diğer amaçlar için.

Platformdan otomatik olarak topladığımız bilgileri platformu yönetmek, sürdürmek ve geliştirmek ve sizin hakkımızda nasıl bilgi edindiğimizi, hangi hizmetlerin ilginizi çekebileceğini ve web sitesi kullanılabilirliğini optimize etmek için anlamak için kullanabiliriz.

Bilgileri nasıl paylaşıyoruz
Zodiona, kişisel bilgilerinizi üçüncü taraflara satmaz ve doğrudan pazarlama amaçlı kişisel bilgilerinizi üçüncü taraflara açıklamaz.

Kişisel bilgilerinizi aşağıdaki durumlarda açıklayabiliriz:

Yasal gereklilikler. Bilgilerinizi aşağıdaki durumlarda açıklayabiliriz: Geçerli bir yasal sürece, hükümet talebine veya ilgili yasa, kural veya düzenlemeye uyum sağlamak için

Hizmet Şartları ihlallerini araştırmak, çözmek veya uygulamak için gerekli olduğunu makul şekilde düşündüğümüz durumlarda

Kullanıcılarımızın veya bizim haklarımızı, mülkümüzü veya güvenliğini korumak için

Herhangi bir sahtekarlık veya güvenlik endişesini tespit etmek ve çözmek için

KİŞİSEL VERİLERİNİZİ SATMIYORUZ
Kişisel Bilgilerinizi hiçbir zaman satmadık ve izniniz olmadan kişisel bilgilerinizi üçüncü taraflara satmayacağız.

ÇOCUKLARIN ÇEVRİMİÇİ ORTAMDA KORUNMASI
Hizmetlerimiz on üç (13) yaşın altındaki çocuklara yönelik değildir ve on üç (13) yaşın altındaki çocuklardan bilgi toplamayı bilerek yapmıyoruz. Eğer on üç (13) yaşın altındaysanız, lütfen Web sitemiz, Uygulamalarımız veya Hizmetlerimizi kullanmayın. Bir çocuğun bilgilerini aldığımızı düşünüyorsanız, lütfen bizimle bu adresten iletişime geçin: kanovasoft@gmail.com Belirli durumlarda, Zodiona yukarıdaki kaldırma gereksinimlerine uymak zorunda kalmayabilir. Zodiona ayrıca, yasaların izin verdiği ölçüde, içeriği veya bilgiyi silmek veya kaldırmak yerine yayınlanan içeriği veya bilgiyi anonimleştirmek veya bu içeriği veya bilgiyi diğer kullanıcılar ve kamunun görebileceği şekilde görünmez hale getirmek hakkını saklı tutar.

Üçüncü Taraf Web Sitelerine Bağlantılar
Hizmetlerimizi kullandığınızda, kontrolümüz dışındaki diğer web sitelerine ve uygulamalara yönlendirilebilirsiniz. Ayrıca, üçüncü taraf web sitelerinin veya uygulamaların Hizmetlere bağlanmasına izin verebiliriz. Herhangi bir üçüncü tarafın gizlilik uygulamalarından veya bağlantılı web sitelerin ve uygulamaların içeriğinden sorumlu değiliz, ancak ilgili gizlilik politikalarını ve şartlarını okumanızı teşvik ediyoruz. Bu Gizlilik Politikası yalnızca Hizmetlere uygulanır.

Sosyal Medya Özellikleri
GİRİŞ
Facebook Connect'i kullanarak Hizmetlerimize giriş yapabilirsiniz. Facebook Connect kimliğinizi doğrular ve adınızı ve e-posta adresinizi bizimle paylaşma seçeneği sağlar, böylece kayıt formumuzu önceden doldurabilirsiniz.

FACEBOOK VERİLERİNİN KULLANIMI
Facebook'tan veri yalnızca sizin Facebook hesabınızı kullanarak web sitemize giriş yapmanızı sağlamak için toplanır. Bu veriler sadece kimlik doğrulama amaçları için kullanılır ve üçüncü taraflarla paylaşılmaz. Facebook hesabınızı kullanarak web sitemize giriş yapmayı seçerseniz, adınızı, e-posta adresinizi ve Facebook kimliğinizi alacağız. Bu verileri sadece sizin için web sitemizde bir hesap oluşturmak ve Facebook kimlik bilgilerinizle web sitemize giriş yapmanıza izin vermek için kullanacağız.

SOSYAL OLARAK PAYLAŞTIĞINIZ BİLGİLER
Paylaştığınız herhangi bir içeriği (örneğin, profiliniz veya DM'leriniz gibi) görüntüleyen kullanıcılar her zaman içeriği kaydedebilir veya uygulama dışında kopyalayabilir. Bu nedenle, internet genelinde geçerli olan aynı sağduyu, Zodiona için de geçerlidir: Başkalarının kaydetmesini veya paylaşmasını istemeyeceğiniz herhangi bir içeriği paylaşmayın veya herkese açık hale getirmeyin.

Bilgileri nasıl güvence altına alıyor, depoluyor ve saklıyoruz
Kişisel bilgilerinizin gizliliği, güvenliği ve bütünlüğünü kazara veya yasadışı olarak yok etme, kaybetme, değiştirme, ifşa etme veya yetkisiz erişimden korumak için makul teknik ve organizasyonel önlemler almış bulunmaktayız. İnternet üzerinden bize iletilen bilgilerin güvenliğini garanti edemeyiz.

Bu Gizlilik Politikasında belirtilen amaçları yerine getirmek için gerekli olan süre boyunca kişisel bilgilerinizi saklayacağız, ancak yasa tarafından belirlenen daha uzun bir saklama süresi varsa, bu süreyi uygulayacağız veya izin verilen daha uzun bir süre varsa saklama süresini uzatabiliriz.

Uluslararası Kullanıcılar
Zodiona, Estonya'da merkezi bulunmakta ve kullanıcı verilerini orada depolamakta ve işlemektedir. Ayrıca, dünya genelindeki kullanıcılara hizmet sağlamak için bazı verileri Almanya veya diğer ülkelerde bulunan sunucularda depolayabiliriz. Ancak, bu ülkeler, ikamet ettiğiniz ülkedeki veri koruma yasalarıyla aynı olmayabilir. Web sitemiz, uygulamalarımız veya hizmetlerimizi Almanya veya Estonya dışından kullanıyorsanız, bilgileriniz Almanya ve Estonya'da aktarılabilir, depolanabilir ve işlenebilir. Hizmetlerimizi kullanarak, bu bilgilerin transferine izin verdiğinizi kabul edersiniz.

Kullanıcı verilerinin gizliliği ve güvenliği konusunu ciddiye alıyoruz ve kullanıcı verilerinin toplanması, kullanımı ve depolanmasıyla ilgili tüm ilgili yasalara ve düzenlemelere uymaktayız. Biz verilerinizi korumak için elinden geleni yaparken, lütfen unutmayın ki hiçbir sistem tam bir güvenlik garantisi veremez. Hizmetlerimizi kullanarak, veri aktarımının internet üzerinden gerçekleşmesinin kendisinden doğan riskleri kabul ettiğinizi beyan edersiniz.

Seçimleriniz ve haklarınız
İletişim bilgilerinizi veya tercihlerinizi güncellemek, bilgilerinizi kayıtlarımızdan silmek veya bu Gizlilik Politikası hakkında yorum veya sorularınız varsa, lütfen bu adresten bizimle iletişime geçin: kanovasoft@gmail.com E-posta iletişiminden istediğiniz zaman çıkabilirsiniz. Almış olduğunuz herhangi bir mesajın içinde yer alan "aboneliği iptal et" bağlantısına tıklayarak e-posta iletişiminden çıkabilirsiniz. Bilgilerinizi bizimle paylaşmak zorunda değilsiniz. Bunu reddederseniz, isteklerinize veya sorularınıza yanıt veremeyebiliriz ve doğum tarihiniz, doğum yeri ve doğum saatiniz gibi belirli bilgiler olmadan, uygulamalarımız ve bazı hizmet özellikleri müsait olmayabilir, performansı kısıtlanabilir veya hiç çalışmayabilir.

Tarayıcınızın çerezlere nasıl yanıt verdiğini, web tarayıcınızın gizlilik ve güvenlik ayarlarını ayarlayarak kontrol edebilirsiniz. Tarayıcınızı çerez kabul etmeyecek şekilde ayarlayabilirsiniz, ancak bu, web sitelerinde belirli işlevsellikleri sınırlayabilir. Nasıl vazgeçileceği, kullandığınız tarayıcı ve/veya cihaz tipine bağlıdır. Analiz çerezlerinden vazgeçmek istiyorsanız, Google Analytics'ten çıkış sağlayabilirsiniz.

Belirli yargı alanlarında ikamet ediyorsanız veya orada bulunuyorsanız, bilgilerinizle ilgili olarak ilgili yasalara göre haklarınız ve korumalarınız olabilir. Bu haklar, bilgilerinize erişme, silme, düzeltme, taşıma (veya taşıma hakkı), işleme itiraz etme ve işleme sınırlama hakkını da içerebilir ve aynı zamanda bir düzenleyiciye şikayette bulunma hakkınız olabilir. Bu haklar mutlak değildir, istisnalara tabidir ve talebinizi reddetmekle yasal olarak zorunlu veya izin verilen durumlar olabilir. Uygulanabilir yasaların gerektirdiği ve izin verdiği ölçüde talebinizi işleyeceğiz ve gerektiğinde, kimliğinizi doğrulamak için ek bilgi isteyebiliriz. Haklarınızı kullanmak veya kişisel bilgilerinizi işleme şeklimizle ilgili sorularınız varsa, lütfen bu adresten bizimle iletişime geçin: kanovasoft@gmail.com #### Bu sözleşmedeki değişiklikler
Bu Gizlilik Politikası'nı periyodik olarak revize etme veya değiştirme hakkımız saklıdır ve yaptığımız herhangi bir değişiklikten haberdar olmanız sizin sorumluluğunuzdadır. Gizlilik Politikasındaki herhangi bir değişiklik, web sitemizde web sitelerimiz yayınlanacaktır. Bu tür revizelerden sonra Websitesi, Uygulamalar ve Hizmetlerimizi kullanmaya devam etmeniz, güncellenmiş Gizlilik Politikasını kabulünüz anlamına gelecektir. Zodiona'nın güncel politika ve uygulamalarından haberdar olmak için bu Gizlilik Politikasını periyodik olarak gözden geçirmenizi öneririz.

Bizimle iletişime Geçin
Haklarınizi kullanmak veya kişisel bilgilerinizi işleme şeklimizle ilgili sorularınız varsa, lütfen bizimle iletişime geçin. kanovasoft@gmail.com
''';

const String _userAgreementContent = '''
Zodiona Kullanım Şartları ve Koşulları İçeren Mesafeli Satış Sözleşmesi
1. Taraflar
İşbu Kullanım Şartları ve Koşulları (“Kullanım Şartları”) ve Mesafeli Satış Sözleşmesi (“Sözleşme”) Zodiona (“Zodiona”) ile mobil cihaz, telefon, akıllı televizyon ve/veya başkaca teknolojik aletler (“Zodiona destekleyen cihazlar”) üzerinden abonelik esasına göre başta astrolojik danışmanlık hizmetleri üzere Zodiona aplikasyonu üzerinden indirilecek içerik hizmetlerinden (“Zodiona Hizmeti”) yararlanmak için işbu Kullanım Şartları’nı kabul eden üyeleri arasında akdedilmektedir.
İşbu Sözleşme’de Zodiona’ya ilişkin ticari bilgiler şöyledir:

Şirket Adı : Zodiona  Ticaret Sicil Müdürlüğü ve Ticaret Sicil Numarası : sonradan eklenecek

Vergi Daire ve Vergi Numarası :

Şirket Adresi : [ADRES BİLGİLERİ DAHA SONRA EKLENECEKTİR] Şirket Telefonu : +905075949994

Şirket e-posta adresi : kanovasoft@gmail.com Üye’ye ilişkin bilgiler: Ödeme sayfasında kişisel bilgileri yer almaktadır.

2. Zodiona Platformu Nedir?
Zodiona platformu, alanlarında uzman astrologların oluşturduğu yapay zeka ile çoğaltılmış Güneş, Ay diğer gezegenlerin, uzaydaki pozisyonlarının, dünyadaki varlıkların üzerindeki etkisinin izlenmesi ve incelenmesi üzerine yorumlanması amacına hizmet eden ve Zodiona’yı destekleyen cihazlar üzerinden üyelik modeli ile üyelerinin astrolojik bilgi edinme ve kişisel gelişim programı hizmetlerinden yararlanabileceği bir abonelik hizmetidir.

İşbu Sözleşme ile hizmet kullanımına ilişkin kurallar ve Üye’nin ödemekle yükümlü olduğu hizmet bedeli, Zodiona platformunda yer alan hizmetlerden yararlanma şartları ve bu kapsamda 6052 sayılı Tüketicinin Korunması Hakkında Kanun, Mesafeli Sözleşmeler Yönetmeliği hükümleri gereğince tarafların hak ve yükümlülüklerinin saptanması sağlanmaktadır. Bu Sözleşme ile, Zodiona tarafından oluşturulan içeriklere katılım sağlanır ve platforma kaydolup üyelik satın alınarak burada belirtilen şartlara bağlı olunduğu kabul edilmiş olur.

İşbu Sözleşme, beraberinde yer alan Ön Bilgilendirme Formu ve Gizlilik Politikası metinlerinin de ayrılmaz parçasıdır.

3. Üyelik
3.1. Üyelik sahibi olabilmek için en az 18 yaşında olunması gerekmektedir. 18 yaşından (ya da bulunulan ülkenin reşit olma yaşından) küçük olanlar, üye olmadan önce ebeveyn onayı almalı ve ebeveyn Sözleşme’yi okumalı ve kabul etmelidir. Platforma kaydolanlar yeterlilik şartlarına uyduğunu onaylamış olur.
3.2. Üye belirtilen uygunluk kriterlerini karşılıyorsa Zodiona’ya kaydolup üyelik satın alabilir. Şu kadar ki Zodiona zaman zaman ücretsiz içerikleri Üye’lere sağlayabildiği gibi tüm içeriklere ulaşılabilen Premium Üyelik modeli için de Haftalık, Aylık ve Senelik olacak şekilde farklı konseptler belirleyebilir. Üye tarafından kayıt esnasında doğru, kesin, geçerli ve tam bilgiler verileceği ve devamında bunun sürdürüleceği kabul edilmiştir.
3.3. Abonelik, Taraflardan birisinin talebi üzerine sonlandırılıncaya kadar devam eder. Zodiona Hizmeti’ni kullanabilmek için internet erişimine ve Zodiona Hizmeti’ni destekleyen bir cihaza sahip olunmalı ve Ödeme Yöntemi sunulmalıdır. Ödeme Yöntemi, zaman zaman güncellenebilen ve üçüncü taraf aracılığıyla ödemeyi de içerebilen, mevcut, geçerli, tanınan bir ödeme yöntemi anlamına gelir. Zodiona söz konusu ödeme yöntemini tek taraflı olarak değiştirme hakkına sahiptir.
3.4. Üye tarafından satın alınan hizmet, elektronik ortamda teslim edilmektedir. Üye, hizmetten tahsilatın yapıldığı andan itibaren faydalanmaya başlayabilir. Üye, Zodiona tarafından aksi belirtilmedikçe mail adresi aracılığıyla giriş yaparak Zodiona Platformu’na kaydolabilir ve içeriklere erişim sağlayabilir.
3.5. Zodiona, üçüncü taraflarca kendi ürünleri veya hizmetleri ile bir arada sunulan üyelikler dâhil olmak üzere, üçüncü kişi sponsor ve/veya firmalarında yer alacağı birkaç farklı üyelik planı sunabilir, şu kadar ki böyle bir durumda üçüncü taraflarca sunulan ürünlerden veya hizmetlerin işleyişinden sorumlu tutulamaz. Örneğin Zodiona Platformu’nda Ücretsiz Üyelik'lerde sınırsız içeriğe ücretsiz erişim bir süreliğine kampanyalar veya tanışma amacı ile sağlanabileceği gibi Premium Üyelik'lerde tüm içeriğe ücret karşılığı erişilebilecektir. Platform içinde üyelik planları, içerikleri zaman zaman güncellenebilen ve Zodiona tarafından farklı koşullara tabi şekilde revize edilebilir.
3.6 Zodiona mesafeli satış sözleşmesi doğrultusunda kullanıcılarının kendi beyan ettikleri kişisel bilgilerin doğru olduğunu kabul eder. Doğruluk denetimi yapmaz. Bilgilerle ilgili beyanda bulunan kişinin kişisel bilgileri verdiği aşamada kişinin kendisi olduğu, arkadaş bilgileri eklediği anda arkadaşının kendisi olduğu kabul edilir. Kanunun gerektirdiği şartlarda yetkili makamlarca bilgi, belge, veri, data istenmesi halinde Zodiona bu bilgileri kanunun kabul ettiği biçimlerde idari ve adli makamlarla paylaşmak durumundadır.

4. Üye’nin Yükümlülükleri ve Hesap Kullanımı
Hesabın gizliliğini korumaktan Üye bizzat sorumlu olup şifre ve hesap bilgileri ile ilgili olarak meydana gelen tüm eylemlerin sorumluluğu tamamen kendisine aittir. Üye hesabın kontrolünü sürdürmek ve başkalarının hesaba erişmesini önlemek adına, Zodiona üyelik kimliğini ve/veya şifresini paylaşmamalı veya herhangi bir şekilde diğer kişilerin erişim sağlayabileceği hale getirmemelidir. Hesap bireysel olarak kullanılmalıdır aksi durumda oluşabilecek gizlilik ihlallerinden Zodiona sorumlu olmayacaktır. Zodiona böyle bir ihlalin tespiti halinde üyenin aboneliğini tek taraflı iptal eder ve ücret iadesi de yapılmaz. Şu kadar ki, üçüncü kişiler tarafından şifrenin ele geçirilmesi veya hesabın elde olmayan bir sebeple yetkisiz kullanılması veya herhangi farklı bir güvenlik ihlalinin yaşanmasının durumunda kanovasoft@gmail.com e-posta üzerinden Zodiona destek ekibi ile iletişime geçilmelidir.
Üyelik şartları Zodiona tarafından gerekli görüldüğünde değiştirilebilir, zaman zaman güncellenebilir. Teknolojik gelişmelere bağlı olarak içeriğin gelişime ve değişime açık olacağı ve kimi zaman kampanya ve yeniliklerle platformun hizmet kapsamının değişebileceğinde taraflar mutabıktır. Bu itibarla üye güncel şartları takip etmekle yükümlüdür.
Üye, hesabını herhangi bir ticari amaç için açma, kullanma, çoğaltma, değiştirme, indirme, satma, aktarma, yayınlama veya diğer yolla erişilebilir kılmayacağını kabul etmiş sayılır.

Üye, hesabı aracılığıyla Zodiona Hizmeti’ne erişebilir, katılım sağlayabilir ve ücret mukabili sunulmuş olan diğer olanaklardan, aktivitelerden yararlanabilir ve reklamlardan ve kampanyalardan haberdar edilebilir. Üye, hesabı aracılığıyla Zodiona Hizmeti’ne zarar verebilecek, engel olabilecek ya da diğer yollarla etkide bulunabilecek herhangi bir eylemde veya icraatta bulunmayacağını kabul ve taahhüt etmiş sayılır. Üye, Zodiona Hizmeti’ni, hizmetle ilişkili tüm özellikler ve işlevselliklerle birlikte, geçerli tüm yasa, kural ve yönetmeliklere ya da ilgili hizmet veya içeriğin kullanımına dair diğer kısıtlamalara uygun şekilde kullanmayı kabul etmiş sayılır. Buna ilaveten üyelik bir hesap sahibi olma yetkisi tanıyacağından üyeliğin suiistimal edilecek amaçlar için kullanılmayacağı (buna üyelik hesap kanalıyla herhangi bir bilgisayar virüsü bulaştırmak veya hesabı ayrımcı, hakaret edici, küfürlü, kötü niyetli, karalayıcı bir tutumla kullanmak veya diğer herhangi bir kişinin haklarına dair diğer ihlaller ve karşıtlıklar dahildir) kabul edilmiş sayılır.
Üye, Sözleşme’yi ihlal eder veya hizmeti yasadışı bir şekilde ya da dolandırıcılık amaçlı kullanır ise, Tarafları ve üçüncü kişileri korumak adına Zodiona tarafından yasal haklar saklı tutularak Üye’nin hizmete erişimi kısıtlanabilir veya üyeliği tek taraflı olarak iptal edilebilir.

5. Hizmetin Fiyatı
Zodiona hizmet bedeli, üçüncü taraflar (App Store ve Google Play) aracılığıyla veya Üye’nin banka veya kredi kartı vasıtasıyla (“Ödeme Yöntemi”) tahsil edilecek olup aşağıda belirtilen şekillerde Üye’den ödeme alınacaktır.

Aylık Premium Abonelik seçilmesi halinde: Satın alınan abonelik feshedilmediği sürece, otomatik olarak yenilenen fatura tarihine denk gelen ay dönümünde tahsil edilecek abonelik bedeli ödeme sayfasındadır.

Arkadaşının Haritasını Gör seçilmesi halinde: Satın alınan paket tek seferlik satın alım içerir.

3 Aylık Premium Abonelik seçilmesi halinde: Satın alınan abonelik feshedilmediği sürece, otomatik olarak yenilenen fatura tarihine denk gelen 3 aylık dönem başında tahsil edilecek abonelik bedeli ödeme sayfasındadır.

Yıllık Premium Abonelik seçilmesi halinde: Satın alınan abonelik feshedilmediği sürece, otomatik olarak yenilenen her yıllık dönem başında tahsil edilecek abonelik bedeli ödeme sayfasındadır. Toplam tutar Zodiona tarafından tek seferde peşin olarak veya Zodiona’nın belirleyeceği şekilde taksitli tahsil edilir. Vergilere dair bilgiler de ödeme sayfasındadır.

Zodiona, her zaman hizmet bedelinde ve hizmet bedeli tahsilinde tek taraflı değişiklik yapma hakkına sahiptir. İşbu Sözleşme’nin 6.2. ve 6.3. madde hakları saklıdır.

6. Faturalama ve Üyelik İptali 6.1. Faturalama Dönemleri Zodiona, üyelik ücreti ve hizmet kullanımına bağlı ortaya çıkabilecek vergi ve olası işlem ücretleri gibi diğer tüm masrafları, belirtilen ödeme tarihinde, seçtiğiniz Ödeme Yöntemi üzerinden tahsil edecektir. Ödeme Yönteminin onaylanamaması, abonelik planının değiştirilmemesi ya da ücretli üyeliğin söz konusu aya dâhil olmayan bir günde başlaması gibi durumlarda ödeme tarihinde değişiklikler yaşanabilir.

Abonelik, Üye tarafından abonelik süresi boyunca feshedilmediği takdirde, seçilen periyott (Aylık, 3 Aylık ve Yıllık) yenilenecek ve yenilenen döneme ilişkin Zodiona tarafından belirlenen bedel, Üye’nin belirlediği ödeme yönteminden fatura tarihine denk gelen yıldönümünde tahsil edilecektir. Yenilemenin istenmemesi halinde, yenileme gününden önce olacak şekilde Üyelik, üçüncü taraflar aracılığı ile (App Store ve Google Play) satın alındı ise mobil uygulama hesaplarına ilişkin telefon ayarlarından, Platform üzerinden kart bilgileri girilerek satın alındı ise Üye hesap ayarlarından iptal edilebilir.

6.2. Ödeme Yöntemleri Ödeme yöntemi geçerlilik tarihinin sona ermesi, yeterli bakiye olmaması veya başka nedenlerden dolayı ödemenin başarıyla gerçekleşmemesi ve hesabın iptal edilmemesi halinde, abonelik ücretini geçerli bir Ödeme Yöntemi’nden tahsil edinceye kadar Zodiona tarafından hizmete erişim askıya alınabilir ya da kısıtlandırılabilir(Üyelik statüsü Premium Üyelik’ten Ücretsiz Üyeliğe çevrilebilir veya belirlenen bazı içerikleri erişim sınırlandırılabilir). Bazı Ödeme Yöntemleri'nin kullanılması hâlinde sağlayıcı kuruluş, Üye’lerden Ödeme Yöntemi’nin işlenmesiyle alakalı dış işlem ücreti gibi çeşitli masraflar tahsil edebilir. Yerel vergi tutarları kullanılan Ödeme Yöntemi'ne bağlı olarak değişiklik gösterebilir.

Üye, Ödeme Yöntemi’ni güncelleyebilir. Ödeme Yöntemi, ödeme hizmeti sağlayıcıları tarafından verilen bilgileri kullanarak da güncellenebilir. Herhangi bir güncellemenin ardından, geçerli Ödeme Yöntemi üzerinden ücret almaya devam edilebilmesi için Zodiona’nın bilgilendirilmesi gereklidir.

Satın alınan ve/veya yenilenen dönemlerde herhangi bir nedenle hizmet bedeli tahsil edilemez ise, Zodiona ilgili döneme ilişkin olarak hizmetin teslimi ve hizmetin sağlanması yükümlülüğünde olmaz.

Mücbir sebep sayılan ve Zodiona’nın olası kontrolü dışındaki ve/veya Borçlar Kanunu kapsamında mücbir sebep sayılan tüm hallerde ve/veya umulmayan hallerde ve/veya bozucu şartlarda, Zodiona yükümlülüklerinden herhangi birini geç veya eksik ifa etme veya ifa etmeme nedeniyle sorumlu olmaz. Bu ve bunun gibi durumlar, Zodiona için, gecikme, eksik ifa etme veya ifa etmeme veya temerrüt addedilmeyecek veya bu durumlar için Zodiona’dan herhangi bir nam altında tazminat talep edilmeyecektir.

Ödemenin kredi kartı vb. ile harcama belgesi düzenlenmeksizin yapıldığı durumlarda, kredi kartının bir başkası tarafından hukuka aykırı şekilde kullanılması hâlinde; Zodiona’nın buna ilişkin sorumluluğu bulunmamaktadır.

Ayrıntılı bilgi için Zodiona destek ekibi ile kanovasoft@gmail.com adresinden iletişime geçilmesi mümkündür.

6.3. Üyelik Sonlandırma ve Değişiklikleri Üye Üyeliği üçüncü taraflar aracılığı ile (App Store ve Google Play) satın aldı ise mobil uygulama hesaplarına ilişkin telefon ayarlarından dilediği zaman iptal edilebilir. İlgili yasaların izin verdiği ölçüde ödemelerin iadesi yoktur. Tamamlanmamış üyelik dönemleri, izlenmemiş ya da kullanılmamış Zodiona içerikleri için iade ya da kredi tanımlaması yapılmamaktadır. İşbu Sözleşme’nin 6.1. maddesinde belirtilen koşullar saklıdır.

Zodiona, her zaman abonelik planında ve hizmet bedellerinde değişiklik yapma hakkına sahiptir. Şu kadar ki Zodiona yapacağı hizmet ücreti ile ilgili değişikliklerin en erken 30 gün sonra geçerli olacağını kabul etmektedir.

Üye, hizmet bedellerinde meydana gelebilecek bu değişiklikleri kabul etmediği takdirde Sözleşme’yi, en geç hizmet bedelinin tahsil edileceği tarihten bir hafta önce bildirmek kaydı ile feshetme hakkına haizdir. Bu tarihe kadar sözleşmeyi feshetmeyen Üye yenilenen döneme uygulanacak hizmet bedeline ilişkin değişikliği kabul etmiş sayılacaktır.

Üye, işbu Kullanım Şartları ve Sözleşme hükümlerinden herhangi birini veya uygulanabilir herhangi bir yasayı veya yönetmeliği ihlal eder ya da herhangi bir hile, dolandırıcılık, sahtecilik eyleminde veya üyeliğini kötüye kullanacak herhangi bir eylemde bulunduğu tespit edilir ise, veya üyenin veli izni olmaksızın 18 yaşından küçük olduğu tespit edilir ise Zodiona dilediği zaman üyeliği yasal haklarını saklı tutarak tek taraflı iptal edebilir.

7. Cayma Hakkı
Kural olarak işbu Sözleşme’ye konu olan dijital içerik hizmeti sağlanması Mesafeli Sözleşmeler Yönetmeliği’nin 15/1 (ğ) maddesinde belirtilen “Elektronik ortamda anında ifa edilen hizmetler” kapsamında elektronik ortamda anında ifa edildiğinden Üye’nin cayma hakkı bulunmamaktadır.

Buna karşın Zodiona, Üye'nin hiçbir hukuki ve cezai sorumluluk üstlenmeksizin ve hiçbir gerekçe göstermeksizin Abonelik satın alarak ödemeyi yaptığı tarihten itibaren 7 (yedi) gün içerisinde Üye mail adresi ve şifresi ile herhangi bir şekilde sisteme giriş yapmadığı takdirde Sözleşme’den cayma hakkının var olduğunu kabul ve beyan eder. Mail adresi ve şifre oluşturulduğu andan itibaren sisteme giriş yapılmış sayılır. Bu durumun aksi Üye tarafından ispat edilmelidir.

Cayma hakkı Zodiona'nın yukarıda belirtilen iletişim kanallarına yasal süre içinde yazılı bildirimde bulunulmasından itibaren on dört gün (14) içinde Üye tarafından ödenmiş olan tutar Zodiona tarafından iade edecektir. Bu kapsamda yapılacak tüm geri ödemeler Üye’nin hizmeti satın alırken kullandığı ödeme aracına uygun bir şekilde yapılacaktır. Dolayısıyla, kredi kartı ile ödemelerde iade işlemi de Üye kredi kartına iade sureti ile yapılır. Üçüncü Taraflar aracılığıyla ödemelerde ücret iadelerinden Üçüncü taraflar sorumludur.

Cayma hakkının kullanılması için Üye’nin cep telefonuna gelen şifre ile sisteme giriş yapmadığını ispatlaması gerekmektedir.

8. Promosyon Teklifleri ve Diğer Hizmetler
Zodiona zaman zaman promosyon amaçlı teklifler, planlar veya üyelikler sunabilir. Teklif kriterleri tamamen Zodiona'nın takdirine bağlı olarak belirlenir. Zodiona’nın böyle bir teklifi iptal etme ve hesabı askıya alma hakkı saklıdır.

Zodiona, gerek sponsorları aracıyla gerekse doğrudan veya iştirakleri kanalıyla spor malzemeleri veya kişisel aktivite ürünlerinin ücret mukabili satışını yapabilir. Zodiona Platform’u üzerinden ürün satışları ile ilgili olarak farklı site ve platformlar bağlantılarına yönlendirme yapılabilir. Söz konusu yönlendirmelere ve satış işlemlerine ilişkin Zodiona’ya herhangi bir sorumluluk atfedilemez. Buna ilişkin duyurular yayımlanacaktır.

Zodiona Hizmeti sürekli olarak güncellenir. Üye’ler hizmetten daha iyi yararlanabilmek için gelişmeleri takip etmeli ve gerekli hallerde geri dönüş sağlamalıdır. Zodiona Hizmeti’ne ilişkin birçok unsur devamlı olarak Zodiona ekibi tarafından teste tabi tutulmaktadır.

9. Sorumluluğun Sınırlandırılması
Zodiona Hizmeti belirtilen şekilde taahhütsüz ya da koşulsuz olarak sunulmaktadır. Dönemsel olarak hizmette aksamalar meydana gelebilir. Bu anlamda Üye, Zodiona’nın kusuru dışında hizmette yaşanan eksiklik ve aksaklıklardan dolayı Zodiona’yı sorumlu tutmayacağını kabul etmiş sayılır.

Platform içerisinde alınan hizmetlere bağlı olarak yapılan aktiviteler hamileler, yaşlılar, belli tedavi altında bulunanlar, kronik hastalığı bulunan ve herhangi bir şekilde sakatlanma riski bulunanlar için risk teşkil edebilir. Bu konuda Zodiona’ya bir sorumluluk atfedilemez.

Üyelik sırasında sunulan tüm yorum, sohbet, soruların cevaplanması yorum ve öneriler eğlence amaçlıdır. Platformda yer alan astrolog önerilerinden, yorumlarından ve/veya herhangi bir şekilde meydana gelebilecek zararlardan hizmet sağlayıcısı olarak Zodiona’nın herhangi bir sorumluluğu bulunmamaktadır. Kullanıcının bu içeriklerde yer alan öneri ve yorumlara istinaden sorumluluğu karşısında tedbirli davranılacağı ve gerektiği durumda Zodiona Hizmeti’nin kullanılmayacağını şimdiden kabul ve taahhüt edilmiş sayılır.

Aynı zamanda Üye’ler kendilerine ait kişisel verilerinin ve özel nitelikli kişisel verilerinin Zodiona ile ve/veya 3.kişi veri işleyenler ile paylaşılmasında, işlenmesinde ve bulut sisteminde depolanmasında rızaları olduğunu kabul eder. Kişisel veriler, Zodiona bünyesinde KVKK mevzuatı kapsamında işlenir, saklanır ve gerektiğinde imha edilir. Bu durum, Üyeler tarafından Gizlilik Politikası’nda incelenmiş ve Üye tarafından Aydınlatma Metni okunup kabul edilmiştir.

Yasaların izin verdiği kapsamda, bu şartlarda veya herhangi bir hizmette öngörülmeyen Zodiona’nın ağır ihmali ve kusuru sonucu mağdur olunan herhangi bir kayıp ya da hasar için Zodiona’nın Üye’ye karşı tüm sorumluluğu, sözleşme yükümlülüğü, haksız fiil (ihmal dahil) veya yasal görevin ihlali için veya herhangi başka bir yolla olsun, 1.500,00 TL miktarını aşmayacaktır.

Bu sınırlamalar, feragat edilemeyecek herhangi bir garantiyi veya Üye’lerin ikamet ettiği ülkenin zorunlu yasaları uyarınca sahip olabilecekleri tüketici koruma haklarını sınırlandırmamaktadır.

10. Kişisel Verilerin Paylaşılması ve İşlenmesine İlişkin Hususlar
Zodiona üyeliği kapsamında, Üye’lerin bazı kişisel verileri ilgili mevzuatta belirlenen amaç ve şartlara uygun olarak ve hizmetin sunumunu teminen Zodiona tarafından paylaşılabilecek ve işlenebilecektir.

10.1. Veri Sorumlusu Üye’lerin kişisel verileri, veri sorumlusu sıfatıyla Zodiona tarafından, 6698 sayılı Kişisel Verilerin Korunması Kanunu (“Kanun”) uyarınca aşağıda açıklanan kapsamda işlenebilecektir. Kişisel verilerin Zodiona tarafından işlenme amaçları konusunda detayli bilgiler, işbu Sözleşme’nin beraberinde yer alan Gizlilik Politikası’nda yer almaktadır.

10.2. Kişisel Verilerin İşlenme Amacı, Aktarıldığı Taraflar ve Aktarım Amaçları Üye’lerden toplanan kişisel veriler, Kanun’da öngörülen temel ilkelere uygun olarak ve Kanun’da belirtilen kişisel veri işleme şartları dahilinde, aşağıda yer alan amaçlar kapsamında Zodiona tarafından işlenebilecek ve Zodiona iş ortaklarına, tedarikçilerine, kanunen yetkili kamu kurumlarına ve yetkili özel kişilere aktarılabilecektir:

Zodiona tarafından sunulan ürün ve hizmetlerin ilgili kişilerin beğeni, kullanım alışkanlıkları ve ihtiyaçlarına göre özelleştirilerek ilgili kişilere önerilmesi ve tanıtılması için gerekli olan aktivitelerin planlanması ve icrası,

Zodiona tarafından ürün ve hizmetlerden ilgili kişileri faydalandırmak için gerekli çalışmaların iş birimleri tarafından yapılması ve ilgili iş süreçlerinin yürütülmesi,

Zodiona’nın ve Zodiona ile iş ilişkisi içerisinde olan ilgili kişilerin hukuki, teknik ve ticari-iş güvenliğinin temini,

Zodiona’nın ticari ve/veya iş stratejilerinin planlanması ve icrası,

Zodiona tarafından yürütülen ticari faaliyetlerin gerçekleştirilmesi için ilgili iş birimleri tarafından gerekli çalışmaların yapılması ve buna bağlı iş süreçlerinin yürütülmesi.

10.3. Kişisel Verilerin Toplanma Yöntemi Ve Hukuki Sebebi Üye’lerin kişisel verileri Zodiona tarafından yukarıda sıralanan amaçlar kapsamında ve elektronik ortamda sesli iletişim araçları veya internet üzerinden form doldurmak suretiyle toplanacaktır. Toplanan kişisel veriler Kanun’da belirtilen kişisel veri işleme şartları kapsamında işbu Sözleşme’de belirtilen amaçlarla işlenebilmekte ve aktarılabilmektedir. Bu konuda Gizlilik Politikası incelenip kabul edilmiş sayılmaktadır.

10.4. Kişisel Veri Sahibinin Hakları Üye’ler kişisel veri sahibi olarak Kanun’da belirtilen aşağıdaki haklara sahiptir:

Kişisel verilerinin işlenip işlenmediğini öğrenme,

Kişisel verileri işlenmişse buna ilişkin bilgi talep etme,

Kişisel verilerinin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,

Yurt içinde veya yurt dışında kişisel verilerinin aktarıldığı üçüncü kişileri bilme,

Kişisel verilerinin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme ve bu kapsamda yapılan işlemin kişisel verilerinin aktarıldığı üçüncü kişilere bildirilmesini isteme,

Kanun’a ve ilgili diğer kanun hükümlerine uygun olarak işlenmiş olmasına rağmen, işlenmesini gerektiren sebeplerin ortadan kalkması hâlinde kişisel verilerin silinmesini veya yok edilmesini isteme ve bu kapsamda yapılan işlemin kişisel verilerinin aktarıldığı üçüncü kişilere bildirilmesini isteme,

İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle aleyhine bir sonucun ortaya çıkması durumunda buna itiraz etme,

Kişisel verilerinin kanuna aykırı olarak işlenmesi sebebiyle zarara uğranması hâlinde zararın giderilmesini talep etme.

Söz konusu haklara ilişkin talepler, kanovasoft@gmail.com e-posta adresine iletilmesi halinde başvurular en kısa sürede ve en geç 30 (otuz) gün içerisinde değerlendirilerek sonuçlandırılacaktır. Taleplere ilişkin olarak herhangi bir ücret talep edilmemesi esas olmakla birlikte, Zodiona tarafından belirlenen ücret tarifesi üzerinden ücret talep etme hakkı saklıdır.

11. Geçerli Kanunlar ve Yargı Yetkisi
Bu Kullanım Şartları ve Sözleşme, Türk kanunlarına tabidir ve yine Türk kanunları kapsamında yorumlanabilir.

Taraflar arası hukuki ilişkinin yabancılık unsuru taşıması halinde Üye, çıkabilecek tüm hukuki sorunlarda kanunlar ihtilafı kurallarına bakılmadan Türk hukukunun uygulanacağını, Türk Milletlerarası Özel Hukuk ve Usul Hukuku Hakkında Kanun’un kanunlar ihtilafı kaidelerinin uygulanmasını talep etmekten feragat ettiğini kabul, beyan ve taahhüt eder.

12. Muhtelif Hükümler
12.1. Üye, Zodiona Hizmeti ve nitelikleri hakkında daha fazla bilgi edinmek ya da hesabı ile ilgili yardıma ihtiyacı için Zodiona’nın kanovasoft@gmail.com e-posta adresine yazabilirler. Belli durumlarda, teknik destek ekibi, Üye’lere en iyi şekilde yardımcı olabilmek için, Zodiona Hizmeti alınan cihaza tam erişim sahibi olunmasını sağlayan bir uzaktan erişim destek aracı kullanması gerekebilir. Cihaza bu şekilde erişim sağlanması istenmiyorsa, uzaktan erişim aracı üzerinden destek almaya izin verilmemelidir.

12.2. Bu Kullanım Şartları ve Sözleşme’nin herhangi bir hükmü veya hükümlerinin geçersiz, yasalara aykırı veya uygulanamaz ilan edilmesi durumunda, kalan hükümlerin geçerliliği, yasallığı ve uygulanabilirliği tam olarak yürürlükte kalmaya devam edecektir.

12.3. Üye, işbu Kullanım Şartları ve Sözleşme’den doğabilecek ihtilaflarda Zodiona’nın resmi defter ve ticari kayıtlarıyla, kendi veri tabanında, sunucularında tutğu elektronik bilgilerin ve bilgisayar kayıtlarının, bağlayıcı, kesin ve münhasır delil teşkil edeceğini, bu maddenin Hukuk Muhakemeleri Kanunu’nun 193. maddesi anlamında delil sözleşmesi niteliğinde olduğunu kabul, beyan ve taahhüt eder.

12.4. Zodiona bu Kullanım Şartları ve Sözleşme zaman zaman değiştirebilir. Bu tür değişiklikler geçerli olmadan en az 30 gün önce değişikliğe ilişkin Üyelere Platform üzerinden bilgilendirme yapılır. Zodiona Hizmeti kapsamında yapılan anlaşma, ilişkili haklar ve yükümlülükler dahil olmak üzere, herhangi bir zamanda bir başka tarafa devredebilir veya temlik edebilir ve böyle bir devir veya temlikle ilişkili olarak Üye Zodiona ile iş birliğinde bulunmayı kabul etmiş sayılır.

12.5. Sözleşme'den doğabilecek uyuşmazlıklarda, Gümrük ve Ticaret Bakanlığı'nca yasa gereği her yıl belirlenen ilan edilen parasal sınırlar dâhilinde İl ve İlçe Tüketici Hakem Heyetleri, bu sınırları aşan durumlarda yetkili Tüketici Mahkemeleri görevli-yetkilidir. Üye, iş bu Sözleşme'de ve Ön Bilgilendirme Formunda yazılı tüm koşulları ve açıklamaları okuduğunu, hizmetin temel özellik-nitelikleri, satış fiyatı, ödeme şekli tüm ön bilgiler-bilgilendirmeler ve cayma hakkı ile kişisel bilgiler-elektronik iletişim l bu Sözleşme de yazılı bütün hususlarda önceden bilgi sahibi olduğunu, tamamını elektronik ortamda gördüğünü ve yine tüm bunlara elektronik ortamda teyit-onay-kabul-iznini vererek kabul ettiğini kabul ve beyan eder.

12.6. Üye hesabı ile ilgili bilgiler, (ödeme izinleri, faturalar, şifre ya da Ödeme Yöntemi değişiklikleri, onay mesajları, bildirimler vb.) Üye’lere yalnızca elektronik formatta (Bildirim, E-posta vb.) aktarılacaktır.

12.7. Kişinin tüm bu üyelik koşullarının içeriklerini eksiksiz olarak okuduktan sonra elektronik ortamda bulunan “kaydol” butonunu tıklaması ve mail adresi ile şifresinin Zodiona kayıtlarına geçmesiyle birlikte üyelik işlemi gerçekleşmiş olur. Üye, ilgili mevzuata uygun olarak üyeliğe konu dijital içerik hizmetlerin temel nitelikleri ve diğer tüm hususlarda bilgi sahibi olduğunu ve işbu üyelik koşullarının bağlayıcı olduğunu kabul ve beyan eder.

OKUDUM ANLADIM. KABUL EDİYORUM.
''';

enum _AuthMode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService;
  late final TapGestureRecognizer _userAgreementRecognizer;
  late final TapGestureRecognizer _privacyAgreementRecognizer;

  _AuthMode _mode = _AuthMode.signIn;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _acceptTerms = false;
  bool _isSubmitting = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    _userAgreementRecognizer = TapGestureRecognizer()
      ..onTap = _showUserAgreementDialog;
    _privacyAgreementRecognizer = TapGestureRecognizer()
      ..onTap = _showPrivacyAgreementDialog;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _userAgreementRecognizer.dispose();
    _privacyAgreementRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/zodiona_logo.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x330B1026),
                    Color(0x990B1026),
                    Color(0xFF1B1F3B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: media.size.width > 500
                      ? media.size.width * 0.2
                      : 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 240),
                      _buildCard(theme),
                      const SizedBox(height: 24),
                      _buildBottomPrompt(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _mode == _AuthMode.signIn ? 'Giris Yap' : 'Kaydol',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_mode == _AuthMode.signUp) ...[
              _buildTextField(
                controller: _nameController,
                label: 'Ad Soyad',
                validator: _validateName,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
            ],
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _passwordController,
              label: 'Sifre',
              obscure: _obscurePassword,
              onToggle: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              validator: _validatePassword,
            ),
            if (_mode == _AuthMode.signUp) ...[
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Sifreyi Onayla',
                obscure: _obscureConfirmPassword,
                onToggle: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() => _acceptTerms = value ?? false);
                    },
                    activeColor: const Color(0xFFF2C98A),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        children: [
                          const TextSpan(text: 'Hesabını oluştururken '),
                          TextSpan(
                            text: 'Kullanıcı Sözleşmesi',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFF2C98A),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _userAgreementRecognizer,
                          ),
                          const TextSpan(text: ' ve '),
                          TextSpan(
                            text:
                                'Kişisel Verilerin Korunmasına İlişkin Sözleşme',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFF2C98A),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _privacyAgreementRecognizer,
                          ),
                          const TextSpan(text: 'yi kabul edersin.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showResetPasswordDialog,
                  child: const Text('Sifremi unuttum'),
                ),
              ),
            ],
            if (_mode == _AuthMode.signIn) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                    activeColor: const Color(0xFFF2C98A),
                  ),
                  Text(
                    'Beni hatirla',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2C98A),
                  foregroundColor: const Color(0xFF1B1F3B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_mode == _AuthMode.signIn ? 'Giris Yap' : 'Kaydol'),
              ),
            ),
            const SizedBox(height: 24),
            _buildDivider(theme),
            const SizedBox(height: 24),
            _buildSocialButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ya da',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                label: 'Google',
                icon: Icons.g_translate,
                onPressed: _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                icon: Icons.apple,
                onPressed: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Apple girisi yakinda eklenecek.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPrompt(ThemeData theme) {
    final textColor = Colors.white.withValues(alpha: 0.8);

    if (_mode == _AuthMode.signIn) {
      return Column(
        children: [
          Text(
            'Yeni bir hesap olusturmak icin',
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
          TextButton(
            onPressed: () => _switchMode(_AuthMode.signUp),
            child: const Text('Kaydol'),
          ),
          TextButton(
            onPressed: _showSupportDialog,
            child: const Text('Giriste sorun mu yasiyorsun?'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'Hesabin varsa',
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        TextButton(
          onPressed: () => _switchMode(_AuthMode.signIn),
          child: const Text('Giris Yap'),
        ),
        TextButton(
          onPressed: _showSupportDialog,
          child: const Text('Giriste sorun mu yasiyorsun?'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label: label),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label: label).copyWith(
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
          color: Colors.white70,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFF2C98A)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_mode == _AuthMode.signUp) {
      if (!_acceptTerms) {
        _showSnack('Kayit icin sartlari kabul etmelisin.');
        return;
      }
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _isSubmitting = true);

      if (_mode == _AuthMode.signIn) {
        final appUser = await _authService.signInWithEmail(
          email: email,
          password: password,
        );
        await _handlePostAuth(appUser);
      } else {
        final name = _nameController.text.trim();
        final birthDate = DateTime(1900, 1, 1);

        final appUser = await _authService.signUpWithEmail(
          email: email,
          password: password,
          displayName: name,
          birthDate: birthDate,
        );
        await _handlePostAuth(appUser);
      }
    } on FirebaseAuthException catch (error) {
      _showSnack(_mapFirebaseError(error));
    } on AuthException catch (error) {
      _showSnack(error.message);
    } catch (error) {
      _showSnack('Beklenmeyen bir hata olustu.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading || _isSubmitting) {
      return;
    }

    setState(() => _isGoogleLoading = true);

    try {
      final appUser = await _authService.signInWithGoogle();
      await _handlePostAuth(appUser);
    } on FirebaseAuthException catch (error) {
      _showSnack(_mapFirebaseError(error));
    } on AuthException catch (error) {
      if (error.code == 'google-cancelled') {
        return;
      }
      _showSnack(error.message);
    } catch (error) {
      _showSnack('Google girisi sirasinda hata olustu.');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handlePostAuth(AppUser user) async {
    if (!mounted) {
      return;
    }
    final target = user.onboardingCompleted
        ? const HomeScreen()
        : OnboardingScreen(userId: user.uid);
    await Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }

  Future<void> _showResetPasswordDialog() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Sifre sifirlama icin once e-posta adresi gir.');
      return;
    }

    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sifre sifirlama'),
          content: Text(
            'Sifirlama baglantisi $email adresine gonderilecek. Onayliyor musun?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgec'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Gonder'),
            ),
          ],
        );
      },
    );

    if (shouldSend != true) {
      return;
    }

    try {
      await _authService.sendPasswordReset(email: email);
      _showSnack('Sifirlama baglantisi e-posta adresine gonderildi.');
    } on FirebaseAuthException catch (error) {
      _showSnack(_mapFirebaseError(error));
    } catch (error) {
      _showSnack('Sifirlama istegi olusturulurken hata olustu.');
    }
  }

  void _switchMode(_AuthMode mode) {
    setState(() {
      _mode = mode;
      if (mode == _AuthMode.signIn) {
        _acceptTerms = false;
        _nameController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  void _showSupportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Destek'),
          content: const Text('Destek ekranlari ilerleyen asamada eklenecek.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Text(message),
      ),
    );
  }

  String _mapFirebaseError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Gecerli bir e-posta gir.';
      case 'user-disabled':
        return 'Bu hesap devre disi birakilmis.';
      case 'user-not-found':
      case 'wrong-password':
        return 'E-posta veya sifre hatali.';
      case 'email-already-in-use':
        return 'Bu e-posta ile zaten bir hesap var.';
      case 'weak-password':
        return 'Daha guclu bir sifre sec.';
      case 'operation-not-allowed':
        return 'Bu giris yontemi su anda devrede degil.';
      default:
        return 'Islem tamamlanamadi. Lutfen tekrar dene.';
    }
  }

  void _showUserAgreementDialog() {
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
          title: const Text('Kullanıcı Sözleşmesi'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(child: Text(_userAgreementContent)),
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

  void _showPrivacyAgreementDialog() {
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
          title: const Text('Kişisel Verilerin Korunması Metni'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(child: Text(_policyContent)),
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

  String? _validateName(String? value) {
    if (_mode != _AuthMode.signUp) {
      return null;
    }
    if (value == null || value.trim().length < 2) {
      return 'Ad soyad zorunlu.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta zorunlu.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Gecerli bir e-posta gir.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Sifre en az 6 karakter olmali.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_mode != _AuthMode.signUp) {
      return null;
    }
    if (value != _passwordController.text) {
      return 'Sifreler eslesmiyor.';
    }
    return null;
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(
            alpha: disabled ? 0.15 : 0.08,
          ),
          foregroundColor: Colors.white,
          side: BorderSide(
            color: Colors.white.withValues(alpha: disabled ? 0.25 : 0.4),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
