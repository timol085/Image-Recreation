function [largeBlocks] = CIELAB_val(numBlocksRow, numBlocksCol, largeBlocks)
disp('Computing CIELAB values for each NxN block ...');

% compute the average CIELAB value for each large block of test image
 for i = 1:numBlocksRow
     for j = 1:numBlocksCol
        largeBlocks{i, j} = mean(mean(squeeze(applycform(largeBlocks{i, j}, makecform('srgb2lab')))));
     end
 end