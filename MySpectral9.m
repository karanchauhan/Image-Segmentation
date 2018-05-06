function [ClusterIm, CCIm] = MySpectral9(Im, ImageType, NumClusts);
 
 %%
 disp('Running Spectral Clustering...') 
 ClusterIm = [];
 CCIm = [];
 %%
 
 k         = NumClusts;          % Number of Clusters
 Neighbors = 10;         % Number of Neighbors

 roundColors = 1;        % Round color values for less strict uniqueness
 roundDigits = 2;        % Precision for Uniqueness
 saveData    = 0;        % Save Dataset
 markEdges   = 0;        % Outline edges

% =============

%%%% Used to read .jpg files as test %%%%
%FileName = 'RainbowDash.jpg';
%FileName = fullfile(FileName);
Img = Im; %imread(FileName);

%%%% Used to read .mat files from the given folder %%%%
%matData = load('C:\Users\FoxRiver-Yoga\OneDrive\Academic\Spring 2018\CAP6610\project1\PaviaRGB.mat');
%imshow(input_data.PaviaRGB);
%FileName = 'C:\Users\FoxRiver-Yoga\OneDrive\Academic\Spring 2018\CAP6610\project1\ImsAndSegs\ImsAndTruths100075.mat';
%ImsAndSegs = load(FileName);
%Img = ImsAndSegs.Im; 
%Img = matData.PaviaRGB; 

[m, n, d] = size(Img);

if(strcmp('Hyper',ImageType)==1)
    b = 20;
    [Y, U, Lambda, Mu] = PCAbyDG(Img,b);
    Data = Y;
    Data = reshape(Data, 1, m * n, []);
else
    % convert into list of data points
    Data = reshape(Img, 1, m * n, []);
end


if d >= 2
    Data = (squeeze(Data))';
end

% convert to double and normalize to [0,1]
Data = double(Data);
Data = normalizeData(Data);

% Find unique colors
if isequal(roundColors, 1)
    fac = 10^roundDigits;
    rData = round(Data * fac) / fac;
else
    rData = Data;
end

[~, ind, order] = unique(rData', 'rows', 'R2012a');

% crop data
Data = Data(:, ind);

% now for the clustering
fprintf('Creating Similarity Graph...\n');
SimGraph = SimGraph_NearestNeighbors(Data, Neighbors, 1);

try
    comps = graphconncomp(SimGraph, 'Directed', false);
    fprintf('- %d connected components found\n', comps);
end

fprintf('Clustering Data...\n');
C = SpectralClustering(SimGraph, k, 3);

%ConnImg = SpectralClustering(SimGraph, k, 2);

% convert and restore full size
D = convertClusterVector(C);
D = D(order);

% reshape indicator vector into m-by-n
S = reshape(D, m, n);

% choose colormap
%if k == 2
%    map = [0 0 0; 1 1 1];
%else
%    map = zeros(3, k);
    
%    for ii = 1:k
%        ind = find(D == ii, 1);
%        map(:, ii) = rData(:, ind);
%    end
%    
%    map = map';
%end

% plot image
set(gca, 'Position', [0 0 1 1], 'Units', 'Normalized');
ClusterIm = S;

%imshow(S, map, 'Border', 'tight');
%imshow(S,map);
%hold on;

%axis off;
%truesize;
%hold off;
%pause;

IDX=reshape(ClusterIm,[m*n,1]);
CCIm = ConnectedComponents(IDX,NumClusts,m,n);
    
return