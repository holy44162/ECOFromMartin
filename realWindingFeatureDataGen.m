function realWindingFeatureDataGen(folder_name,hogSize,numDim)
% clear;
tStart = tic;
functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'gda']);

% set parameters here
% hogSize = 38; % hog feature cell size
% numDim = 27; % reduced dim in pca
debug = false;
if debug
    addpath([functionPath 'toolbox_general']);
end

% folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
fileList = getAllFiles(folder_name);

% % added by Holy 1807271108
% refImg = imread(fileList{1, 1});
% [rowRefImg, colRefImg, ~] = size(refImg);
% biasHeight = round(rowRefImg/biasHRatio);
% biasWidth = round(colRefImg/biasWRatio);
% % end of addition 1807271108

% added by Holy 1807271328
refImg = imread(fileList{1, 1});
% hogInputRefImg = refImg(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
hogInputRefImg = refImg;
hogFeature = extractHOGFeatures(hogInputRefImg,'CellSize',[hogSize hogSize]);
lenHogFeature = length(hogFeature);
% end of addition 1807271328

% % added by Holy 1807271516
% binary_picture = imbinarize(rgb2gray(refImg),'adaptive','Sensitivity',1);
% gaborArray = gaborFilterBank(5,8,39,39);
% gaborFeature = gaborFeatures(binary_picture,gaborArray,4,4);
% gaborFeature = gaborFeature';
% % end of addition 1807271516

% get up level dir
[dirName,~,~] = fileparts(fileList{1, 1});
upDirName = getUpLevelPath(dirName, 1);

searchKey1 = 'Train';
searchKey2 = 'CV';
searchKey3 = 'Test';

firstFilePathName = fileList{1, 1};

if contains(firstFilePathName, searchKey1)
%     X = []; % hided by Holy 1807271332
    X = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    
    % added by Holy 1807271622
    trainLabelPathName = fullfile(upDirName, 'imgsTag.txt');
    trainLabelFileID = fopen(trainLabelPathName);
    trainLabelCell = textscan(trainLabelFileID,'%d');
    trainLabel = cell2mat(trainLabelCell);
    trainLabel = trainLabel';
    fclose(trainLabelFileID);
    % end of addition 1807271622
end
if contains(firstFilePathName, searchKey2)
%     Xval = []; % hided by Holy 1807271335
    Xval = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    yvalPathName = fullfile(upDirName, 'y_CV.txt');
    yvalFileID = fopen(yvalPathName);
    yvalCell = textscan(yvalFileID,'%d');
    yval = cell2mat(yvalCell);
    fclose(yvalFileID);
end
if contains(firstFilePathName, searchKey3)
%     Xtest = []; % hided by Holy 1807271336
    Xtest = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    ytestPathName = fullfile(upDirName, 'y_Test.txt');
    ytestFileID = fopen(ytestPathName);
    ytestCell = textscan(ytestFileID,'%d');
    ytest = cell2mat(ytestCell);
    fclose(ytestFileID);
end

searchKey = 'img';
searchFileExt = '.jpg';

% added by Holy 1807271652
if contains(firstFilePathName, searchKey1)
    gdaImgPath = fullfile(upDirName, 'imgsTargetGda');
    fileListGda = getAllFiles(gdaImgPath);
    XGda = zeros(length(fileListGda), lenHogFeature);
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end
    
    ppmGda = ParforProgMon('', length(fileListGda));
    parfor i = 1:length(fileListGda)
        windImgN = imread(fileListGda{i, 1});
        
        %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
        hogInputImg = windImgN;
        
        hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
        
        %             X = [X;hogWindRope]; % hided by Holy 1807271336
        XGda(i,:) = hogWindRope; % added by Holy 1807271337
        
        ppm.increment();
    end
end
% end of addition 1807271652

if ~debug
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end
    
    ppm = ParforProgMon('', length(fileList));
    
    if contains(firstFilePathName, searchKey1)
        parfor i = 1:length(fileList)
            windImgN = imread(fileList{i, 1});
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
            hogInputImg = windImgN;
                        
            hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
            
%             X = [X;hogWindRope]; % hided by Holy 1807271336
            X(i,:) = hogWindRope; % added by Holy 1807271337
            
            ppm.increment();
        end
    end
    if contains(firstFilePathName, searchKey2)
        parfor i = 1:length(fileList)
            windImgN = imread(fileList{i, 1});
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
            hogInputImg = windImgN;
                        
            hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
            
%             Xval = [Xval;hogWindRope]; % hided by Holy 1807271338
            Xval(i,:) = hogWindRope; % added by Holy 1807271337
            
            ppm.increment();
        end
    end
    if contains(firstFilePathName, searchKey3)
        parfor i = 1:length(fileList)
            windImgN = imread(fileList{i, 1});
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
            hogInputImg = windImgN;
                        
            hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
            
%             Xtest = [Xtest;hogWindRope]; % hided by Holy 1807271338
            Xtest(i,:) = hogWindRope; % added by Holy 1807271337
            
            ppm.increment();
        end
    end
    
%     % fprintf('Progress:\n');
%     % fprintf(['\n' repmat('.',1,length(fileList)) '\n\n']);
%     parfor i = 1:length(fileList)
%         %     fprintf('\b|\n');
%         [~,FileName,fileExt] = fileparts(fileList{i, 1});
%         if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
%             continue;
%         else
%             windImgN = imread(fileList{i, 1});
%             %             windImgN = imbinarize(rgb2gray(windImgN),'adaptive','Sensitivity',1); % added by Holy 1807261112
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
%             
%             if contains(firstFilePathName, searchKey1)
%                 X = [X;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey2)
%                 Xval = [Xval;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey3)
%                 Xtest = [Xtest;hogWindRope];
%             end
%         end
%         ppm.increment();
%     end
else
    for i = 1:length(fileList)
        progressbar(i, length(fileList));
        [~,FileName,fileExt] = fileparts(fileList{i, 1});
        if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
            continue;
        else
            windImgN = imread(fileList{i, 1});
            hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
            if i == 1
                testImgId = 1009;
%                 testImgId = 319;
                testImg = imread(fileList{testImgId, 1});
%                 [rowTestImg, colTestImg, ~] = size(testImg);
%                 biasHeight = round(rowTestImg/5);
%                 biasWidth = round(colTestImg/11);
%                 testImgWithBias = testImg(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
                testImgWithBias = testImg;
                hogInputImg = testImgWithBias;
%                 processedImage = imbinarize(rgb2gray(testImg),'adaptive','Sensitivity',1);
                %                 se1 = strel('disk', 2);
                %                 processedImage = imdilate(processedImage, se1);
                %                 [featureVector,hogVisualization] = extractHOGFeatures(processedImage,...
                %                     'CellSize',[hogSize hogSize],'NumBins',9);
                [featureVector,hogVisualization] = extractHOGFeatures(hogInputImg,...
                    'CellSize',[hogSize hogSize],'NumBins',9);
                figure;
                imshow(testImg);
                figure;
                imshow(hogInputImg);
                hold on;
                plot(hogVisualization,'Color','r');
                hold off;
                return;
            end
            if contains(firstFilePathName, searchKey1)
                X = [X;hogWindRope];
            end
            if contains(firstFilePathName, searchKey2)
                Xval = [Xval;hogWindRope];
            end
            if contains(firstFilePathName, searchKey3)
                Xtest = [Xtest;hogWindRope];
            end
        end
    end
end

dataMLFileName = 'dataML.mat';

if contains(firstFilePathName, searchKey1)
%     [~,X,~] = pca(X,'NumComponents',numDim);
    
    % added by Holy 1807271629
    trainData = XGda';
    trainGda = gda(trainData,trainData,trainLabel);
    X = trainGda';
    X = X(1:end-10,:);
    % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
        save(dataMLFileName,'X','trainData','trainLabel','-append');
    else
        save(dataMLFileName,'X','trainData','trainLabel');
    end
end
if contains(firstFilePathName, searchKey2)
%     [~,Xval,~] = pca(Xval,'NumComponents',numDim);
    
    % added by Holy 1807271629
    load(dataMLFileName);
    testGda = gda(Xval',trainData,trainLabel);
    Xval = testGda';
    % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
        save(dataMLFileName,'Xval','yval','-append');
    else
        save(dataMLFileName,'Xval','yval');
    end
end
if contains(firstFilePathName, searchKey3)
%     [~,Xtest,~] = pca(Xtest,'NumComponents',numDim);
    
    % added by Holy 1807271629
    load(dataMLFileName);
    testGda = gda(Xtest',trainData,trainLabel);
    Xtest = testGda';
    % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
        save(dataMLFileName,'Xtest','ytest','-append');
    else
        save(dataMLFileName,'Xtest','ytest');
    end
end
disp('Mission accomplished.');

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);

if ~debug
    if contains(firstFilePathName, searchKey1)
        typeWord = searchKey1;
    end
    if contains(firstFilePathName, searchKey2)
        typeWord = searchKey2;
    end
    if contains(firstFilePathName, searchKey3)
        typeWord = searchKey3;
    end
    f = fopen('log.txt', 'a');
    if contains(firstFilePathName, searchKey1)
        fprintf(f,datestr(now));
        fprintf(f, ' ');
    end
    fprintf(f, [typeWord ' time: ']);
    fprintf(f, '%d min, ',totalElapsedTime/60);
    if contains(firstFilePathName, searchKey3)
        fprintf(f, 'hogSize = %d, numDim =  %d, ',hogSize, numDim);
    end
    fclose(f);
end
end