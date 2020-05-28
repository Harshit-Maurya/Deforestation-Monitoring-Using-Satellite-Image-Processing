
function [change_map] = ChangeDetection(image1, image2, h, rate)
%% Set input parameters
if size(image1) ~= size(image2)
    warning('Image 1 and 2 must be in the same size');
end
[rows cols ~] = size(image1);
if ndims(image1) ~= 3
    image1 = repmat(image1, [1 1 3])/255;
    image2 = repmat(image2, [1 1 3])/255;
end
figure(9);
subplot(2,2,1); imshow(image1); title('Original image 1');
subplot(2,2,2); imshow(image2); title('Original image 2');

%% Calculate difference image (Equation 1)
dif_image = abs(double(image1 - image2));
subplot(2,2,3); imshow(dif_image,[]); title('Difference image');

%% Padding for the difference image
pad = zeros(rows+h-1, cols+h-1, 3);
pad(1:rows, 1:cols, :) = dif_image;

%% Divide the difference image into h x h non-overlapping blocks (Equation 2)
vector_set = zeros(rows*cols, 3*h*h);
count = 1;
for i = 1:rows
    for j = 1:cols
        block = pad(i:i+h-1, j:j+h-1, :);
        vector_set(count, :) = reshape(block, 1, []);
        count = count + 1;
    end
end
clear count;

%% PCA algorithm
% Calculate average vector of the set (Equation 3)
mean_vector = mean(vector_set,1);
dif_vector = vector_set - mean_vector;
% Calculate covariance matrix (Equation 4)
covar = cov(dif_vector);
% Compute eigenvectors and eigenvalues of the covariance matrix
[eigvector eigvalue_mat] = eig(covar);
eigvalue = diag(eigvalue_mat);
% Sort the eigen vectors according to the descending eigenvalues
[~, index] = sort(-eigvalue);
eigvalue = eigvalue(index);
eigvector = abs(eigvector(:,index));
clear junk;
% Choose number of eigenvectors satisfied the required magnitude percentage
EigenvectorPer = 1;
lim = ceil(EigenvectorPer*size(eigvector,2));
eigvector = eigvector(:, 1:lim);
% Choose number of eigenvectors satisfied the thresholding
for k1 = length(eigvalue):-1:1
    if(sum(eigvalue(k1:length(eigvalue)))>=rate*sum(eigvalue))
        break;
    end
end
eigvector = eigvector(:,k1:length(eigvalue));
% Project difference image vector set onto eigenvector space to get feature vector space
feature = vector_set * eigvector;

%% K-Means algorithm
[label,~] = kmeans(feature,2);
change_map = reshape(label, [rows cols])';
change_map = change_map - 1;
subplot(2,2,4); imshow(change_map, []); title('Change map');

%end

grayImage = image1
[rows columns] = size(grayImage);

% Display the first image.
figure(11);
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Gray Scale Image');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.


squaredErrorImage = (double(grayImage) - double(change_map)) .^ 2;
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

end
