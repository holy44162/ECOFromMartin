function varValue = complexCellAbsVar(complexCell)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
testr2 = cellfun(@abs,complexCell,'UniformOutput',false);
test1r2 = cellfun(@(x) var(x,0,2),testr2,'UniformOutput',false);
matValue = cell2mat(test1r2);
varValue = matValue(:);
varValue = varValue';
end

