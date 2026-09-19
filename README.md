# Retina Görüntülerinde Kan Damarı Segmentasyonu

EEM658 İleri Görüntü İşleme dersi final proje ödevi. Retina (göz dibi/fundus) görüntülerindeki kan damarlarını görüntü işleme teknikleriyle (öğrenmesiz, klasik yöntemlerle) segmente eden bir MATLAB uygulaması. [STARE veri seti](http://cecas.clemson.edu/~ahoover/stare/) üzerinde çalışıyor.

## Nasıl Çalışır

1. **Görüntü okuma:** STARE veri setinden bir fundus görüntüsü (`im0040.ppm`) okunur.
2. **Gri tonlama:** `rgb2gray` ile tek kanala indirgenir.
3. **Normalizasyon:** Piksel değerleri [0,1] aralığına ölçeklenir.
4. **Kontrast artırma:** `imadjust` (stretchlim ile) ve `adapthisteq` (8x8 blok, adaptif histogram eşitleme — CLAHE) ile damarların arka plandan ayrışması güçlendirilir.
5. **Filtreleme:** 9x9 ortalama filtre uygulanan görüntü, orijinal görüntüden çıkarılarak (arka plan çıkarma / unsharp benzeri) damarların ince yapıları belirginleştirilir.
6. **İkilileştirme (binary):** İki farklı eşikleme yöntemi birlikte kullanılıyor:
   - `adaptthresh` ile bölgesel adaptif eşikleme
   - `isodata.m` (Ridler & Calvard'ın iteratif isodata yöntemi) ile global eşik hesaplama
   
   Bu iki ikili görüntü toplanıp ikiye bölünerek ortalaması alınır; ortaya çıkan "0.5" değerli belirsiz pikseller "0"a eşitlenerek daha az gürültülü, daha güvenilir bir sonuç elde edilir.
7. **Gürültü temizleme:** `bwareaopen` ile 100 pikselden küçük bağlantılı bileşenler (gürültü/küçük artıklar) silinir.
8. **Sonuç:** Elde edilen damar maskesi `imoverlay` ile orijinal görüntünün üzerine bindirilip görselleştirilir.

## Dosyalar

| Dosya | Açıklama |
|---|---|
| `retina.m` | Ana script — görüntü okuma, ön işleme, eşikleme ve sonuç görselleştirmesinin tamamını yapar |
| `isodata.m` | Ridler & Calvard'ın iteratif isodata eşikleme algoritmasının MATLAB implementasyonu — `retina.m` içinde global eşik hesaplamak için kullanılır |

## Kurulum ve Çalıştırma

1. MATLAB'de **Image Processing Toolbox** kurulu olmalı.
2. [STARE veri setinden](http://cecas.clemson.edu/~ahoover/stare/) bir `.ppm` görüntü indir (örneğin `im0040.ppm`) ve `retina.m` ile aynı klasöre koy — ya da `imread(...)` satırındaki dosya adını elindeki görüntüyle değiştir.
3. `retina.m` dosyasını çalıştır. Sırasıyla ön işleme adımlarını (Figure 4), iki farklı eşikleme yöntemini ve birleştirilmiş/temizlenmiş binary sonucu (Figure 2), son olarak orijinal görüntü ile damar segmentasyonunun üst üste bindirilmiş hâlini (Figure 3) gösterir.
