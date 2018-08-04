clear;

hogSize = 64; % hog feature cell size
% numDim = [1:8]; % reduced dim in pca, model best para.
numDim = [9 11 15 17 19]; % reduced dim in pca
% trainTag = true;
trainTag = false;
biasHRatio = 90; % video tracked target's height bias ratio
biasWRatio = 60; % video tracked target's width bias ratio

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
end

fun_trainGaussian(numDim);

fun_testGaussian(numDim);