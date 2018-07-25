clear;
tic
functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);

folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
fileList = getAllFiles(folder_name);

% get up level dir
[dirName,~,~] = fileparts(fileList{1, 1});
upDirName = getUpLevelPath(dirName, 1);

searchKey1 = 'realWindingRopeTrain';
searchKey2 = 'realWindingRopeCV';
searchKey3 = 'realWindingRopeTest';
% searchKey1 = 'windingRopeTrain';
% searchKey2 = 'windingRopeCV';
% searchKey3 = 'windingRopeTest';
if contains(fileList{1, 1}, searchKey1)
    X = [];
end
if contains(fileList{1, 1}, searchKey2)
    Xval = [];
    yvalPathName = fullfile(upDirName, 'y_CV.txt');
    yvalFileID = fopen(yvalPathName);
    yvalCell = textscan(yvalFileID,'%d');
    yval = cell2mat(yvalCell);
    fclose(yvalFileID);
end
if contains(fileList{1, 1}, searchKey3)
    Xtest = [];    
    ytestPathName = fullfile(upDirName, 'y_Test.txt');
    ytestFileID = fopen(ytestPathName);
    ytestCell = textscan(ytestFileID,'%d');
    ytest = cell2mat(ytestCell);
    fclose(ytestFileID);
end

searchKey = 'img';
searchFileExt = '.jpg';

for i = 1:length(fileList)
    progressbar(i, length(fileList));
    [~,FileName,fileExt] = fileparts(fileList{i, 1});
    if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
        continue;
    else
        windImgN = imread(fileList{i, 1});        
        hogWindRope = extractHOGFeatures(windImgN,'CellSize',[32 32]);        
        
        if contains(fileList{i, 1}, searchKey1)
            X = [X;hogWindRope];
        end
        if contains(fileList{i, 1}, searchKey2)
            Xval = [Xval;hogWindRope];            
        end
        if contains(fileList{i, 1}, searchKey3)
            Xtest = [Xtest;hogWindRope];
        end
    end
end

numDim = 10;
dataMLFileName = 'dataML.mat';

if contains(fileList{1, 1}, searchKey1)
    [~,X,~] = pca(X,'NumComponents',numDim);
    
    if exist(dataMLFileName, 'file') == 2
        save('dataML.mat','X','-append');
    else
        save('dataML.mat','X');
    end
end
if contains(fileList{1, 1}, searchKey2)
    [~,Xval,~] = pca(Xval,'NumComponents',numDim);
    
    if exist(dataMLFileName, 'file') == 2
        save('dataML.mat','Xval','yval','-append');
    else
        save('dataML.mat','Xval','yval');
    end
end
if contains(fileList{1, 1}, searchKey3)
    [~,Xtest,~] = pca(Xtest,'NumComponents',numDim);
    
    if exist(dataMLFileName, 'file') == 2
        save('dataML.mat','Xtest','ytest','-append');
    else
        save('dataML.mat','Xtest','ytest');
    end
end
disp('Mission accomplished.');
toc