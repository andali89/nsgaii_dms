% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li based on the code of Yarpiz 
% Email: andali1989@163.com
% Ideal point method
function output = perfectpoint(NonSolutions,sign)
    numS = size(NonSolutions, 1);
  
    Costs = [NonSolutions.Cost]';
    idealorg = min(Costs);
     
    uCosts = zscore(Costs);
    if nargin ==2
        uCosts = Costs;
        disp('do not normalize!')
    end
    idealpoint = min(uCosts);
    
    
    dist_norm=zeros(numS,1);
    for i= 1:  numS
       dist_norm(i)=norm(uCosts(i,:)-idealpoint);
    end
    
    [~,I_dist]=min(dist_norm);
    output = NonSolutions(I_dist);
    output.idealCosts = idealorg;
%    hold on
%    plot(idealorg(1),idealorg(2),'co','MarkerSize',8);
%    plot(output.Cost(1),output.Cost(2),'b*','MarkerSize',8);


end