function [ClusterIm, CCIm] = MySOM9(data, ImageType, clustNum);
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
totalW = clustNum;
%//initialization of weights
w = rand(totalW,b).*256;
%// the initial learning rate
eta0 = 0.01;
%// the current learning rate (updated every epoch)
etaN = eta0;
%// the constant for calculating learning rate
tau2 = 1000;
%creating map out of node
[I,J] = ind2sub([sqrt(totalW),sqrt(totalW)], 1:totalW);
%N = size(data,2);
%// the size of neighbor
sig0 = 2;
sigN = sig0;
%// tau 1 for updateing sigma
tau1 = 1000/log(sigN);
out = zeros(m*n,1);
%i is number of epoch
for itr=1:3
    %// j is index of each point.
    %// it should iterate through data in a random order rewrite!!
    for j=1:m*n
        x = data(j,:);
        % 2 is for summing rows
        dist = sum( sqrt((w - repmat(x,totalW,1)).^2),2);
        %// find the winner
        [v ind] = min(dist);
        %// the 2-D index
        ri = [I(ind), J(ind)];
        out(j) = ind;
        %// distance between this node and the winner node.
        dist = 1/(sqrt(2*pi)*sigN).*exp( sum(( ([I( : ), J( : )] - repmat(ri, totalW,1)) .^2) ,2)/(-2*sigN)) * etaN;
        
        %// updating weights  
        w = w + dist.*( x - w);
   
    end
    %// update learning rate
    etaN = eta0 * exp(-itr/tau2);
    %// update sigma
    sigN = sig0*exp(-itr/tau1);
end
ClusterIm = out;
CCIm = ConnectedComponents(ClusterIm,clustNum,m,n);
ClusterIm = reshape(ClusterIm,m,n);
imagesc( imgaussfilt(CCIm,1));