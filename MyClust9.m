%function [ClusterIm, CCIm] = MyClust9(Im, Algorithm, ImType, NumClusts);
function [ClusterIm, CCIm] = MyClust9(Im, varargin);

 %%
 addpath(genpath('helpers'))
 addpath(genpath('ImsAndSegs'))
 
 %initialize optional parameters
 if ~any(strcmp(varargin,'Algorithm'))
     % first parameter does not exist, so default it to something
     Algorithm = 'Kmeans'; %to do
 else
     Algorithm = varargin{find(strcmp(varargin, 'Algorithm'))+1};
 end
 
 if ~any(strcmp(varargin,'ImType'))
     % second parameter does not exist, so default it to something
     ImType = 'RGB'; %to do
 else
     ImType = varargin{find(strcmp(varargin, 'ImType'))+1}; 
 end
 
 if ~any(strcmp(varargin,'NumClusts'))
     % third parameter does not exist, so default it to something
     NumClusts = 3; %to do
 else
     NumClusts = varargin{(find(strcmp(varargin, 'NumClusts')))+1};
     if NumClusts == 1
         NumClusts = 7;
     end
 end
 
 %print config parameters to console
 disp('Cluestering...')
 Algorithm
 ImType
 NumClusts
 
 %%
 %switch statement to run the requested algorithm
 switch Algorithm
    case 'Kmeans'
        [ClusterIm, CCIm] = MyKmeans9(Im,ImType,NumClusts);
    case 'SOM'
        [ClusterIm, CCIm] = MySOM9(Im,ImType,NumClusts);
    case 'FCM'
        [ClusterIm, CCIm] = MyFCM9(Im,ImType,NumClusts);
    case 'Spectral'
        [ClusterIm, CCIm] = MySpectral9(Im,ImType,NumClusts);
    case 'GMM'
        [ClusterIm, CCIm] = MyGMM9(Im,ImType,NumClusts);
 end
 
 %%
return