clear;

hogSize = 38; % hog feature cell size
% numDim = [1:8]; % reduced dim in pca, model best para.
numDim = [1:14]; % reduced dim in pca
trainTag = true;
% trainTag = false;
% biasHRatio = 9; % video tracked target's height bias ratio
% biasWRatio = 11; % video tracked target's width bias ratio

f = fopen('log.txt', 'a');
fprintf(f,datestr(now));
fprintf(f, ' ');
fprintf(f, 'hogSize = %d, numDim =  %s, ',hogSize, num2str(numDim));
fclose(f);

if trainTag
    % train
    folder_name = 'd:\data_seq\sequences\realWindingRopeTrainCompact1\imgsTarget\';
%     folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize);
    
    % CV
    folder_name = 'd:\data_seq\sequences\realWindingRopeCVCompact1\imgsTarget\';
%     folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize);
    
    % test
    folder_name = 'd:\data_seq\sequences\realWindingRopeTestCompact1\imgsTarget\';
%     folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize);
end

fun_trainGaussian(numDim);

fun_testGaussian(numDim);