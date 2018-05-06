function [output] = CalculateMetrics9() 
    addpath(genpath('helpers'))
    % Provide local path for ImsAndSegs folder
    Images = dir('C:\Users\FoxRiver-Yoga\Documents\ImsAndSegs3');
    Images(1:2,:) = [];
    numberOfImages = max(size(Images));
    output = zeros(1, numberOfImages);
    numberOfImages
    for i = 1:numberOfImages
        minimum = 1;
        i
        LoadedImage = load(strcat(Images(i,1).folder, '/', Images(i,1).name));
        for j = 2:7
            % Change to algorithm for which metric has to be calculated
            %[ClusterIm, CCIm] = MySpectral9(LoadedImage.Im, 'RGB', j);
            [ClusterIm, CCIm] = MyClust9(LoadedImage.Im,'Algorithm', 'Spectral', 'ImType', 'RGB', 'NumClusts', j);
           
            a = MyMartinIndex9(CCIm, LoadedImage.Seg1);
            b = MyMartinIndex9(CCIm, LoadedImage.Seg2);
            c = MyMartinIndex9(CCIm, LoadedImage.Seg3);
            index = min(min(a,b),c);
            
            if index<minimum
                minimum = index;
            end
        end
        minimum
        output(i) = minimum;
    end
    %After running this, calculate mean using mean(output) and standard deviation using std(output)
end