 function [Y, U, Lambda, Mu] = PCAbyDG(X, NComps);
%function [Y, U, Lambda, Mu] = PCAbyDG(X, NComps);
%
%%% To compute transform of N x 1 vector x, use U'*(x-Mu)
%
%INPUTS:
%
% X is either:
%        (1) a B x N Matrix
%           and the columns of X are spectra 
%     or
%        (2) an NRows x NCols X B Spectral Data Cube
%     where
%        B = Number of Bands
%        N = Number of Spectra
%
% NComps is the number of components to keep.  Must be >=1.
%
%OUTPUTS:
% Y      = first NComps Principal Components sorted by decreasing variance
% U      = B x B matrix of eigenvectors of the covariance matrix
% Lambda = B x 1 vector of eigenvalues  of the covariance matrix
% Mu     = mean of columns of X
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author:  Darth Gader %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%% REFORMAT X AS A BxN MATRIX IF IT IS NRows x NCols x B %%%
%%% THROW AN ERROR IF X IS 1D OR >3D %%%
Sx    = size(X);
NDims = min(4,length(Sx)); 
switch NDims
    case 1
        error('Error: Not enough Dimensions');
    case 3
        N = Sx(1)*Sx(2);
        B = Sx(3);
        X = shiftdim(X, 2);
        X = reshape(X, [B, N]);
    case 4
        error('Error: Too many Dimensions');
end

%%% CALCULATE MEAN AND SUBTRACT IT %%%
[B,N] = size(X);
Mu    = mean(X, 2);
BigMu = repmat(Mu, [1, N]);
Xz    = X-BigMu;

%%
%%% CALCULATE COVARIANCE MATRIX %%%
C = (1/(N-1))*Xz*Xz';
%%
%%% GET EIGENVALUES AND EIGENVECTORS OF COVARIANCE MATRIX %%%
[U, Lambda] = eig(C);

%%% REVERSE ORDER OF EIGENVALUES FROM INCREASING TO DECREASING %%%
% PermMat = fliplr(eye(B));
% Lambda  = PermMat*Lambda*PermMat;
% U       = PermMat*U';
Lambda  = diag(Lambda);
[Lambda,Index]= sort(Lambda,'descend'); % to sort eigenvalues in decresing order
 U= U(:,Index);
 U=U';
%%% STORE EIGENVALUES IN VECTOR INSTEAD OF DIAGONAL MATRIX %%%
Lambda  = diag(Lambda);

%%% COMPUTE TRANSFORMATION AND REDUCE DIMENSIONALITY
Y = U*Xz;
Y = Y(1:NComps, :);

%%% MAKE MATRIX SIZE CONSISTENT WITH MNFbyDG %%%
Y = Y';

%%% THE END %%%
end