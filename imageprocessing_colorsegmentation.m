% Jessica Marshall & Arvind Nagalingam
% ECE395: Google Maps Image Processing
% COLOR-BASED IMAGE SEGMENTATION
% December 2016

clc; clear all; close all

%% Read in image

I = imread('burundivillage.png');
imshow(I)
title('Original Image');

%% Color-based image processing
cform = makecform('srgb2lab');
lab_I = applycform(I,cform);

ab = double(lab_I(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);
figure
imshow(pixel_labels, [])
title('image labeled by cluster index');
%saveas(gcf,'pixelcluster.png')

%% Display image by segment

segmented_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 nColors]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

for i = 1:nColors
    figure
    imshow(segmented_images{1})
    title('objects in cluster i');
end


%% Make image montages

A = imfuse (I, segmented_images{1}, 'montage');
B = imfuse (segmented_images{2}, segmented_images{3}, 'montage');
C = imfuse (A, B, 'montage');

figure
imshow(A)
saveas(gcf,'color2.png')
figure
imshow(B)
saveas(gcf,'color1.png')
%title('Color Segmented Map of Burundi Village')