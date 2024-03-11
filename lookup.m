function [smallBlockCIELAB, smallBlocks, smallImg] = lookup(smallImgAmt, smallBlocks, smallBlockCIELAB, blockSize)
disp('Creating LUT from small images ...');

% CREATE LOOK-UP TABLE
factor = blockSize / 100;

% CREATE LOOK-UP TABLE
for i = 1:smallImgAmt
    folder = 'DennisDataSet';
    filename = strcat('image', num2str(i), '.jpg');
    filepath = fullfile(folder, filename);
    img = imread(filepath);

    smallImg = im2double(imresize(img,factor, 'bicubic'));
    smallBlocks{i} = smallImg;
    smallBlockCIELAB(i,:) = mean(mean(squeeze(applycform(smallImg, makecform('srgb2lab')))));
end

  
