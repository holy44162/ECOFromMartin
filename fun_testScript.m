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

% hided by Holy 1808081011
% f = fopen('log.txt', 'a');
% fprintf(f,datestr(now));
% fprintf(f, ' ');
% fprintf(f, 'hogSize = %d, numDim =  %s, ',hogSize, num2str(numDim));
% fclose(f);
% end of hide 1808081011

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
sortedResult = sortrows(resultMatrix,'descend');

% remove lines with nan elements
nanTag = isnan(sortedResult);
nanInd = any(nanTag,2);
sortedResult(nanInd,:) = [];

% perform feature selection
% added by Holy 1808081051
maxF1Row = num2cell(sortedResult(1,:));
featureIDs = maxF1Row(4);
resultCell = cell(1,4);
selectedIDs = featureIDs;
for i = 1:size(sortedResult,1)
    if i > 1
        diff = length(featureIDs{1}) - length(selectedIDs{1});
        if diff == 0
            break;
        else
            selectedIDs = featureIDs;
        end
    end
    for j = 1:size(sortedResult,1)
        if sum(selectedIDs{1}==sortedResult(j,4)) == 1
            continue;
        end
        dimIDs = [selectedIDs{1} sortedResult(j,4)];
        gaussianPara = fun_trainGaussian(dataML,dimIDs);
        [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
        resultCell{1,4} = dimIDs;
        if resultCell{1,1} > maxF1Row{1}
            maxF1Row = resultCell;
            featureIDs = maxF1Row(4);
        end
    end
end
% end of addition 1808081051

% hided by Holy 1808081050
% numStep = 100;
% stepsize = (sortedResult(1,1) - sortedResult(end,1)) / numStep;
% 
% resultCell = cell(numStep+1,4);
% 
% maxF1Row = num2cell(sortedResult(1,:));

% j = 1;
% for F1Value = sortedResult(end,1):stepsize:sortedResult(1,1)
%     indSort = sortedResult(:,1)>=F1Value;
%     dimIDs = sortedResult(indSort,4);
%     dimIDs = dimIDs';
%     gaussianPara = fun_trainGaussian(dataML,dimIDs);
%     [resultCell{j,1},resultCell{j,2},resultCell{j,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
%     resultCell{j,4} = dimIDs;
%     if resultCell{j,1} > maxF1Row{1}
%         maxF1Row = resultCell(j,:);
%     end
%     j = j + 1;
% end
% end of hide 1808081050
end