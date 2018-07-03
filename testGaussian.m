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

gaussianParaFileName = 'gaussianPara.mat';
if exist(gaussianParaFileName, 'file') == 2
    load(gaussianParaFileName);
else
    disp('You should train Gaussian model first.');
    return;
end

%  test set
ptest = multivariateGaussianFast(Xtest, mu, detSigma, invSigma);

numMess = sum(ptest < epsilon);
indMess = find(ptest < epsilon)+1;

testPredictions = (ptest < epsilon);
tp = sum((testPredictions == 1) & (ytest == 1));
fp = sum((testPredictions == 1) & (ytest == 0));
fn = sum((testPredictions == 0) & (ytest == 1));

prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*prec*rec/(prec+rec);

disp(['The total number of mess frames is: ' num2str(numMess)]);
disp(['The indices of mess frames are: ' num2str(indMess')]);
disp(['The F1 score is: ' num2str(F1)]);