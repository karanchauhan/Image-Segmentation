function index  = MyClustEvalHyper9(ClusterIm,GroundTruth, mask)
    [m,n] = size(mask);
    ClusterIm = reshape(ClusterIm, m, n);

    ClusterIm = ClusterIm.*mask;
    index = min(HyperSpectralMartinIndexHelper(ClusterIm,GroundTruth), HyperSpectralMartinIndexHelper(GroundTruth,ClusterIm));
end

%% Helper method to calculate Martin Index %%
function index = HyperSpectralMartinIndexHelper(A, B) 
    [PixelR,PixelC] = size(A);
    M = max(max(A));
    N = max(max(B));
    
    %%  Initializing matrices %%
    % CountA and CountB indicate matrix |A| and |B|
    CountA = zeros(1,M);
    CountB = zeros(1,N);
    Weights2D = zeros(M, N); % Indicates Wji
    Weight = zeros(1,M); % Indicates Wj
    Intersection = zeros(M,N);
    Union = zeros(M,N);
    
    %% Populating Intersection matrix %%
    for i=1:PixelR
        for j=1:PixelC
            if(A(i,j) ~= 0 && B(i,j) ~= 0)
                Intersection(A(i,j),B(i,j))= Intersection(A(i,j),B(i,j)) +1;
            end
        end
    end
    
    %% Populating Union matrix %%
    for i = 1:PixelR
        for j = 1:PixelC
            if(A(i,j) ~= 0 && B(i,j) ~= 0)
                if Intersection(A(i,j),B(i,j)) ~= 0 && Union(A(i,j), B(i,j)) == 0
                    Union(A(i,j),B(i,j)) = sum(A(:)==A(i,j)) + sum(B(:)==B(i,j)) - Intersection(A(i,j),B(i,j));
                end
            end
        end
    end
    
    %% Populating CountA and CountB matrices %%
    for i=1:M
        CountA(i) = sum(A(:)==i);
    end
    for i=1:N
        CountB(i) = sum(B(:)==i);
    end
     
    %% Calculating Wj %%
    for i=1:M
        Weight(i) = CountA(i)/sum(CountA);
    end
    
    %% Calculating Wji %%
    
    for i=1:M
        for j=1:N
            if Intersection(i,j)~=0
                denom = 0;
                for k=1:N
                    if(Intersection(i,k) ~= 0)
                        denom = denom + CountB(k);
                    end
                end
                Weights2D(i,j) = CountB(j)/denom;
            end
        end
    end
    
    %% Calculating index %%
    index = 0;
    
    for i=1:M
        innerRes = 0;
        for j=1:N
            if Intersection(i,j) ~= 0
                innerRes = innerRes + (Weights2D(i,j) * Intersection(i,j) / Union(i,j));
            end
        end
        index = index + (1-innerRes) * Weight(i);
    end
   
end