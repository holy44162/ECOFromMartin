% for i = 0
%     j = i
%     k = 1+i
% end

functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);

% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00005.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00098.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00186.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00202.jpg'; % FN
inputImg = 'd:\data_seq\smallWinding\test\imgs\img00291.jpg'; % FN tag
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00331.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00493.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00751.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00790.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00828.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00933.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img00984.jpg'; % FN
% inputImg = 'd:\data_seq\smallWinding\test\imgs\img01540.jpg'; % FN tag


[pathName,fileName,fileExt] = fileparts(inputImg);
upDirName = getUpLevelPath(pathName, 2);
rectFilePathName = fullfile(upDirName, 'rect_anno.txt');
rotateFilePathName = fullfile(upDirName, 'angle_rotate.txt');

if exist(rectFilePathName, 'file')
    rectWinding = dlmread(rectFilePathName);
    rectWinding = round(rectWinding);
else
    error(['couldn''t find ' rectFilePathName]);
end

if exist(rotateFilePathName, 'file')
    theta = dlmread(rotateFilePathName);
else
    error(['couldn''t find ' rotateFilePathName]);
end

% read the image in a matrix
img = imread(inputImg);
if (size(img,3) ~= 1)
  img = rgb2gray(img);
end

% hided by Holy 1810310832
% % rotate img
% tform = affine2d([cosd(theta) sind(theta) 0;...
% -sind(theta) cosd(theta) 0; 0 0 1]);
% imgRotated = imwarp(img,tform);
% 
% % rect of img
% imgRected = imgRotated(rectWinding(2):rectWinding(2)+rectWinding(4)-1, ...
%     rectWinding(1):rectWinding(1)+rectWinding(3)-1, :);
% end of hide 1810310832

imgRected = fun_rotateRect(img, theta, rectWinding);
% figure, imshow(imgRected);

% inputImg = 'd:\temp\enhancement.png';
% imgRected = imread(inputImg);
% if (size(imgRected,3) ~= 1)
%   imgRected = rgb2gray(imgRected);
% end

hogInputImg = imbinarize(imgRected,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6);
figure, imshow(hogInputImg);

% hogInputImg2 = adapthisteq(imgRected);
% hogInputImg2 = adapthisteq(hogInputImg2,'NumTiles',[4,4]);
% hogInputImg2 = adapthisteq(hogInputImg2,'NumTiles',[2,2]);
% figure, imshow(hogInputImg2);

% net = denoisingNetwork('DnCNN');
% denoisedI = denoiseImage(hogInputImg2, net);
% figure, imshow(denoisedI);

denoisedI1 = medfilt2(imgRected);
hogInputImg1 = imbinarize(denoisedI1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6);
figure, imshow(hogInputImg1);