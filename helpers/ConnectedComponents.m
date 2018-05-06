function[CCIm] = ConnectedComponents(clusterIm,clustNum,m,n)
    disp('getting conn comp');
    CCIm = zeros(m*n,1);
    mask = gausswin(6);
    mask = mask*mask';
    mask = mask/sum(mask);
    %connected component count
    count = 1;
    for clust = 1:clustNum
        bw = zeros(m*n,1);
        % converting each clsuter to bw image
        for itr = 1:size(clusterIm,1)
            if clusterIm(itr) == clust
                bw(itr) = 1;
            end
        end
 
        bw = reshape(bw,m,n);
        cc = bwconncomp(bw);
        
        componentsFound = size(cc.PixelIdxList,2);
        for itr = 1:componentsFound
            pointsInComponent = size(cc.PixelIdxList{itr},1);
            cc.PixelIdxList{itr}
            for jtr = 1:pointsInComponent
                imageIndex = cc.PixelIdxList{itr}(jtr);
               %imageIndex
                CCIm(imageIndex) = count; 
            end
            %CCIm
            count = count + 1;
        end
        
    end
    %CCIm
    CCIm = reshape(CCIm,m,n);
end