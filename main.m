

%%
clc; clear all; close all;

f=imgetfile;
g=imgetfile;
%uigetfile

a=imread(f);
b=imread(g);
%%
a1=rgb2gray(a);
b1=rgb2gray(b);

a2 = imnoise(a1,'salt & pepper',0.02);
figure('name','Noisy','numbertitle','off');
imshow(a2);impixelinfo;

v = medfilt2(a2);
figure('name','Filtered Image','numbertitle','off');
imshow(v);impixelinfo;

b2 = imnoise(b1,'salt & pepper',0.02);
figure('name','Noisy','numbertitle','off');
imshow(b2);impixelinfo;

m = medfilt2(b2);
figure('name','Filtered Image','numbertitle','off');
imshow(m);impixelinfo;

image1=a
image2=b

%%
h=10;
rate=0.9;

a = ChangeDetection(image1, image2, h, rate)

%%
grayImage = imread(f);
[rows columns] = size(grayImage);

% Display the first image.
figure(11);
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Gray Scale Image');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.


squaredErrorImage = (double(grayImage) - double(v)) .^ 2;
% Display the squared error image.
subplot(2, 2, 3);
imshow(squaredErrorImage, []);
title('Squared Error Image');
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
mse = sum(sum(squaredErrorImage)) / (rows * columns);

% Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PSNR = 10 * log10( 256^2 / mse);
% Alert user of the answer.
a = sprintf('The mean square error is %.2f',mse);
 msgbox(a);
message = sprintf('The PSNR %.2f',PSNR);
 msgbox(message);
%
