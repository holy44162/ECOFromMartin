clear;

hogSize = 38; % hog feature cell size
numDim = 9; % reduced dim in pca
% biasHRatio = 9; % video tracked target's height bias ratio
% biasWRatio = 11; % video tracked target's width bias ratio

folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
realWindingFeatureDataGen(folder_name,hogSize,numDim);

folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
realWindingFeatureDataGen(folder_name,hogSize,numDim);

folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
realWindingFeatureDataGen(folder_name,hogSize,numDim);

trainGaussian;

testGaussian;