% Jessica Marshall & Arvind Nagalingam
% ECE395: Google Maps Image Processing
% December 2016

clc; clear all; close all

%% Read in Image/Convert to Grayscale

%figure 1
I = imread('saugmap.png');        %insert map image name
imshow(I)
title('color image');
saveas(gcf,'I.png')

%figure 2
I2 = rgb2gray(I);       %convert color image to grayscale
figure
imshow(I2)
title('grayscale image');
saveas(gcf,'I2.png')

 K = rangefilt(I);       %detect regions of texture
 figure
 imshow(K)

% %BW1 = edge(I2,'sobel');     %try out two types of edge detection, Sobel better
% BW2 = edge(I2,'canny');
% figure;
% %imshowpair(BW1,BW2,'montage')
% imshow(BW2)
% %title('Sobel Filter                                   Canny Filter');
% title('Sobel Filter edge detection algorithm');

% BW = im2bw(I2);        %grayscale to binary
% [B,L] = bwboundaries(BW,'noholes');
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
% title('trace image boundaries');

%% Image Segmentation Using Seed Pixels

%image segmentation
seedpointR = 800;           %pick coordinates to spread out region from
seedpointC = 300;
% (300, 200) for saugmap


W = graydiffweight(I2, seedpointC, seedpointR,'GrayDifferenceCutoff', 25,'RolloffFactor', 0.5);
    % rolloff factor = [.5, 4]
%sigma = 3;
%W = gradientweight(I2, sigma, 'RolloffFactor', 3, 'WeightCutoff', 0.25);
    % graydiffweight works better than gradientweight
    % run into problems when the open areas are almost disconnected
figure
imshow(log(W),[])

thresh = 0.02;        % the lower, the smaller the image
BW = imsegfmm(W, seedpointC, seedpointR, thresh);
figure
imshow(BW)
title('segmented image')

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
  
figure
imshow(mask)
title('Initial Mask');

maxIterations = 1000; 
bw = activecontour(I2, mask, maxIterations, 'Chan-Vese');
  
% Display segmented image
figure
imshow(bw)
title('Segmented Image');
saveas(gcf,'segmentedimage.png')

%% Combine Two Images/Image Generation
% A1 = imread('I.png');
% A2 = imread('I2.png');
% B = imread('segmentedimage.png');

C = imfuse(I, bw, 'blend');
%figure
%imshow(C)

D = imfuse (mask, C, 'montage');
figure
imshow(D)

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

thresh = 0.001;        % the lower, the smaller the image
BW2 = imsegfmm(W, seedpointC, seedpointR, thresh);
%figure
%imshow(BW2)
%title('segmented image filtered')

E = imfuse (I, BW2, 'blend');
%figure
%imshow(E)

F = imfuse (E, I, 'montage');

figure
imshow(F)

%% Final Comparison

G = imfuse (D, F, 'montage');
figure
imshow(G)

