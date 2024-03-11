function[smallBlockCIELAB, smallBlocks, smallImgAmt] = optimise(smallImgAmt, smallBlocks, smallBlockCIELAB, opt_amt)


    % Remove half of the small images that are closest in CIELAB colorspace
    numToRemove = floor(smallImgAmt/opt_amt);
    while numToRemove > 0
        minDistance = Inf;
        for i = 1:smallImgAmt
            for j = 1:smallImgAmt
                if i ~= j
                    distance = norm(smallBlockCIELAB(i,:) - smallBlockCIELAB(j,:));
                    if distance < minDistance
                        minDistance = distance;
                        minDistanceIdx1 = i;
                        minDistanceIdx2 = j;
                    end
                end
            end
        end
        smallBlockCIELAB(minDistanceIdx1,:) = [];
        smallBlocks(minDistanceIdx1) = [];
        smallImgAmt = smallImgAmt - 1;
        numToRemove = numToRemove - 1;
    end

