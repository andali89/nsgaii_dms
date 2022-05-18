% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
function [ nind1, nind2 ] = crossover( ind1, ind2, paramGA )
%CROSSOVER Summary of this function goes here
%   Detailed explanation goes here
numV = length(ind1);

if numV > 1
    % added 2022/1/3
   approb = 0.5; % The probability for applying SBX to a variable
   
else
   approb = 1; 
end

pc = paramGA.pc;
eta_c = paramGA.eta_c;
if length(paramGA.VarMax) ==1 
    vmax = repmat(paramGA.VarMax, 1, numV);
    vmin = repmat(paramGA.VarMin, 1, numV);
else
    vmax = paramGA.VarMax;
    vmin = paramGA.VarMin;
end

nind1 = ind1; 
nind2 = ind2;
if rand() > pc
   return;
end
% perform SBX crossover
for j = 1 : numV
    if(rand() <= approb)
        randnum = rand();
        y1 = min(ind1(j), ind2(j));
        y2 = max(ind1(j), ind2(j));
        yL = vmin(j);
        yU = vmax(j);
        beta = 1.0 + (2.0 * (y1 - yL) / (y2 - y1));
        alpha = 2.0 - beta ^(-(eta_c + 1.0));
        if(randnum < (1.0 / alpha))
            betaq = (randnum * alpha) ^ (1.0 / (eta_c + 1.0));
        else
            betaq = (1.0 / (2.0 - randnum * alpha)) ^ (1.0 / (eta_c + 1.0));
        end
        c1 = 0.5 * ((y1 + y2) - betaq * (y2 - y1));
        
        beta = 1.0 + (2.0 * (yU - y2) / (y2 - y1));
        alpha = 2.0 - beta ^(-(eta_c + 1.0));
        if(randnum < (1.0/ alpha))
            betaq = (randnum * alpha) ^ (1.0 / (eta_c + 1.0));
        else
            betaq = (1.0 / (2.0 - randnum * alpha)) ^ (1.0 / (eta_c + 1.0));
        end
        c2 = 0.5 * ((y1 + y2) + betaq * (y2 - y1));
        
        if (c1 < yL)
            c1 = yL;
        end
        if(c1 > yU)
            c1 = yU;
        end
        if (c2 < yL)
            c2 = yL;
        end
        if(c2 > yU)
            c2 = yU;
        end
        
        if(rand() < 0.5)
            nind1(j) = c1;
            nind2(j) = c2;
        else
            nind1(j) = c2;
            nind2(j) = c1;
        end
    end
end
    
    


end

