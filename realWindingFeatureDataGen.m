function realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio)
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
% addpath([functionPath 'toolbox_general']);

% folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
fileList = getAllFiles(folder_name);

% added by Holy 1807271108
% refImg = imread(fileList{1, 1});
% [rowRefImg, colRefImg, ~] = size(refImg);
% biasHeight = round(rowRefImg/biasHRatio);
% biasWidth = round(colRefImg/biasWRatio);
% end of addition 1807271108

% added by Holy 1808021415
refImg = imread(fileList{1, 1});
refImg = refImg(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
% end of addition 1808021415

% added by Holy 1807271328
% refImg = imread(fileList{1, 1}); % hided by Holy 1808021349
% hogInputRefImg = refImg(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
% hogInputRefImg = refImg;
hogFeature = extractHOGFeatures(refImg,'CellSize',[hogSize hogSize]);
lenHogFeature = length(hogFeature);
% end of addition 1807271328

% added by Holy 1807311554
gaborMatrix = gaborFilterBank(5,8,39,39);
% gaborArray = gaborMatrix(1,2:4); % hided by Holy 1808011143
gaborArray = gaborMatrix; % added by Holy 1808011143
refImgD = im2double(refImg);
refImgDG = rgb2gray(refImgD);
% gaborFeature = gaborFeatures(refImgDG,gaborArray,4,4); % hided by Holy 1808031111
% lenGaborFeature = length(gaborFeature); % hided by Holy 1808031111
% end of addition 1807311554

% added by Holy 1808031111
[~,gaborResult] = gaborFeatures(refImgDG,gaborArray,4,4);
varValueRef = complexCellAbsVar(gaborResult);
lenGaborFeature = length(varValueRef);
% end of addition 1808031111

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
%     X = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    X = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     X = zeros(length(fileList), 7); % added by Holy 1808011535
    
%     % added by Holy 1807271622
%     trainLabelPathName = fullfile(upDirName, 'imgsTag.txt');
%     trainLabelFileID = fopen(trainLabelPathName);
%     trainLabelCell = textscan(trainLabelFileID,'%d');
%     trainLabel = cell2mat(trainLabelCell);
%     trainLabel = trainLabel';
%     fclose(trainLabelFileID);
%     % end of addition 1807271622
end
if contains(firstFilePathName, searchKey2)
%     Xval = []; % hided by Holy 1807271335
%     Xval = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    Xval = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     Xval = zeros(length(fileList), 7); % added by Holy 1808011535
    yvalPathName = fullfile(upDirName, 'y_CV.txt');
    yvalFileID = fopen(yvalPathName);
    yvalCell = textscan(yvalFileID,'%d');
    yval = cell2mat(yvalCell);
    fclose(yvalFileID);
end
if contains(firstFilePathName, searchKey3)
%     Xtest = []; % hided by Holy 1807271336
%     Xtest = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    Xtest = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     Xtest = zeros(length(fileList), 7); % added by Holy 1808011535
    ytestPathName = fullfile(upDirName, 'y_Test.txt');
    ytestFileID = fopen(ytestPathName);
    ytestCell = textscan(ytestFileID,'%d');
    ytest = cell2mat(ytestCell);
    fclose(ytestFileID);
end

searchKey = 'img';
searchFileExt = '.jpg';

% % added by Holy 1807271652
% if contains(firstFilePathName, searchKey1)
%     gdaImgPath = fullfile(upDirName, 'imgsTargetGda');
%     fileListGda = getAllFiles(gdaImgPath);
%     XGda = zeros(length(fileListGda), lenHogFeature);
%     poolobj = gcp('nocreate'); % If no pool, do not create new one.
%     if isempty(poolobj)
%         parpool;
%     end
%     
%     ppmGda = ParforProgMon('', length(fileListGda));
%     parfor i = 1:length(fileListGda)
%         windImgN = imread(fileListGda{i, 1});
%         
%         %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%         hogInputImg = windImgN;
%         
%         hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
%         
%         %             X = [X;hogWindRope]; % hided by Holy 1807271336
%         XGda(i,:) = hogWindRope; % added by Holy 1807271337
%         
%         ppmGda.increment();
%     end
% end
% % end of addition 1807271652

if ~debug
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end
    
    ppm = ParforProgMon('', length(fileList));

    if contains(firstFilePathName, searchKey1)
        parfor i = 1:length(fileList)
%             progressbar(i, length(fileList));
            windImgN = imread(fileList{i, 1});
            
            windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%             hogInputImg = windImgN; % hided by Holy 1807311454
            % added by Holy 1807311455
            hogInputImg5 = im2double(windImgN);
            hogInputImg2 = rgb2gray(hogInputImg5);
            hogInputImg3 = adapthisteq(hogInputImg2);
            hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
            hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
            % end of addition 1807311455
            
            hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
                        
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4); % hided by Holy 1808011537
            [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
            
            % added by Holy 1808031117            
            varValue = complexCellAbsVar(gaborResult);
            X(i,:) = varValue;
            % end of addition 1808031117
            
%             X = [X;hogWindRope]; % hided by Holy 1807271336
%             X(i,:) = hogWindRope; % added by Holy 1807271337
%             X(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             X(i,:) = sumDiff;
%             % end of addition 1808011539
            
            ppm.increment();
        end
    end

    if contains(firstFilePathName, searchKey2)
        parfor i = 1:length(fileList)
%             progressbar(i, length(fileList));
            windImgN = imread(fileList{i, 1});
            
            windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%             hogInputImg = windImgN; % hided by Holy 1807311457
            
            % added by Holy 1807311455
            hogInputImg5 = im2double(windImgN);
            hogInputImg2 = rgb2gray(hogInputImg5);
            hogInputImg3 = adapthisteq(hogInputImg2);
            hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
            hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
            % end of addition 1807311455
            
            hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
            
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4); % hided by Holy 1808011542
            [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
            
            % added by Holy 1808031117            
            varValue = complexCellAbsVar(gaborResult);
            Xval(i,:) = varValue;
            % end of addition 1808031117
            
%             Xval = [Xval;hogWindRope]; % hided by Holy 1807271336
%             Xval(i,:) = hogWindRope; % added by Holy 1807271337
%             Xval(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             Xval(i,:) = sumDiff;
%             % end of addition 1808011539
            
            ppm.increment();
        end
    end
    if contains(firstFilePathName, searchKey3)
        parfor i = 1:length(fileList)
%             progressbar(i, length(fileList));
            windImgN = imread(fileList{i, 1});
            
            windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
            
%             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%             hogInputImg = windImgN; % hided by Holy 1807311458
            
            % added by Holy 1807311455
            hogInputImg5 = im2double(windImgN);
            hogInputImg2 = rgb2gray(hogInputImg5);
            hogInputImg3 = adapthisteq(hogInputImg2);
            hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
            hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
            % end of addition 1807311455
            
            hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
            
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4);
            [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
            
            % added by Holy 1808031117            
            varValue = complexCellAbsVar(gaborResult);
            Xtest(i,:) = varValue;
            % end of addition 1808031117
            
%             Xtest = [Xtest;hogWindRope]; % hided by Holy 1807271336
%             Xtest(i,:) = hogWindRope; % added by Holy 1807271337
%             Xtest(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             Xtest(i,:) = sumDiff;
%             % end of addition 1808011539
            
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
    % hided by Holy 1808011545
    % added by Holy 1807301407
    XMean = mean(X);
    X = bsxfun(@minus,X,XMean);
    % end of addition 1807301407
%     [coeff,X,~] = pca(X,'NumComponents',numDim); % hided by Holy 1807301434
    % added by Holy 1807301434
    [coeff,X,~] = pca(X);
%     X = X(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301434
    % end of hide 1808011545
    
%     % added by Holy 1807271629
%     trainData = XGda';
%     trainGda = gda(trainData,trainData,trainLabel);
%     X = trainGda';
%     X = X(1:end-10,:);
%     % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
%         save(dataMLFileName,'X','trainData','trainLabel','-append'); % hided by Holy 1807301124
%         save(dataMLFileName,'X','-append'); % hided by Holy 1807301417
        save(dataMLFileName,'X','coeff','XMean','-append'); % added by Holy 1807301419
    else
%         save(dataMLFileName,'X','trainData','trainLabel'); % hided by Holy 1807301124
%         save(dataMLFileName,'X','-v7.3'); % hided by Holy 1807301420
        save(dataMLFileName,'X','coeff','XMean','-v7.3'); % added by Holy 1807301419
    end
end
if contains(firstFilePathName, searchKey2)
%     [~,Xval,~] = pca(Xval,'NumComponents',numDim); % hided by Holy 1807301422
    % hided by Holy 1808011548
    % added by Holy 1807301421
    load(dataMLFileName, 'coeff', 'XMean');
    Xval = bsxfun(@minus,Xval,XMean);
    Xval = Xval*coeff;
%     Xval = Xval(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301421
    % end of hide 1808011548
    
%     % added by Holy 1807271629
%     load(dataMLFileName, 'trainLabel', 'trainData');
%     testGda = gda(Xval',trainData,trainLabel);
%     Xval = testGda';
%     % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
        save(dataMLFileName,'Xval','yval','-append');
    else
        save(dataMLFileName,'Xval','yval','-v7.3');
    end
end
if contains(firstFilePathName, searchKey3)
%     [~,Xtest,~] = pca(Xtest,'NumComponents',numDim); % hided by Holy 1807301422
    % hided by Holy 1808011550
    % added by Holy 1807301421
    load(dataMLFileName, 'coeff', 'XMean');
    Xtest = bsxfun(@minus,Xtest,XMean);
    Xtest = Xtest*coeff;
%     Xtest = Xtest(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301421
    % end of hide 1808011550
    
%     % added by Holy 1807271629
%     load(dataMLFileName, 'trainLabel', 'trainData');
%     testGda = gda(Xtest',trainData,trainLabel);
%     Xtest = testGda';
%     % end of addition 1807271629
    
    if exist(dataMLFileName, 'file') == 2
        save(dataMLFileName,'Xtest','ytest','-append');
    else
        save(dataMLFileName,'Xtest','ytest','-v7.3');
    end
end
disp('Mission accomplished.');

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);

% hided by Holy 1807301456
% if ~debug
%     if contains(firstFilePathName, searchKey1)
%         typeWord = searchKey1;
%     end
%     if contains(firstFilePathName, searchKey2)
%         typeWord = searchKey2;
%     end
%     if contains(firstFilePathName, searchKey3)
%         typeWord = searchKey3;
%     end
%     f = fopen('log.txt', 'a');
%     % hided by Holy 1807301440
% %     if contains(firstFilePathName, searchKey1)
% %         fprintf(f,datestr(now));
% %         fprintf(f, ' ');
% %     end
%     % end of addition 1807301440
%     
%     fprintf(f, [typeWord ' time: ']);
%     fprintf(f, '%d min, ',totalElapsedTime/60);
%     if contains(firstFilePathName, searchKey3)
%         fprintf(f, 'hogSize = %d, numDim =  %d, ',hogSize, numDim);
%     end
%     fclose(f);
% end
% end of hide 1807301456
end