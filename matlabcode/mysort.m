% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
%
function [ S ] = mysort( F1 )
%MYSORT Summary of this function goes here
%   Detailed explanation goes here
numS = size(F1, 1);
empty_individual.Position=[];
empty_individual.Cost=[];
S = repmat(empty_individual,numS,1);
costM = [F1.Cost]';

[~, index] = sortrows(costM, 1);

for i = 1: numS
    S(i).Position = F1(index(i)).Position;
    S(i).Cost = F1(index(i)).Cost;
end
end

