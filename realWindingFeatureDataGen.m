clear;
tStart = tic;
functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'ParforProgMon']);

% set parameters here
hogSize = 64; % hog feature cell size
numDim = 15; % reduced dim in pca
debug = false;
if debug
    addpath([functionPath 'toolbox_general']);
end

% folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
fileList = getAllFiles(folder_name);

% get up level dir
[dirName,~,~] = fileparts(fileList{1, 1});
upDirName = getUpLevelPath(dirName, 1);

searchKey1 = 'Train';
searchKey2 = 'CV';
searchKey3 = 'Test';

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

if ~debug
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end
    
    ppm = ParforProgMon('', length(fileList));
    
    % fprintf('Progress:\n');
    % fprintf(['\n' repmat('.',1,length(fileList)) '\n\n']);
    parfor i = 1:length(fileList)
        %     fprintf('\b|\n');
        [~,FileName,fileExt] = fileparts(fileList{i, 1});
        if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
            continue;
        else
            windImgN = imread(fileList{i, 1});
            hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
            
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
        ppm.increment();
    end
else
    for i = 1:length(fileList)
        progressbar(i, length(fileList));
        [~,FileName,fileExt] = fileparts(fileList{i, 1});
        if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
            continue;
        else
            windImgN = imread(fileList{i, 1});
            hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
            
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
end

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

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);

if contains(fileList{1, 1}, searchKey1)
    typeWord = searchKey1;
end
if contains(fileList{1, 1}, searchKey2)
    typeWord = searchKey2;
end
if contains(fileList{1, 1}, searchKey3)
    typeWord = searchKey3;
end
f = fopen('log.txt', 'a');
if contains(fileList{1, 1}, searchKey1)
    fprintf(f,datestr(now));
    fprintf(f, ' ');
end
fprintf(f, [typeWord ' time: ']);
fprintf(f, '%d min, ',totalElapsedTime/60);
if contains(fileList{1, 1}, searchKey3)
    fprintf(f, 'hogSize = %d, numDim =  %d, ',hogSize, numDim);
end
fclose(f);