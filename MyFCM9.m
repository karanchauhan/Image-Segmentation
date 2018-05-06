function [ClusterIm, CCIm] = MyFCM9(Image, ImageType, NumClusts);
[m, n, b] = size(Image);
    data = Image;
    if(strcmp('RGB',ImageType)==1)
        R = data(:,:,1);
        G = data(:,:,2);
        B = data(:,:,3);
        R = double(R);
        G = double(G);
        B = double(B);
        R = R(:);
        G = G(:);
        B = B(:);
        data = [R,G,B];
    end
    if(strcmp('Hyper',ImageType)==1)
        b = 20;
        [Y, U, Lambda, Mu] = PCAbyDG(data,b);
        data = Y;
    end
    [centers,U] = fcm(data, NumClusts);
    maxU = max(U);
    ClusterIm = zeros(m*n,1);
    for itr = 1:NumClusts
        index = find(U(itr,:) == maxU);
          for jtr = 1 : size(index,2)
              ClusterIm(index(jtr)) = itr;  
          end
    end
    CCIm = ConnectedComponents(ClusterIm,NumClusts,m,n);
    imagesc(CCIm);
end