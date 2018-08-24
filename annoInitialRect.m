% addpath('d:\baiduSyn\files\phd\functions');
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'toolbox_general']);

% folder_name = 'd:\data_seq\sequences\windingRope\imgs';
% folder_name = 'd:\data_seq\sequences\windingRopeMess\imgs';
% folder_name = 'd:\data_seq\sequences\realWindingRopeTrain';
% folder_name = 'd:\data_seq\sequences\windingRopeVal\imgs';
% folder_name = 'd:\data_seq\sequences\realWindingRopesCompact\';
folder_name = 'd:\data\windingRope\20180801\dayLeft\imgs\';
upDirName = getUpLevelPath(folder_name, 1); % added by Holy 1808241005
% gtFilePathName = [folder_name(1:end-4) 'groundtruth_rect.txt']; % hided by Holy 1808241013
gtFilePathName = fullfile(upDirName, 'groundtruth_rect.txt'); % added by Holy 1808241013
if exist(gtFilePathName, 'file') == 2
    msgbox('groundtruth_rect.txt already exists.');
    return;
end
fileList = getAllFiles(folder_name);
rectMatrix = [];

for i = 1:length(fileList)
    dataPathName = fileList{i,1};
    [pathName,FileName,fileExt] = fileparts(dataPathName);
    
    if ~strcmpi(fileExt,'.bmp') && ~strcmpi(fileExt,'.jpg')
        continue;
    else
        if i == 1
            pic = imread(dataPathName);
            pic = double(pic);
            if max(max(pic(:,:,1))) > 3
                pic = pic./255;
            end
            figure, imshow(pic);
            h = imrect(gca, [10 10 50 50]);
            positionH = wait(h);
            delete(gca);
            close;
            break;
        end
        rectMatrix = [rectMatrix;positionH];
    end
%     progressbar(i, length(fileList));
end
rectMatrix = repmat(positionH,[length(fileList) 1]);
dlmwrite(gtFilePathName,rectMatrix,'delimiter','\t');
msgbox('Annotation completes.');