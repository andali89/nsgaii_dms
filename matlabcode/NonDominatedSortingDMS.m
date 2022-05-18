% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li based on the code of Yarpiz 
% Email: andali1989@163.com


function [ NS, F ] = NonDominatedSortingDMS( NS, newSol )
% Update NS with newSol   
   for i = 1 : numel(newSol)
       j = 1;
       newSol(i).DominatedCount = 0;
       while true
           if j > numel(NS)
              break; 
           end
           ns = NS(j).Cost;
           new = newSol(i).Cost;
           if isequal(ns,new) || Dominates(ns, new)
               % if new solution is dominated by a solution in NS
               newSol(i).DominatedCount = 1;
               break;             
           else
               % if new solution is not dominated by a solution in NS
              if Dominates(new, ns)
                  % eliminate a solution from NS and ajust j
                  NS(j) = [];
                  j = j - 1;
              % else
                  % new soltion do not dominate a solution in NS
                  % and a solution in NS do not dominate new solution
                  % add new solution to NS
              end               
           end
           j = j + 1;
       end  
       if newSol(i).DominatedCount == 0
           NS = [NS;
                 newSol(i)];
       end
   end
   F{1}= 1 : numel(NS);

end

