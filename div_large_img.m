function [largeBlocks, numBlocksRow, numBlocksCol, largeImage] = div_large_img(largeImage, blockSize)
disp('Dividing large image into NxN blocks ...');

%How many pixels are left on each row/col?
[rows, cols, ~] = size(largeImage);
padCol = rem(cols, blockSize);
padRow = rem(rows, blockSize);

%pad image
largeImage = padarray(largeImage,[blockSize-padRow blockSize-padCol],'symmetric','post');

% divide the large image into non-overlapping NxN pixel blocks
numBlocksRow = floor(size(largeImage, 1) / blockSize);
numBlocksCol = floor(size(largeImage, 2) / blockSize);

largeBlocks = cell(floor(numBlocksRow), floor(numBlocksCol));
    
parfor i = 1:numBlocksRow
    for j = 1:numBlocksCol
        rowStart = (i-1)*blockSize + 1;
        rowEnd = i*blockSize;
        colStart = (j-1)*blockSize + 1;
        colEnd = j*blockSize;
        largeBlocks{i, j} = largeImage(rowStart:rowEnd, colStart:colEnd, :);
    end
end