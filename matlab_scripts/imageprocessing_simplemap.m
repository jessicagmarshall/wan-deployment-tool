% Jessica Marshall & Arvind Nagalingam
% ECE395: Google Maps Image Processing
% SIMPLE MAP
% December 2016

clc; clear all; close all

%% Read in Image/Convert to Grayscale

%figure 1
I = imread('simplemap.png');        %insert map image name
imshow(I)
title('Color Image', 'Color', 'r', 'FontSize', 15);
%saveas(gcf,'I.png')        %save output to folder

%figure 2
I2 = rgb2gray(I);       %convert color image to grayscale
figure
imshow(I2)
title('Grayscale Image', 'Color', 'r', 'FontSize', 15);
saveas(gcf,'grayscale.png')       %save output to folder

K = rangefilt(I2);       %detect regions of texture
figure
G = imfuse(I, K, 'montage');
imshow (G)
%saveas(gcf,'rangefilt.png')       %save output to folder

%% 
BW1 = edge(I2,'sobel');     %try out two types of edge detection, Sobel better
BW2 = edge(I2,'canny');
BW3 = edge(I2,'prewitt');
BW4 = edge(I2,'roberts');

X = imfuse(BW1,BW2,'montage');
Y = imfuse (BW3, BW4, 'montage');

figure
imshow(X)
title('Sobel and Canny filter edge detection algorithms');
saveas(gcf,'sobelcanny.png')

figure
imshow(Y) 
title('Prewitt and Roberts filter edge detection algorithms');
saveas(gcf,'prewittroberts.png')

XY = imfuse (X, Y, 'montage');
imshow(XY)
saveas(gcf,'sobelcannyprewittroberts.png')
%  
% BW = im2bw(I2);        %grayscale to binary
% [B,L] = bwboundaries(BW,'noholes');
% figure;
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
% title('trace image boundaries');

%% Image Segmentation Using Seed Pixels

%image segmentation
seedpointR = 300;           %pick coordinates to spread out region from
seedpointC = 200;
% (300, 200) for saugmap


W = graydiffweight(I2, seedpointC, seedpointR,'GrayDifferenceCutoff', 25,'RolloffFactor', 0.5);
    % rolloff factor = [.5, 4]
%sigma = 3;
%W = gradientweight(I2, sigma, 'RolloffFactor', 3, 'WeightCutoff', 0.25);
    % graydiffweight works better than gradientweight
    % run into problems when the open areas are almost disconnected
figure
imshow(log(W),[])

thresh = 0.015;        % the lower, the smaller the image
BW = imsegfmm(W, seedpointC, seedpointR, thresh);
figure
imshow(BW)
%title('segmented image')

Z = imfuse (I, BW, 'blend');
ZZ = imfuse (I, Z, 'montage');

figure
imshow(ZZ)
saveas(gcf,'graydiffimseg.png')

%% Foreground and Background Method
%Active Contour

%mask = zeros(size(I2));
%mask(1:end-160, 25:end-25) = 1;
  
%figure
%imshow(mask);
%title('Initial Contour Location');

%BW2 = activecontour(I2,mask,100);
  
%figure
%imshow(BW2);
%title('Segmented Image');

%% Foreground and Background Method
%roipoly

imshow(I2)

str = 'Click to select initial contour location. Double-click to confirm and proceed.';
title(str,'Color','b','FontSize',12);
disp(sprintf('\nNote: Click close to object boundaries for more accurate result.'))

mask = roipoly;
  
%figure
%imshow(mask)
%title('Initial Mask');

maxIterations = 1000; 
bw = activecontour(I2, mask, maxIterations, 'Chan-Vese');

%% 
% Display segmented image
figure
ph = imread('roip.png');
ph = imfuse (ph, bw);
imshow(ph)
%title('Segmented Image');
saveas(gcf,'segmentedimage.png')

%% Combine Two Images/Image Generation
% A1 = imread('I.png');
% A2 = imread('I2.png');
% B = imread('segmentedimage.png');

C = imfuse(I, bw, 'blend');     %color map overlaid with white regions
%figure
%imshow(C)

D = imfuse (I, C, 'montage');       %prefiltered
figure
imshow(D)
title('119 Kelly Road Open Areas: Unfiltered', 'Color', 'r', 'FontSize', 15)

%% Double Filtering

bw2 = im2uint8(bw);
%imshow (bw2)

%image segmentation
seedpointR = 300;           %pick coordinates to spread out region from
seedpointC = 200;
% (300, 200) for saugmap.png
% dont use for queens.png


W = graydiffweight(bw2, seedpointC, seedpointR,'GrayDifferenceCutoff', 25,'RolloffFactor', 0.5);
    % rolloff factor = [.5, 4]
%sigma = 3;
%W = gradientweight(I2, sigma, 'RolloffFactor', 3, 'WeightCutoff', 0.25);
    % graydiffweight works better than gradientweight
    % run into problems when the open areas are almost disconnected

%figure
%imshow(log(W),[])

thresh = 0.01;        % the lower, the smaller the image
BW2 = imsegfmm(W, seedpointC, seedpointR, thresh);
%figure
%imshow(BW2)
%title('segmented image filtered')

E = imfuse (I, BW2, 'blend');
%figure
%imshow(E)

F = imfuse (I, E, 'montage');       %post filtered
figure
imshow(F)
title('119 Kelly Road Open Areas: Filtered', 'Color', 'r', 'FontSize', 15)

%% Final Comparison

%G = imfuse (D, F, 'montage');
%figure
%imshow(G)

