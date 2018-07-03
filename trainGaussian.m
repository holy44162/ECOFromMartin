%  Loads the dataset. You should now have the
%  variables X, Xval, yval, Xtest, ytest in your environment
clear;
dataMLFileName = 'dataML.mat';
if exist(dataMLFileName, 'file') == 2
    load(dataMLFileName);
else
    disp('You should build dataML.mat first.');
    return;
end

%  Apply the same steps to the larger dataset
[mu, Sigma2] = estimateGaussian(X);

if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
    Sigma2 = diag(Sigma2);
end

detSigma = det(Sigma2) ^ (-0.5);
invSigma = pinv(Sigma2);

%  Cross-validation set
% pval = multivariateGaussian(Xval, mu, Sigma2);
pval = multivariateGaussianFast(Xval, mu, detSigma, invSigma);

%  Find the best threshold
[epsilon, F1] = selectThreshold(yval, pval);

gaussianParaFileName = 'gaussianPara.mat';
save(gaussianParaFileName,'detSigma','invSigma','epsilon','mu');

disp('Gaussian training completed.');