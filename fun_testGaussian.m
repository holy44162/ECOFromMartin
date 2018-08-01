function fun_testGaussian(numDim)
%  Loads the dataset. You should now have the
%  variables X, Xval, yval, Xtest, ytest in your environment
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
% Xtest = Xtest(:,1:numDim); % hided by Holy 1807301554
% Xtest = Xtest(:,numDim); % added by Holy 1807301554
ptest = multivariateGaussianFast(Xtest, muValue, detSigma, invSigma);

numMess = sum(ptest < epsilon);
% indMess = find(ptest < epsilon)+1;
indMess = find(ptest < epsilon);

testPredictions = (ptest < epsilon);
tp = sum((testPredictions == 1) & (ytest == 1));
fp = sum((testPredictions == 1) & (ytest == 0));
fn = sum((testPredictions == 0) & (ytest == 1));

prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*prec*rec/(prec+rec);

disp(['The total number of mess frames is: ' num2str(numMess)]);
disp(['The indices of mess frames are: ' num2str(indMess')]);
disp(['tp is: ' num2str(tp)]);
disp(['fn is: ' num2str(fn)]);
disp(['fp is: ' num2str(fp)]);
disp(['The F1 score is: ' num2str(F1)]);

f = fopen('log.txt', 'a');
fprintf(f, 'tp = %d, fp =  %d, F1 =  %d\r\n\r\n',tp, fp, F1);
fclose(f);
end