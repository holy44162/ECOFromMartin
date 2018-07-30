clear;

hogSize = 38; % hog feature cell size
numDim = 7; % reduced dim in pca
trainTag = false;
% biasHRatio = 9; % video tracked target's height bias ratio
% biasWRatio = 11; % video tracked target's width bias ratio

f = fopen('log.txt', 'a');
fprintf(f,datestr(now));
fprintf(f, ' ');
fprintf(f, 'hogSize = %d, numDim =  %d, ',hogSize, numDim);
fclose(f);

if trainTag
    % train
    folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,numDim);
    
    % CV
    folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,numDim);
    
    % test
    folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
    realWindingFeatureDataGen(folder_name,hogSize,numDim);
end

trainGaussian;

testGaussian;