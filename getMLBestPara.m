clear;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);

maxHogSize = 64;
maxImgEdge = 60;
heightBias = 30;
widthBias = 0;
numImgEdgeStep = 2;
numHogSizeStep = 2;
bestPara = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep);
save('bestPara.mat','bestPara');