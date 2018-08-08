function gaussianPara = fun_trainGaussian(dataML,dimInd)
%  Loads the dataset. You should now have the
%  variables X, Xval, yval, Xtest, ytest in your environment
% hided by Holy 1808071046
% dataMLFileName = 'dataML.mat';
% if exist(dataMLFileName, 'file') == 2
%     load(dataMLFileName);
% else
%     disp('You should build dataML.mat first.');
%     return;
% end
% end of hide 1808071046

%  Apply the same steps to the larger dataset
% X = X(:,1:numDim); % hided by Holy 1807301553
% X = X(:,dimInd); % added by Holy 1807301553 % hided by Holy 1808071050
X = dataML.X(:,dimInd); % added by Holy 1808071049
[muValue, Sigma2] = estimateGaussian(X);

if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
    Sigma2 = diag(Sigma2);
end

detSigma = det(Sigma2) ^ (-0.5);
invSigma = pinv(Sigma2);

%  Cross-validation set
% pval = multivariateGaussian(Xval, mu, Sigma2);
% Xval = Xval(:,1:numDim); % hided by Holy 1807301554
% Xval = Xval(:,dimInd); % added by Holy 1807301554 % hided by Holy 1808071051
Xval = dataML.Xval(:,dimInd); % added by Holy 1808071051
yval = dataML.yval; % added by Holy 1808071051
pval = multivariateGaussianFast(Xval, muValue, detSigma, invSigma);

%  Find the best threshold
[epsilon, F1] = selectThreshold(yval, pval);

% added by Holy 1808061548
gaussianPara.detSigma = detSigma;
gaussianPara.invSigma = invSigma;
gaussianPara.epsilon = epsilon;
gaussianPara.muValue = muValue;
% end of addition 1808061548

% hided by Holy 1808071057
% gaussianParaFileName = 'gaussianPara.mat';
% save(gaussianParaFileName,'detSigma','invSigma','epsilon','muValue');
% 
% disp('Gaussian training completed.');
% end of hide 1808071057
end