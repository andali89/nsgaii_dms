% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com

function [ empty_individual ] = genempty(nObj, alfaini)
% Generate Empty Solution
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];
empty_individual.nearIndex= zeros(2 * nObj);
empty_individual.pollNum = 0;
empty_individual.ifpoll = 0;
empty_individual.alfa = alfaini;
end

