function fun_trainGaussian(numDim)
%  Loads the dataset. You should now have the
%  variables X, Xval, yval, Xtest, ytest in your environment
dataMLFileName = 'dataML.mat';
if exist(dataMLFileName, 'file') == 2
    load(dataMLFileName);
else
    disp('You should build dataML.mat first.');
    return;
end

%  Apply the same steps to the larger dataset
% X = X(:,1:numDim); % hided by Holy 1807301553
X = X(:,numDim); % added by Holy 1807301553
[muValue, Sigma2] = estimateGaussian(X);

if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
    Sigma2 = diag(Sigma2);
end

detSigma = det(Sigma2) ^ (-0.5);
invSigma = pinv(Sigma2);

%  Cross-validation set
% pval = multivariateGaussian(Xval, mu, Sigma2);
% Xval = Xval(:,1:numDim); % hided by Holy 1807301554
Xval = Xval(:,numDim); % added by Holy 1807301554
pval = multivariateGaussianFast(Xval, muValue, detSigma, invSigma);

%  Find the best threshold
[epsilon, F1] = selectThreshold(yval, pval);

gaussianParaFileName = 'gaussianPara.mat';
save(gaussianParaFileName,'detSigma','invSigma','epsilon','muValue');

disp('Gaussian training completed.');
end