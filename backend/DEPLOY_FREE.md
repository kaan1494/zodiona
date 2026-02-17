# Zodiona Astro Backend - Ücretsiz Production Kurulum

Bu dosya, Python backend'i **ücretsiz** olarak yayına alma adımlarını içerir.

## 1) Lokal Çalıştırma (Doğrulama)

1. Terminal aç:
2. Klasöre gir:

```bash
cd C:\Projects\Zodiona\backend
```

3. Paketleri kur:

```bash
C:/Projects/Zodiona/.venv/Scripts/python.exe -m pip install -r requirements.txt
```

4. Sunucuyu başlat:

```bash
C:/Projects/Zodiona/.venv/Scripts/python.exe -m uvicorn backend.app.main:app --host 0.0.0.0 --port 8000
```

> Not: `app.main:app` değil, `backend.app.main:app` kullan.

5. Test:

- http://127.0.0.1:8000/health

## 2) Ücretsiz Deploy (Render)

1. Kodu GitHub'a push et.
2. Render'da yeni **Web Service** oluştur.
3. Repo bağla.
4. Ayarlar:
   - Runtime: Python
   - Build Command:
     ```bash
     pip install -r backend/requirements.txt
     ```
   - Start Command:
     ```bash
     uvicorn backend.app.main:app --host 0.0.0.0 --port $PORT
     ```
5. Deploy et.

Deploy sonrası URL örneği:

`https://zodiona-astro-api.onrender.com`

## 3) Flutter'ı Production API'ye bağlama

Uygulamayı build ederken backend URL ver:

```bash
flutter run --dart-define=ASTRO_API_BASE_URL=https://zodiona-astro-api.onrender.com
```

Release için:

```bash
flutter build appbundle --dart-define=ASTRO_API_BASE_URL=https://zodiona-astro-api.onrender.com
```

## 4) Neden Ay/Yükselen Bilinmiyor çıkıyordu?

- Backend erişilemezse daha önce fallback ile `Bilinmiyor` yazılıyordu.
- Artık API başarısızsa onboarding tamamlanmıyor ve kullanıcıya hata mesajı veriliyor.

## 5) Canlıda Minimum Kontrol Listesi

- [ ] `/health` endpoint 200 dönüyor
- [ ] `/astro` endpoint veri dönüyor
- [ ] Flutter build komutunda `ASTRO_API_BASE_URL` verildi
- [ ] Doğum yeri seçiminden `lat/lon` gerçekten kaydoluyor
