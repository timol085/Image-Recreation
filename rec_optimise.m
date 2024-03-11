function[newSB, newCIEL, smallImgAmt] = rec_optimise(map_lab, smallBlocks, smallBlockCIELAB, amtColor, smallImgAmt)

disp('Optimizing LUT using the large image ...');
newSB = cell(amtColor, 1);
newCIEL = zeros(amtColor, 3);

for i = 1:amtColor
    dist = inf;

    for j = 1:smallImgAmt
        newdist = norm(smallBlockCIELAB(j,:) - map_lab(i,:));

        if newdist < dist
            dist = newdist;
            bestindex = j;
        end
    end

    newSB{i} = smallBlocks{bestindex};
    newCIEL(i,:) = smallBlockCIELAB(bestindex,:);
end

smallImgAmt = amtColor;