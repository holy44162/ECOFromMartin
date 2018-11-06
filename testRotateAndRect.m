functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);

% inputImg = 'd:\data_seq\smallWinding\train\imgs\img00001.jpg';
inputImg = 'd:\data_seq\smallWinding1\train\imgs\img00001.jpg';
[pathName,fileName,fileExt] = fileparts(inputImg);
upDirName = getUpLevelPath(pathName, 2);
rectFilePathName = fullfile(upDirName, 'rect_anno.txt');
rotateFilePathName = fullfile(upDirName, 'angle_rotate.txt');

img = imread(inputImg);

figure,imshow(img);

tagTestAngle = true;
tagTestRect = true;
theta = 0;

while tagTestAngle
    prompt = 'please input the rotate angle';
    dlg_title = 'rotate angle';
    num_lines = [1 70];
    defaultans = {num2str(theta)};
    optionsPrompt.WindowStyle = 'normal';
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,optionsPrompt);
    if isempty(answer)
        val = theta;
        tagTestAngle = false;
        delete(gca);
        close;
        figure,imshow(imRotate);
    else
        val = str2double(answer{1,1});
        theta = val;
        tform = affine2d([cosd(theta) sind(theta) 0;...
            -sind(theta) cosd(theta) 0; 0 0 1]);
        imRotate = imwarp(img,tform);
        delete(gca);
        close;
        figure,imshow(imRotate);
    end
end

positionH = [10 10 50 50];
while tagTestRect
    h = imrect(gca, positionH);
    positionH = wait(h);
    delete(gca);
    close;
    figure,imshow(imRotate);
    hold on;
    rectangle('Position',positionH, 'EdgeColor','g', 'LineWidth',2);
    hold off;
    
    answer = questdlg('Confirmed?');
    if strcmpi(answer,'Yes')
        tagTestRect = false;
%         delete(gca);
%         close;
    else
        delete(gca);
        close;
        figure,imshow(imRotate);
    end
end

dlmwrite(rectFilePathName,positionH,'delimiter','\t');
dlmwrite(rotateFilePathName,theta,'delimiter','\t');