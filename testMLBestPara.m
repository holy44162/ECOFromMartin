clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);

bestParaMat = 'bestPara1.mat';
heightBias = 30;
widthBias = 0;
trainFolderName = 'd:\data_seq\towerCrane\train\imgs\';
CVFolderName = 'd:\data_seq\towerCrane\CV\imgs\';
testFolderName = 'd:\data_seq\towerCrane\test\imgs\';

[F1,tp,fp,indMess] = fun_testScriptWithPara(bestParaMat,trainFolderName,CVFolderName,testFolderName,heightBias,widthBias);

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);