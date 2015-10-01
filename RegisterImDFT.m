%DSP Image Registration Project
%Normalization factor n/pi = 256/2pi

%Reads in Two Images
close all;
clear all;
figure(1)
I1 = imread('img1.png');
I2 = imread('img2.png');

%Obtain row and column vector from first image
r1 = sum(I1,1);
c1 = sum(I1,2);

%row and column vector from second image
r2 = sum(I2,1);
c2 = sum(I2,2);


%Generates Hamming Window the length of the row vector 
%It is known the images are square so the window is reused for column
%vector
w = hamming(length(r1));

%The windowed signals are then generated
winr1 = r1.*w';
winr2 = r2.*w';
winc1 = c1.*w;
winc2 = c2.*w;

%Displays Images
imshow(I1);
figure(2);
imshow(I2);

%Obtain FFT of windowed vectors
r1fft = fft(winr1);
r2fft = fft(winr2);
c1fft = fft(winc1);
c2fft = fft(winc2);
row_factor = -256/(2*pi);
col_factor = -256/(2*pi);

%Normalized phase correlation of the row vectors

rowcorr = (r1fft.*conj(r2fft))./abs(r1fft.*conj(r2fft));

%The following calculates the cross correlation used in the integer
%resolution phase correlation technique
iffrowcorr =ifft(rowcorr);
[rowans,rowloc] = max(iffrowcorr);


%Iterates from center of abs of derivative of image to find the first peak to the
%left which should correspond to the peak of before the linear portion
%portion of the phase begins
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

%Iterates from center of abs value of derivative of image to find the first peak to the
%right which should correspond to the peak after the linear portion
%portion of the phase begins
 for index = imcenter:length(rowcorr)
    if(abs(derrow(index)) > .6*max(abs(derrow)))
        rowcorrright = index;
        break;
    end
 end
 
selectrowcorr = rowcorr(rowcorrleft + 1:rowcorrright);

%Normalized phase correlation of columns between images
colcorr = (c1fft.*conj(c2fft))./abs(c1fft.*conj(c2fft));

%The following calculates the cross correlation used in the integer
%resolution phase correlation technique
iffcolcorr =ifft(colcorr);

colcorr = fftshift(colcorr);
dercol = diff(angle(colcorr));


%Iterates from center of abs of derivative of image to find the first peak to the
%left which should correspond to the peak of before the linear portion
%portion of the phase begins


for index = imcenter:-1:1
    if(abs(dercol(index)) > .6*max(abs(dercol)))
        colcorrleft = index;
        break;
    end
end

%Iterates from center of abs value of derivative of image to find the first peak to the
%right which should correspond to the peak after the linear portion
%portion of the phase begins
 for index = imcenter:length(rowcorr)
    if(abs(dercol(index)) > .6*max(abs(dercol)))
        colcorrright = index;
        break;
    end
 end
 
%Creates window of linear portion of phase
selectcolcorr = colcorr(colcorrleft + 1:colcorrright);
[colans,colloc] = max(iffcolcorr);
finrowcorr = angle(rowcorr(1:50));
figure(3)
plot(angle(selectrowcorr))
figure(4)
plot(angle(rowcorr))

%Fit line to slope of linear portion of phase
prow = polyfit(1:length(selectrowcorr),angle(selectrowcorr),1);
pcol = polyfit(1:length(selectcolcorr),angle(selectcolcorr'),1);
%Multiply slope of fit line by scale factor to obtain pixel shift

y_shift = (prow(1)*256)/(-2*pi)
figure(5)
plot(angle(colcorr))
%Transpose reverses the column vector data, the constant is positive here
%to compensate for the added negative sign
x_shift = (pcol(1)*256)/(2*pi)
figure(6);
plot(angle(selectcolcorr))

%Normalize outputs to get delta / change of data for cross correlation
%technique

if colloc > 128
   colloc = colloc - 256 
end

if rowloc > 128
   rowloc = rowloc - 256
end

y_axis_int_shift = rowloc - 1
x_axis_int_shift = colloc - 1
