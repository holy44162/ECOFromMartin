function fun_testScript(hogSize,biasHRatio,biasWRatio)
% clear;

% hogSize = 64; % hog feature cell size % hided by Holy 1808060828
% numDim = [1:8]; % reduced dim in pca, model best para.
% numDim = [30]; % reduced dim in pca % hided by Holy 1808060845

% added by Holy 1808060831
dataMLFileName = 'dataML.mat';
if exist(dataMLFileName, 'file') == 2
    trainTag = false;
    dataML = load(dataMLFileName);
else
    trainTag = true;
end
% end of addition 1808060831

% hided by Holy 1808060833
% % trainTag = true;
% trainTag = false;
% end of hide 1808060833

% biasHRatio = 90; % video tracked target's height bias ratio % hided by Holy 1808060828
% biasWRatio = 60; % video tracked target's width bias ratio % hided by Holy 1808060828

f = fopen('log.txt', 'a');
fprintf(f,datestr(now));
fprintf(f, ' ');
fprintf(f, 'hogSize = %d, numDim =  %s, ',hogSize, num2str(numDim));
fclose(f);

if trainTag
    % train
    folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTrain\imgsTarget\';
    %     folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
    
    % CV
    folder_name = 'd:\data_seq\sequences\realWindingRopesCompactCV\imgsTarget\';
    %     folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
    
    % test
    folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTest\imgsTarget\';
    %     folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
    
    dataML = load(dataMLFileName);
end

numDim = size(dataML.X,2);
resultMatrix = zeros(numDim,4);
for i = 1:numDim
    gaussianPara = fun_trainGaussian(dataML,i);
    
    [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
    resultMatrix(i,4) = i;
end
sortedResult = sortrows(test,'descend');

% remove lines with nan elements
nanTag = isnan(sortedResult);
nanInd = any(nanTag,2);
sortedResult(nanInd,:) = [];

stepsize = (sortedResult(1,1) - sortedResult(end,1)) / 100;

maxF1Row = sortedResult(1,:);
for F1Value = sortedResult(end,1):stepsize:sortedResult(1,1)
end
end