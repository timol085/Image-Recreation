function [ssim_val, MSE_val, reconstImage] = reconstruction(readfile, numBlocksRow, numBlocksCol, smallBlocks, largeBlocks, blockSize, largeImage, smallImgAmt, smallBlockCIELAB, isStructure, thresdistance)

disp('Reconstructing the original image and saving ...');

[rows, cols, ~] = size(largeImage);
tic;
reconstImage = zeros(size(largeImage));

if isStructure == "FALSE"
    % reconstruct the large image using the small images
    for i = 1:numBlocksRow
        for j = 1:numBlocksCol
            % find the small image with the closest CIELAB value to the current large block
            minDistance = Inf;
            for k = 1:smallImgAmt
                largeBlockVec = reshape(largeBlocks{i, j}, 1, []);
                smallBlockVec = reshape(smallBlockCIELAB(k,:), 1, []);

                % compute the Euclidean distance between the vectors using norm
                distance = norm(largeBlockVec - smallBlockVec);

                if distance < minDistance
                    minDistance = distance;
                    bestImage = smallBlocks{k};
                end
            end

            % replace the current large block with the best matching small image
            rowStart = (i-1)*blockSize + 1;
            rowEnd = min(i*blockSize, size(largeImage, 1));
            colStart = (j-1)*blockSize + 1;
            colEnd = min(j*blockSize, size(largeImage, 2));

            blockHeight = rowEnd - rowStart + 1;
            blockWidth = colEnd - colStart + 1;

            if size(bestImage, 1) ~= blockHeight || size(bestImage, 2) ~= blockWidth
                % if the best matching small image has a different size from the block for some god forsaken reason,
                % resize it to fit the block size
                bestImage = imresize(bestImage, [blockHeight, blockWidth], 'bicubic');
            end
            reconstImage(rowStart:rowEnd, colStart:colEnd, :) = bestImage(1:blockHeight, 1:blockWidth, :);
        end
        X = ['   ',num2str(floor((i/numBlocksRow)*100)),'% complete']; %Skriver ut framgång i procent
        disp(X);
    end
else
        % Strukturberäkning
    for i = 1:numBlocksRow
        X = ['   ',num2str(floor((i/numBlocksRow)*100)),'% complete']; %Skriver ut framgång i procent
        disp(X);
        
        for j = 1:numBlocksCol
            rowStart = (i-1)*blockSize + 1;
            rowEnd = min(i*blockSize, size(largeImage, 1));
            colStart = (j-1)*blockSize + 1;
            colEnd = min(j*blockSize, size(largeImage, 2));

            blockHeight = rowEnd - rowStart + 1;
            blockWidth = colEnd - colStart + 1;
            
            bestStructure = 0;
            distance = inf;

            clear bestImage;

            for k = 1:smallImgAmt
                largeBlockVec = reshape(largeBlocks{i, j}, 1, []);
                smallBlockVec = reshape(smallBlockCIELAB(k,:), 1, []);
                
                distance = norm(largeBlockVec - smallBlockVec);

                if (distance < thresdistance)
%                         bwSB = smallBlocks{k};
%                         bwRECONST = largeImage(rowStart:rowEnd, colStart:colEnd, :);

                        bwSB = im2gray(lab2rgb(smallBlocks{k}));
                        bwRECONST = im2gray(lab2rgb(largeImage(rowStart:rowEnd, colStart:colEnd, :)));
                        
                        currentStructure = ssim(bwSB,bwRECONST);
                        
                        if currentStructure > bestStructure
                            bestStructure = currentStructure;
                            bestImage = smallBlocks{k};
                        end
                end
            end
            
            if exist('bestImage','var') == 0 %Om ingen bild inom tröskelvärdet hittas så ta den närmsta bilden
                disp('   --INFO: thresdistance is too small, no color was close enough. Finding the closest image...')
                minDistance = Inf;
                for k = 1:smallImgAmt
                    largeBlockVec = reshape(largeBlocks{i, j}, 1, []);
                    smallBlockVec = reshape(smallBlockCIELAB(k,:), 1, []);
    
                    % compute the Euclidean distance between the vectors using norm
                    distance = norm(largeBlockVec - smallBlockVec);
    
                    if distance < minDistance
                        minDistance = distance;
                        bestImage = smallBlocks{k};
                    end
                end
            end
            if size(bestImage, 1) ~= blockHeight || size(bestImage, 2) ~= blockWidth
                % if the best matching small image has a different size from the block,
                % resize it to fit the block size
                bestImage = imresize(bestImage, [blockHeight, blockWidth], 'bicubic');
            end
            reconstImage(rowStart:rowEnd, colStart:colEnd, :) = bestImage(1:blockHeight, 1:blockWidth, :);
        end
    end
end

timesz = toc;

disp('   Calculating image metrics...');

largeImage = largeImage(1:rows, 1:cols,:);
reconstImage = reconstImage(1:rows, 1:cols,:);

LI_bw = im2gray(lab2rgb(largeImage));
RECO_bw = im2gray(lab2rgb(reconstImage));

% ssim_val = ssim(RECO_bw, LI_bw);

ssim_val = ssim(reconstImage, largeImage);
MSE_val = immse(reconstImage, largeImage);

disp('   Saving image...');
filename2 = strcat(readfile,'_', num2str(smallImgAmt),'_structureCalculation-',isStructure, '_time-', num2str(timesz), '_',num2str(blockSize),'x',num2str(blockSize),'_SSIM-',num2str(ssim_val),'_MSE-',num2str(MSE_val),'.png');


imwrite(reconstImage,filename2);













