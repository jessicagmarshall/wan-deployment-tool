% Jessica Marshall & Arvind Nagalingam
% ECE395: Google Maps Image Processing
% BURUNDI VILLAGE
% December 2016

clc; clear all; close all

%% Read in Image/Convert to Grayscale

%figure 1
I = imread('burundivillage.png');        %insert map image name
imshow(I)
title('Color Image', 'Color', 'r', 'FontSize', 15);
%saveas(gcf,'I.png')        %save output to folder

%figure 2
I2 = rgb2gray(I);       %convert color image to grayscale
I2 = mat2gray(I2);
figure
imshow(I2)
title('Grayscale Image', 'Color', 'r', 'FontSize', 15);
%saveas(gcf,'I2.png')       %save output to folder

G = imfuse(I, I2, 'montage');
imshow (G)
%saveas(gcf,'burundisidebyside.png')       %save output to folder

%% Image Segmentation Using Seed Pixels

%image segmentation
%seedpointR = 300;           %pick coordinates to spread out region from
%seedpointC = 200;
% (300, 200) for saugmap, idk for burundivillage

%W = graydiffweight(I2, seedpointC, seedpointR,'GrayDifferenceCutoff', 25,'RolloffFactor', 0.5);
    % rolloff factor = [.5, 4]
refGrayVal = .9;       %im pulling this value out of my ass
W = graydiffweight(I2,refGrayVal);       %use pixelvalues = impixel
%sigma = 3;
%W = gradientweight(I2, sigma, 'RolloffFactor', 3, 'WeightCutoff', 0.25);
    % graydiffweight works better than gradientweight
    % run into problems when the open areas are almost disconnected
useful = log(log(W));
useful(isinf(useful)) = 0;
%figure
%imshow(log(W),[])
%title('log(W)')

figure
imshow(useful)
%title('Gray Difference Weighted Image', 'Color', 'r', 'FontSize', 15)

%saveas(gcf,'burundilog.png')

%thresh = 0.02;        % the lower, the smaller the image
%BW = imsegfmm(W, seedpointC, seedpointR, thresh);
%figure
%imshow(BW)
%title('segmented image')


% %% Foreground and Background Method
% %roipoly
% 
% %B = imguidedfilter(I2);
% B = useful;
% 
% mask = roipoly(B);
% 
% figure
% imshow(mask)
% title('Initial Mask');
% 
% maxIterations = 10000; 
% bw = activecontour(B, mask, maxIterations, 'Chan-Vese');
%   
% % Display segmented image
% figure
% imshow(bw)
% title('Segmented Image');
% %saveas(gcf,'segmentedimage.png')
%% Gray to BW

%use impixel

level = .2;         %somewhere between .1 and .2
BW3 = im2bw(useful, level);
%figure
%imshow(BW3)
%title('black and white')

BW4 = bwareafilt(BW3, 30);     %how many areas do you want it to show
figure
imshow(BW4)
%title('black and white filtered')

%Combine Two Images/Image Generation

C = imfuse(BW3, I, 'blend');
%figure
%imshow(C)

D = imfuse (I, C, 'montage');
figure
imshow(D)
%title('Burundi Village Open Areas: Unfiltered', 'Color', 'r', 'FontSize', 15)


E = imfuse(BW4, I, 'blend');
%figure
%imshow(C)

F = imfuse (I, E, 'montage');
figure
imshow(F)
%title('Burundi Village Open Areas: Filtered', 'Color', 'r', 'FontSize', 15)
saveas(gcf,'burundifiltered.png')

