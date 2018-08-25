clear;
% tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath('C:\Users\James\Downloads\SoundZone_Tools-master\SoundZone_Tools-master');
addpath('C:\Users\James\Downloads\parfor_progress');

% video_path = 'd:\data\windingRope\20180801\dayLeft\imgs\';
video_path = 'd:\data\windingRope\20180801\dayLeft\imgsFixedTargets\imgs\';
% video_path = 'd:\test\imgs\'; % just for test
groundtruth_rectPath = getUpLevelPath(video_path, 1);

targetImgsPath = fullfile(groundtruth_rectPath, 'imgsFixedTargets');
if exist(targetImgsPath, 'dir') ~= 7
    mkdir(targetImgsPath);
end

groundtruth_rectPathName = fullfile(groundtruth_rectPath, 'groundtruth_rect.txt');

ground_truth = dlmread(groundtruth_rectPathName);
% ground_truth1 = dlmread(groundtruth_rectPathName,'\t',[0 0 0 3]); % read only one line ,so run faster

rect_position = ground_truth(1,:);

numImgs = size(ground_truth,1);

if exist([video_path num2str(1, 'img%05i.png')], 'file')
    img_files = num2str((1:numImgs)', [strrep(video_path, '\', '\\') 'img%05i.png']);
elseif exist([video_path num2str(1, 'img%05i.jpg')], 'file')
    img_files = num2str((1:numImgs)', [strrep(video_path, '\', '\\') 'img%05i.jpg']);
elseif exist([video_path num2str(1, 'img%05i.bmp')], 'file')
    img_files = num2str((1:numImgs)', [strrep(video_path, '\', '\\') 'img%05i.bmp']);
else
    error('No image files to load.')
end
frames = cellstr(img_files);

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool;    
end

% ppm = ParforProgMon('', numImgs);
% added by Holy 1808251606
fprintf('\t Completion: ');
showTimeToCompletion; startTime=tic;
p = parfor_progress(numImgs);
% end of addition 1808251606
parfor i = 1:numImgs
    [pathName,FileName,fileExt] = fileparts(frames{i,1});
    im = imread(frames{i,1});
    windImg = imcrop(im,rect_position);
    saveFileName = fullfile(targetImgsPath, [FileName fileExt]);
    imwrite(windImg,saveFileName);
    % added by Holy 1808251606
    p = parfor_progress;
    showTimeToCompletion( p/100, [], [], startTime );
    % end of addition 1808251606
%     ppm.increment();
end
% toc