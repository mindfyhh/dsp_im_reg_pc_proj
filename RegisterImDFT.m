close all;
clear all;
figure(1)

I1 = imread('img1.png');
I2 = imread('img2.png');
r1 = sum(I1,1);
c1 = sum(I1,2);
r2 = sum(I2,1);
c2 = sum(I2,2);

w = hamming(length(r1));

winr1 = r1.*w';
winr2 = r2.*w';
winc1 = c1.*w;
winc2 = c2.*w;

imshow(I1);
figure(2);
imshow(I2);

r1fft = fft(winr1);
r2fft = fft(winr2);
c1fft = fft(winc1);
c2fft = fft(winc2);
row_factor = -256/(2*pi);
col_factor = -256/(2*pi);

rowcorr = (r1fft.*conj(r2fft))./abs(r1fft.*conj(r2fft));
iffrowcorr =ifft(rowcorr);

random = rowcorr(100:150);
rowcorr = fftshift(rowcorr);
imcenter = length(rowcorr)/2;
derrow = diff(angle(rowcorr));

for index = imcenter:-1:1
    if(abs(derrow(index)) > .6*max(abs(derrow)))
        rowcorrleft = index;
        break;
    end
end

 for index = imcenter:length(rowcorr)
    if(abs(derrow(index)) > .6*max(abs(derrow)))
        rowcorrright = index;
        break;
    end
 end
 
selectrowcorr = rowcorr(rowcorrleft + 1:rowcorrright);
colcorr = (c1fft.*conj(c2fft))./abs(c1fft.*conj(c2fft));
iffcolcorr =ifft(colcorr);
colcorr = fftshift(colcorr);
dercol = diff(angle(colcorr));

for index = imcenter:-1:1
    if(abs(dercol(index)) > .6*max(abs(dercol)))
        colcorrleft = index;
        break;
    end
end

 for index = imcenter:length(rowcorr)
    if(abs(dercol(index)) > .6*max(abs(dercol)))
        colcorrright = index;
        break;
    end
 end
 
selectcolcorr = colcorr(colcorrleft + 1:colcorrright);

finrowcorr = angle(rowcorr(1:50));
figure(3)
plot(angle(selectrowcorr))
figure(4)
plot(angle(rowcorr))

prow = polyfit(1:length(selectrowcorr),angle(selectrowcorr),1);
pcol = polyfit(1:length(selectcolcorr),angle(selectcolcorr'),1);
y_shift = (prow(1)*256)/(-2*pi)
figure(5)
plot(angle(colcorr))
x_shift = (pcol(1)*256)/(2*pi)
figure(6);
plot(angle(selectcolcorr))

