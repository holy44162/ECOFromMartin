function [F1,tp,fp,indMess,indFn] = fun_testScriptWithPara(bestParaMat,trainFolderName,CVFolderName,testFolderName,heightBias,widthBias,featureType)
load(bestParaMat,'bestPara');

dimInd = bestPara{1, 4};
hogSize = bestPara{1, 5};
imgEdge = bestPara{1, 6};
heightImgEdge = round(heightBias + imgEdge);
widthImgEdge = round(widthBias + imgEdge);

dataML = realWindingFeatureDataGen(trainFolderName,hogSize,heightImgEdge,widthImgEdge,featureType);
dataML = realWindingFeatureDataGen(CVFolderName,hogSize,heightImgEdge,widthImgEdge,featureType,dataML);
dataML = realWindingFeatureDataGen(testFolderName,hogSize,heightImgEdge,widthImgEdge,featureType,dataML);

gaussianPara = fun_trainGaussian(dataML,dimInd);
[F1,tp,fp,indMess,indFn] = fun_testGaussian(dataML,dimInd,gaussianPara);
end