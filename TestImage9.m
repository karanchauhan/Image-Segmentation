close all;clear all;

addpath(genpath('helpers')) %use for both
addpath(genpath('ImsAndSegs')) %use for both
 
%matData = load('ImsAndTruths22090.mat'); %use for RGB
matData = load('PaviaHyperIm.mat'); %use for Pavia

%Img = matData.Im; %use for RGB
Img = matData.PaviaHyperIm; %use for Pavia
GroundTruthMatData = load('PaviaGrTruth.mat'); %use for Pavia
GroundTruth = GroundTruthMatData.PaviaGrTruth; %use for Pavia
MaskMatData = load('PaviaGrTruthMask.mat'); %use for Pavia
Mask = MaskMatData.PaviaGrTruthMask; %use for Pavia

[ClusterIm, CCIm] = MyClust9(Img,'Algorithm', 'Spectral', 'ImType', 'Hyper', 'NumClusts', 9); %use for Pavia
%[ClusterIm, CCIm] = MyClust9(Img,'Algorithm', 'SOM', 'ImType', 'RGB','NumClusts', 3); %use for RGB

index = MyClustEvalHyper9(ClusterIm,GroundTruth,Mask) %use for Pavia

[m,n] = size(CCIm); %use for both
ClusterIm = reshape(ClusterIm, [m,n]); %use for both

imagesc(ClusterIm); %use for both