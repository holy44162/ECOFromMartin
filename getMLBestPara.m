clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);
addpath([functionPath 'gabor']);

maxHogSize = 64;
maxImgEdge = 60; % hided by Holy 1809061537
% maxImgEdge = 120; % added by Holy 1809061538
% heightBias = 30; % hided by Holy 1809191536
heightBias = 0; % added by Holy 1809191536
widthBias = 0;
% hided by Holy 1808290928
% numImgEdgeStep = 1;
% numHogSizeStep = 6;
% end of hide 1808290928

% hided by Holy 1809111600
% added by Holy 1808290928
numImgEdgeStep = 6;
numHogSizeStep = 6;
% end of addition 1808290928
% end of hide 1809111600

% added by Holy 1809051115
trainFolderName = 'd:\data_seq\towerCraneCompact\trainWithoutP2\imgs\';
CVFolderName = 'd:\data_seq\towerCraneCompact\CV\imgs\';
testFolderName = 'd:\data_seq\towerCraneCompact\test\imgs\';
% end of addition 1809051115

% featureType = 'hogOnly';
% featureType = 'gaborMax'; % added by Holy 1809051614
featureType = 'gaborBWHog'; % added by Holy 1809111558

bestPara = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep,trainFolderName,CVFolderName,testFolderName,featureType);
save('bestPara.mat','bestPara');

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);