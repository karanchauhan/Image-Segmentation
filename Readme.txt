addpath(genpath('helpers'))
addpath(genpath('ImsAndSegs'))

These two lines are added in MyClust9.m and TestImage9.m which assumes the following directory structure;

/
  - ImsAndSegs/
  - helpers/
  - CalculateMetrics9.m
  - MyClust9.m
  - MyClustEvalHyper9.m
  - MyClustEvalRGB9.m
  - MyFCM9.m
  - MyGMM9.m
  - MyKmeans9.m
  - MyMartinIndex9.m
  - MySOM9.m
  - MySpectral9.m
  - TestImage9.m

PaviaHyperIm.mat, PaviaGrTruth.mat and PaviaGrTruthMask.mat are assumed to be inside ImsAndSegs

The two main functions to run are CalculateMetrics9 and TestImage9. Make sure ImsAndSegs with all RGB and HyperSpectral mat files are copied to the working directory (root) as shown in the directory structure above.

1. CalculateMetrics9:
Calculates the mean and standard deviation to populate Table 2. The local path to image directory should be provided to the script.

2. TestImage9:
Runs one algorithm on one image and displays the segmentation. Name of the image to run should be provided to the script. Evaluation of HyperSpectral images is also done here. Comments are added to show which lines are used for RGB or HyperSpectral or both.

All other helper functions are defined in "helpers". Comments are added in each script to explain its functionality.

