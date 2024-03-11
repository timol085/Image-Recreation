clc

% read the small images (100x100)
smallImgAmt = 19;  %How many images of the ones avaliable should be used?
smallBlocks = cell(smallImgAmt, 1);
smallBlockCIELAB = zeros(smallImgAmt, 3);
opt_amt = 2; %2 = ta bort hälften av alla bilder, 3 = ta bort en tredjedel, 1.5 = ta bort 

amtColor = 50;  %Hur många färger att behålla för att optimera utifrån inputbild

%TA STRUKTUR I HÄNSYN:
isStructure = "FALSE";
thresdistance = 15; %Färgkänslighet från [0,100], mindre = "bättre" färger, större = "bättre" struktur (& längre tidsåtgång!)
%--------------------------------------------------------------------------
%Size of Initial BlockSize
blockSize = 20;

% Name of file to recreate
readfile = 'den';
    
% read the large image
largeImage = im2double(imread(strcat(readfile,'.jpg')));

% divide the large image into non-overlapping NxN pixel blocks
[largeBlocks, numBlocksRow, numBlocksCol, largeImage] = div_large_img(largeImage, blockSize);

% compute the average CIELAB value for each large block of test image
largeBlocks = CIELAB_val(numBlocksRow, numBlocksCol, largeBlocks);

%--------------------------------------------------------------------------

% Create lookup table
[smallBlockCIELAB, smallBlocks, smallImg] = lookup(smallImgAmt, smallBlocks, smallBlockCIELAB, blockSize);



%--------------------------------------------------------------------------
% Optimera dataset, behåller de bästa bilderna utifrån originalbilden
[IND,map] = rgb2ind(largeImage,amtColor);
map_lab = rgb2lab(map);
[smallBlocks, smallBlockCIELAB, smallImgAmt] = rec_optimise(map_lab, smallBlocks, smallBlockCIELAB, amtColor, smallImgAmt);

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Optimisera dataset, tar bort de bilder som är närmast varandra
% disp('Optimizing LUT to remove similar colors ...');
%[smallBlockCIELAB, smallBlocks, smallImgAmt] = optimise(smallImgAmt, smallBlocks, smallBlockCIELAB, opt_amt);
% disp("After optimisation: " + size(smallBlockCIELAB(:,1)) + " images left")
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Rekonstruerar bilden från de små bilderna
[ssim_val, MSE_val, reconstImage] = reconstruction(readfile, numBlocksRow, numBlocksCol, smallBlocks, largeBlocks, blockSize, largeImage, smallImgAmt, smallBlockCIELAB, isStructure, thresdistance);
disp('---Image saved Successfully!---');

% s-cielab
XYZ_img = rgb2xyz(largeImage);
XYZ_rec = rgb2xyz(reconstImage);

whitePoint = [95.5, 100, 108.9];
PPI = 72;
d = visualAngle(-1,12,72,10); 

res = scielab(d, XYZ_img, XYZ_rec, whitePoint, 'xyz');
meanDiff = mean(res(:));
maxDiff = max(res(:)); % smaller diff is better


% MSE and SSIM
org = ("MSE = 0 SSIM = 1");
MSE = ("MSE = " + MSE_val);
SSIM = ("SSIM = " + ssim_val);
rec = (MSE + " " + SSIM + '\newline            S-CIELAB = ' + meanDiff);
% create a figure with two subplots
figure;
subplot(1,2,1);
imshow(largeImage);
title('Original Image');
xlabel(org);

subplot(1,2,2);
imshow(reconstImage);
title('Reconstructed Image \newline' + "      Blocksize = " + blockSize + '\newline Image amount = ' + smallImgAmt);
xlabel(rec);
%--------------------------------------------------------------------------


% % Name of file to recreate
% readfile = 'norr';
%     
% % read the large image
% org = im2double(imread(strcat(readfile,'.jpg')));
% 
% % Name of file to recreate
% readfile = 'tresh50';
%     
% % read the large image
% rec = im2double(imread(strcat(readfile,'.png')));
% 
% ssim_val = ssim(rec, org)
% MSE_val = immse(rec, org)
% 
% XYZ_img = rgb2xyz(org);
% XYZ_rec = rgb2xyz(rec);
% 
% whitePoint = [95.5, 100, 108.9];
% PPI = 72;
% d = visualAngle(-1,12,72,10); 
% 
% res = scielab(d, XYZ_img, XYZ_rec, whitePoint, 'xyz');
% meanDiff = mean(res(:))
% maxDiff = max(res(:)); % smaller diff is better




