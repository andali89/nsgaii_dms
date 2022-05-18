% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
% the dynamic crowding distance calculation method which can obtian more
% uniformly distributed soutions

function  [pop, F] = smoothPop(pop, F, nPop)
%SMOOTHPOP Summary of this function goes here
%   Detailed explanation goes here
% select all the solutions in the 1st front
numF1 = length(F{1});
pop=pop(F{1});
[pop,ind, d]=CalCD(pop);

if nPop <= 2
    cds = [pop.CrowdingDistance];
    [~,I] = sort(cds,'descend');
    pop = pop(I(1 : nPop));
    return;
end
% ind stores the consistence index for each objective
% Sort Based on Crowding Distance
%[~, CDSO]=sort([pop.CrowdingDistance],'descend');
% CDSO stores the index based on CrowdingDistance, should be updated after
% each element eliminated
%cds = [pop.CrowdingDistance];
CDSO = 1: numF1;
for i = 1 : numF1 - nPop  
    cds = [pop(CDSO).CrowdingDistance];
    [~,I] = min(cds);    
    eleIndex = CDSO(I); 
    CDSO(I) = [];   
    %disp(['i:', num2str(i),', eleIndex:', num2str(eleIndex)]);
    %CDSO(numF1 - i +1) = []; % eliminate the last one
    [pop,ind, d] = updateCD(pop, ind, d, eleIndex); % update the crowding distance of the nearest instances of eleIndex
    % resorting based on neighbors    
    %CDSO = resorting(pop, CDSO, neighbors);
end
 pop=pop(CDSO);
end

function CDSO = resorting(pop, CDSO, neighbors)

    numNei = length(neighbors);
    eindex = zeros(1, numNei);
    for i = 1: numNei       
        eindex(i) = find(CDSO == neighbors(i), 1);
    end
    CDSO(eindex) = [];
    for i = 1: numNei
       % Insert       
       for j = length(CDSO) : -1 : 1          
           if pop(neighbors(i)).CrowdingDistance == inf
               CDSO = [neighbors(i), CDSO];
               break; 
           elseif pop(neighbors(i)).CrowdingDistance < pop(CDSO(j)).CrowdingDistance
               %insert after J              
               CDSO = myinsert(CDSO, neighbors(i), j);               
               break; 
           end
       end
       
    end

end
function NCDSO = myinsert(CDSO,eindex, j)
      if j< length(CDSO)
          NCDSO = [CDSO(1: j), eindex, CDSO(j+ 1: end)];
      else 
          NCDSO = [CDSO(1: j), eindex];
          disp('fffff')
      end
end

function [pop, indn, d, neighbors] = updateCD(pop, ind, d, eleIndex)
     [m,n] = size(ind);
     cs=[pop.Cost];
     indn = zeros(m - 1, n);
     
     neighborMatrix = zeros(2 , n);
     mask = ones(m, n);
     for j = 1 : n   
         
         k = find(ind(:, j) == eleIndex,1);                
         mask(k,j) = 0;         
         indn(:, j) = ind(logical(mask(:,j)'),j);         
         tind = indn(:, j);         
         neighborMatrix(1, j) = tind(k - 1);
         neighborMatrix(2, j) = tind(k);
         if pop(tind(k - 1)).CrowdingDistance ~= inf            
             d(tind(k - 1),j) = abs(cs(j,tind(k))-cs(j,tind(k-2)))/abs(cs(j,tind(1))-cs(j,tind(end)));
         end
         if pop(tind(k)).CrowdingDistance ~= inf          
             d(tind(k),j) = abs(cs(j,tind(k+1))-cs(j,tind(k-1)))/abs(cs(j,tind(1))-cs(j,tind(end)));
         end         
         
     end
     neighbors = unique(neighborMatrix(:));
     for i = 1: length(neighbors)
          pop(neighbors(i)).CrowdingDistance=sum(d(neighbors(i),:));
          if isnan(pop(neighbors(i)).CrowdingDistance)
              pop(neighbors(i)).CrowdingDistance = 100;
          end
     end
end
function [pop,ind, d]=CalCD(pop)        
        Costs=[pop.Cost];        
        [nObj,n]=size(Costs);         
        d=zeros(n,nObj);
        ind = zeros(n, nObj);        
        for j=1:nObj            
            [cj, so]=sort(Costs(j,:));            
            d(so(1),j)=inf;
            ind(:, j) = so';                       
            for i=2:n-1                
                d(so(i),j)=abs(cj(i+1)-cj(i-1))/abs(cj(1)-cj(end));  
                
            end            
            d(so(end),j)=inf;
            
        end        
        
        for i=1:n            
            pop(i).CrowdingDistance=sum(d(i,:)); 
            if isnan(pop(i).CrowdingDistance)
               pop(i).CrowdingDistance = 100;
            end
        end        
      


end


