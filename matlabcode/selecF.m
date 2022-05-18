% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
function [ F ] = selecF(F, nPop )
eleNum = length(F);
cumNum = 0;
flag = 0;
delindex = [];
for i = 1 : eleNum
    if flag == 1
       delindex = [delindex, i];
       
       continue;        
    end
    if (cumNum + length(F{i})) >= nPop
       F{i} =  F{i}(1 : (nPop - cumNum));
       flag = 1;
    end
    cumNum = cumNum + length(F{i});
end
F(delindex) = [];
end

