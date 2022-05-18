% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
function [ F_fs, F_l, popKeepl, ele ] = checkFronts( F, nPop )
%CHECKFRONTS Summary of this function goes here
%   F_fs denotes the fronts of the first N f1+...+fn < nPop
%   f_l denotes the fronts of the N+1  f1+...+fn > nPop
    count = 0;
    F_fs{1} = [];
    F_l{1}= [];
    for i = 1 : numel(F)
        count = count + length(F{i}); 
        
        if count >= nPop
            F_l{1} = F{i};
            ele = count - nPop;
            popKeepl = length(F{i}) - ele;
            if ele ==0
               F_fs{i} = F{i}; 
            end
            break;
        else
            F_fs{i} = F{i};    
        end
    end
   
end

