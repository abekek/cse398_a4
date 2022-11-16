
clear all
close all

% Read and show the input image
I = imread('nd2.jpg');

% Calculate SURF for your image
grayImage = rgb2gray(I);
points = detectSURFFeatures(grayImage,'NumOctaves',3,'NumScaleLevels',3);
[features, points] = extractFeatures(grayImage, points);

% We can check how many SURF keypoints were found:
[NoOfKeypoints NoOfAttributes] = size(features);

% Do you remember how many attributes each SURF keypoint descriptor should have? Let's check it:
disp(['Found ' num2str(NoOfKeypoints) ' SURF keypoints in this image'])

disp(['Each SURF keypoint has ' num2str(NoOfAttributes) ' attributes'])

% Plot N strongest keypoints
N = 30;
imshow(grayImage*0.5)
hold on
plot(points.selectStrongest(N),'showOrientation',true,'showScale',true)
hold off
