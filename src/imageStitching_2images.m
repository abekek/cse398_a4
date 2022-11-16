
% ___________________________________________
% Adam Czajka, November 2017
% Modified: AB, October 2020

clear all
close all

% Read images you want to stitch
im_left = imread('data/nd/1.jpg');
im_middle = imread('data/nd/2.jpg');
im_right = imread('data/nd/3.jpg');

% Calculate SURF keypoints for your images ...
grayImage_left = rgb2gray(im_left);
keypoints_left = detectSURFFeatures(grayImage_left);

% ... and keypoint descriptors:
[descriptors_left, keypoints_left] = extractFeatures(grayImage_left, keypoints_left);

% Do the same for the middle image:
grayImage_middle = rgb2gray(im_middle);
keypoints_middle = detectSURFFeatures(grayImage_middle);
[descriptors_middle, keypoints_middle] = extractFeatures(grayImage_middle, keypoints_middle);



% *** TASK 2: add keypoint detection and feature extraction for your right
% image here:



% Initialize the projective transformation matrices to the identity matrix.
% *** Tasks 2 and 3: remember that you will need 3 (not 2) transformation matrices
% (one of them will be of course an identity matrix)

tforms(1) = projective2d(eye(3));
tforms(2) = projective2d(eye(3));


% Find corespondaces between keypoints (using their descriptors)
indexPairs = matchFeatures(descriptors_middle, descriptors_left, 'Unique', true);
matchedKeypoints_middle = keypoints_middle(indexPairs(:,1), :);
matchedKeypoints_left = keypoints_left(indexPairs(:,2), :);


% The first (left) image will be our reference. Thus, tforms(1) = identity
% matrix (left image is transformed to itself). We need to estimate the
% transformation between the middle image and the left image:
tforms(2) = estimateGeometricTransform(...
    matchedKeypoints_middle, ...
    matchedKeypoints_left,...
    'projective');


% *** TASK 3: think how to modify the above call of the
% "estimateGeometricTransform" function to get the correct mapping of
% left image inliers to middle image inliers (that is: something opposite
% to what we have above)



% *** TASK 2: add the code here to find corespondences between your right
% and middle images, and to find the transformation (assigned to tforms(3))



% *** TASK 2: once you have your tforms(3) calculated, correct it here

% tforms(3).T = tforms(3).T * tforms(2).T;

% *** TASK 3: think if this correction is still needed




% Compute the output limits for each transform
imageSize = size(im_left);     % assume that the size of all images is the same
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', im_left);

% Select an alpha-blending method from a Computer Vision toolbox
blender = vision.AlphaBlender(...
    'Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Warp the images using transformation matrices
warped_im_left = imwarp(im_left, tforms(1), 'OutputView', panoramaView);
warped_im_middle = imwarp(im_middle, tforms(2), 'OutputView', panoramaView);

% *** TASK 2: calculate your warped right image here:



% Generate binary masks for blending
mask_left = imwarp(true(size(im_left,1),size(im_left,2)), tforms(1), 'OutputView', panoramaView);
mask_middle = imwarp(true(size(im_middle,1),size(im_middle,2)), tforms(2), 'OutputView', panoramaView);

% *** TASK 2: calculate your mask for the right image here:



% Overlay the warped images onto the panorama
panorama = step(blender, panorama, warped_im_left, mask_left);
panorama = step(blender, panorama, warped_im_middle, mask_middle);

% *** TASK 2: finally add your warped right image (with mask) to your
% panorama here:


% And show the effects:
figure
imshow(panorama)
imwrite(panorama,'output/panorama_2images.png')
