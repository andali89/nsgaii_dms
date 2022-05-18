% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
function [ popc ] = binTourSel( pop, empty_individual, paramGA)
%TOURSEL Summary of this function goes here
%   Detailed explanation goes here
       numpop = size(pop, 1);
       popc = repmat(empty_individual, numpop, 1);
       a1 = 1 : numpop;
       a2 = 1 : numpop;
       
       % shullfer
       for i = 1 : numpop
           randI = randi([i, numpop]);
           temp = a1(randI);
           a1(randI) = a1(i);
           a1(i) = temp;
           
           randI = randi([i, numpop]);
           temp = a2(randI);
           a2(randI) = a2(i);
           a2(i) = temp;
                     
       end
       
       for i = 1 : 4 : numpop
           parent1 = tournament(pop(a1(i)), pop(a1(i + 1)));
           parent2 = tournament(pop(a1(i + 2)), pop(a1(i + 3)));
          [ popc(i).Position, popc(i + 1).Position] = crossover(parent1.Position, parent2.Position, paramGA);
           
           parent1 = tournament(pop(a2(i)), pop(a2(i + 1)));
           parent2 = tournament(pop(a2(i + 2)), pop(a2(i + 3)));
          [ popc(i + 2).Position, popc(i + 3).Position ]= crossover(parent1.Position, parent2.Position, paramGA);
       end  
       
       

end

function ind = tournament(ind1, ind2)
if Dominates(ind1,ind2)
    ind = ind1;
    return;
end
if Dominates(ind2,ind1)
    ind = ind2;
    return;
end
if (ind1.CrowdingDistance > ind2.CrowdingDistance)
    ind = ind1;
elseif (ind1.CrowdingDistance < ind2.CrowdingDistance)
    ind = ind2;
else
    if(rand() < 0.5)
       ind = ind1;
    else
       ind = ind2;
    end
end


end

