String normalizeCityName(String? rawCity) {
  final key = normalizedCityKey(rawCity);
  if (key.isEmpty) {
    return '';
  }

  return _canonicalCityByKey[key] ?? _titleCaseFromKey(key);
}

String normalizedCityKey(String? rawCity) {
  if (rawCity == null) {
    return '';
  }

  final trimmed = rawCity.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  final primary = trimmed.split(',').first.split('/').first.trim();
  if (primary.isEmpty) {
    return '';
  }

  final lowered = _toTurkishLower(primary);
  final folded = lowered
      .replaceAll('ı', 'i')
      .replaceAll('ç', 'c')
      .replaceAll('ğ', 'g')
      .replaceAll('ö', 'o')
      .replaceAll('ş', 's')
      .replaceAll('ü', 'u')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('û', 'u')
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  return folded;
}

String _toTurkishLower(String text) {
  return text.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
}

String _titleCaseFromKey(String key) {
  final words = key.split(' ').where((part) => part.isNotEmpty);
  return words
      .map((word) {
        final first = word[0] == 'i' ? 'İ' : word[0].toUpperCase();
        return '$first${word.substring(1)}';
      })
      .join(' ');
}

const Map<String, String> _canonicalCityByKey = {
  'adana': 'Adana',
  'adiyaman': 'Adıyaman',
  'afyonkarahisar': 'Afyonkarahisar',
  'agri': 'Ağrı',
  'amasya': 'Amasya',
  'ankara': 'Ankara',
  'antalya': 'Antalya',
  'artvin': 'Artvin',
  'aydin': 'Aydın',
  'balikesir': 'Balıkesir',
  'bilecik': 'Bilecik',
  'bingol': 'Bingöl',
  'bitlis': 'Bitlis',
  'bolu': 'Bolu',
  'burdur': 'Burdur',
  'bursa': 'Bursa',
  'canakkale': 'Çanakkale',
  'cankiri': 'Çankırı',
  'corum': 'Çorum',
  'denizli': 'Denizli',
  'diyarbakir': 'Diyarbakır',
  'edirne': 'Edirne',
  'elazig': 'Elazığ',
  'erzincan': 'Erzincan',
  'erzurum': 'Erzurum',
  'eskisehir': 'Eskişehir',
  'gaziantep': 'Gaziantep',
  'giresun': 'Giresun',
  'gumushane': 'Gümüşhane',
  'hakkari': 'Hakkari',
  'hatay': 'Hatay',
  'isparta': 'Isparta',
  'mersin': 'Mersin',
  'icel': 'Mersin',
  'istanbul': 'İstanbul',
  'izmir': 'İzmir',
  'kars': 'Kars',
  'kastamonu': 'Kastamonu',
  'kayseri': 'Kayseri',
  'kirklareli': 'Kırklareli',
  'kirsehir': 'Kırşehir',
  'kocaeli': 'Kocaeli',
  'konya': 'Konya',
  'kutahya': 'Kütahya',
  'malatya': 'Malatya',
  'manisa': 'Manisa',
  'kahramanmaras': 'Kahramanmaraş',
  'mardin': 'Mardin',
  'mugla': 'Muğla',
  'mus': 'Muş',
  'nevsehir': 'Nevşehir',
  'nigde': 'Niğde',
  'ordu': 'Ordu',
  'rize': 'Rize',
  'sakarya': 'Sakarya',
  'samsun': 'Samsun',
  'siirt': 'Siirt',
  'sinop': 'Sinop',
  'sivas': 'Sivas',
  'tekirdag': 'Tekirdağ',
  'tokat': 'Tokat',
  'trabzon': 'Trabzon',
  'tunceli': 'Tunceli',
  'sanliurfa': 'Şanlıurfa',
  'urfa': 'Şanlıurfa',
  'usak': 'Uşak',
  'van': 'Van',
  'yozgat': 'Yozgat',
  'zonguldak': 'Zonguldak',
  'aksaray': 'Aksaray',
  'bayburt': 'Bayburt',
  'karaman': 'Karaman',
  'kirikkale': 'Kırıkkale',
  'batman': 'Batman',
  'sirnak': 'Şırnak',
  'bartin': 'Bartın',
  'ardahan': 'Ardahan',
  'igdir': 'Iğdır',
  'yalova': 'Yalova',
  'karabuk': 'Karabük',
  'kilis': 'Kilis',
  'osmaniye': 'Osmaniye',
  'duzce': 'Düzce',
  'bakirkoy': 'Bakırköy',
};
