[file,path]=uigetfile('*.jpg');
image=imread([path,file]);
% Preprocessing
grayImage = rgb2gray(image);
filteredImage = medfilt2(grayImage); % Apply median filter to reduce noise

% Thresholding
threshold = graythresh(filteredImage);
binaryImage = imbinarize(filteredImage, threshold);

% Morphological operations
se = strel('disk', 5);
closedImage = imclose(binaryImage, se);

% Region of interest (ROI) extraction
roiImage = imfill(closedImage, 'holes');

% Feature extraction
stats = regionprops(roiImage, 'Area', 'Perimeter', 'Eccentricity', 'Solidity', 'Centroid');

% Classification
% We can use a machine learning model (e.g., SVM, Random Forest, etc.) to classify the extracted features

% Example: Simple threshold-based classification
areas = [stats.Area];
eccentricities = [stats.Eccentricity];

% Define threshold values for classification
areaThreshold = 100;
eccentricityThreshold = 0.6;

% Classify regions
cancerousIndices = areas > areaThreshold & eccentricities > eccentricityThreshold;

% Select centroids of cancerous regions
cancerousCentroids = vertcat(stats(cancerousIndices).Centroid);

% Visualization
figure;
subplot(1, 2, 1);
imshow(image);
title('Original Image');

subplot(1, 2, 2);
imshow(roiImage);
hold on;
visboundaries(bwboundaries(roiImage));

% Plot cancerous centroids if any were found
if ~isempty(cancerousCentroids)
    plot(cancerousCentroids(:, 1), cancerousCentroids(:, 2), 'r*');
    disp(['Tumors are present, positively detected for breast cancer. Number of tumors: ' num2str(sum(cancerousIndices))]);
else
    disp('Tumors are not present, detected negative for breast cancer. Number of tumors: 0');
end

title('Detected Regions');