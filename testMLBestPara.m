clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);

bestParaMat = 'bestPara.mat';
heightBias = 30;
widthBias = 0;
% hided by Holy 1809051115
% trainFolderName = 'd:\data_seq\towerCrane\train\imgs\';
% CVFolderName = 'd:\data_seq\towerCrane\CV\imgs\';
% testFolderName = 'd:\data_seq\towerCrane\test\imgs\';
% end of hide 1809051115

% added by Holy 1809051115
trainFolderName = 'd:\data_seq\towerCraneCompact\train\imgs\';
CVFolderName = 'd:\data_seq\towerCraneCompact\CV\imgs\';
testFolderName = 'd:\data_seq\towerCraneCompact\test2\imgs\';
% end of addition 1809051115

% featureType = 'hogOnly'; % added by Holy 1809051546
% featureType = 'gaborMax'; % added by Holy 1809051546
featureType = 'gaborBWHog'; % added by Holy 1809111558

[F1,tp,fp,indMess,indFn] = fun_testScriptWithPara(bestParaMat,trainFolderName,CVFolderName,testFolderName,heightBias,widthBias,featureType);

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);