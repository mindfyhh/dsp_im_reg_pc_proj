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
[rowans,rowloc] = max(iffrowcorr);

colcorr = (c1fft.*conj(c2fft))./abs(c1fft.*conj(c2fft));
iffcolcorr =ifft(colcorr);
[colans,colloc] = max(iffcolcorr);

if colloc > 128
   colloc = colloc - 256 
end

if rowloc > 128
   rowloc = rowloc - 256
end

y_axis_int_shift = rowloc - 1
x_axis_int_shift = colloc - 1
