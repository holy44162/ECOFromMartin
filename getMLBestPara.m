clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);

maxHogSize = 64;
maxImgEdge = 60;
heightBias = 30;
widthBias = 0;
numImgEdgeStep = 2;
numHogSizeStep = 2;
bestPara = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep);
save('bestPara.mat','bestPara');

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);