function varValue = complexCellAbsVar(complexCell)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
testr2 = cellfun(@abs,complexCell,'UniformOutput',false);
test1r2 = cellfun(@(x) var(x,0,2),testr2,'UniformOutput',false);
matValue = cell2mat(test1r2);
varValue = matValue(:);
varValue = varValue';
end

