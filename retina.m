clc
close all
clear
% Veri Seti Linki
% http://cecas.clemson.edu/~ahoover/stare/

%% Görüntü Okuma
image = imread("im0040.ppm");
figure(4); subplot(2,3,1);
imshow(image);
title("Orijinal Resim");


%% Gri Tonlamaya Çevirme
image_2gri = rgb2gray(image);
subplot(2,3,2);
imshow(image_2gri);
title("Gri Tonlama");


%% Normalini Alma
image_2gri = double(image_2gri);
image_3normal = (image_2gri - min(image_2gri(:))) ./ (max(image_2gri(:)) - min(image_2gri(:)));
subplot(2,3,3);
imshow(image_3normal)
title("Normal");


%% Kontrast Ayarı
image_4hist = imadjust(image_3normal,stretchlim(image_3normal),[]);
image_4hist = adapthisteq(image_4hist,"NumTiles",[8 8],"NBins",256);
subplot(2,3,4);
imshow(image_4hist);
title("Histogram");


%% Filtreleme
h = fspecial('average',9);
image_5filt = imfilter(image_4hist, h);
image_5filt = imsubtract(image_5filt, image_4hist);
subplot(2,3,5);
imshow(image_5filt);
title("Filtreli");


%% Binary'e çevirme
%   Binary'e çevirme işleminde iki farklı threshold bulma yöntemi ile iki 
% farklı binary görüntü elde ettim. Bu görüntüleri toplayıp ikiye bölünce 
% binary görüntüde "0.5" değerli pikseller ortaya çıkıyor. Bunları da "0"a
% eşitleyerek daha az gürültülü bir binary görüntü elde ettim.
thres2 = graythresh(image_5filt);
level1 = adaptthresh(image_5filt, thres2,'ForegroundPolarity','bright','Statistic','gaussian','NeighborhoodSize', [9 9]);
image_6bina_1 = imbinarize(image_5filt,level1+thres2/3);
figure(2); subplot(2,2,1);
imshow(image_6bina_1);
title("Adaptif Threshold ile Binary");

level2 = isodata(image_5filt);
image_6bina_2 = imbinarize(image_5filt,level2+thres2/3);
subplot(2,2,2);
imshow(image_6bina_2);
title("isodata fonksiyonu ile Binary");

image_6bina = (image_6bina_1 + image_6bina_2)/2;
image_6bina = imbinarize(image_6bina,0.51);
subplot(2,2,3);
imshow(image_6bina);
title("Binary");


%% Bazı küçük gürültüleri temizlemeye çalışma
image_7delete = bwareaopen(image_6bina, 100);
subplot(2,2,4); 
imshow(image_7delete);
title("Piksel Silmeli");


%% Sonuç
% image_7delete = imcomplement(image_7delete);
Sonuc = imoverlay(image,image_7delete, [0 0 0]);
figure(3);
subplot(1,2,1);imshow(image);
subplot(1,2,2);imshow(Sonuc);

