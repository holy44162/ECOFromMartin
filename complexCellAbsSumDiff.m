function [sumDiff,sumValue] = complexCellAbsSumDiff(complexCell,indDirection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
testr2 = cellfun(@abs,complexCell,'UniformOutput',false);
test1r2 = cellfun(@(x) sum(x(:)),testr2,'UniformOutput',false);
test2r2 = cell2mat(test1r2);
sumValue = sum(test2r2);
sumDiff = bsxfun(@minus,sumValue(indDirection),sumValue);
sumDiff(indDirection) = [];
end

