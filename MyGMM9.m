function [ClusterIm, CCIm] = MyGMM9(data, ImageType, NumClusts);
m = size(data,1);
n = size(data,2);
b = size(data,3);
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

GMMmodel = fitgmdist(data,NumClusts,'CovType','diagonal');
ClusterIm = cluster(GMMmodel, data);

%imagesc(reshape(ClusterIm,m,n));
CCIm = ConnectedComponents(ClusterIm,NumClusts,m,n);
%imagesc( CCIm );