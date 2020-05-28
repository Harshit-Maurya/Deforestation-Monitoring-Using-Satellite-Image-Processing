
function [dif_image] = image_difference(image1, image2, h, rate)
%% Set input parameters
if size(image1) ~= size(image2)
    warning('Image 1 and 2 must be in the same size');
end
[rows cols ~] = size(image1);
if ndims(image1) ~= 3
    image1 = repmat(image1, [1 1 3])/255;
    image2 = repmat(image2, [1 1 3])/255;
end
figure(1);
subplot(2,2,1); imshow(image1); title('Original image 1');
subplot(2,2,2); imshow(image2); title('Original image 2');

%% Calculate difference image (Equation 1)
dif_image = abs(double(image1 - image2));
subplot(2,2,3); imshow(dif_image,[]); title('Difference image');
impixelinfo;

