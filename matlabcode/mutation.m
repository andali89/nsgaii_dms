% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com
function [ popm ] = mutation( pop, empty_individual, paramGA )
%MUTATION 
% generate  new population using mutation
npop = size(pop, 1);
popm = repmat(empty_individual, npop, 1);
numV = length(pop(1).Position);
if length(paramGA.VarMax) ==1 
    vmax = repmat(paramGA.VarMax, 1, numV);
    vmin = repmat(paramGA.VarMin, 1, numV);
else
    vmax = paramGA.VarMax;
    vmin = paramGA.VarMin;
end

eta_m = paramGA.eta_m;
pm = paramGA.pm;

for i = 1 : npop
    popm(i).Position = mutate(pop(i).Position, numV, vmax, vmin, pm, eta_m );
end

end
% real polynomial mutation of an individual
function indi = mutate(indi, numV, vmax, vmin, pm, eta_m)

for i = 1 : numV
   if rand() <= pm
       y = indi(i);
       yL = vmin(i);
       yU = vmax(i);
       delta1 = (y - yL) / (yU - yL);
       delta2 = (yU -y) / (yU - yL);
       randnum = rand();
       mut_pow = 1.0 / (eta_m + 1.0);
       if(randnum <= 0.5)
          xy = 1.0 - delta1;
          val = 2.0 * randnum + (1.0 - 2.0 * randnum) * (xy^(eta_m + 1));
          deltaq = val ^ mut_pow - 1.0;
       else
           xy = 1.0 - delta2;
          val = 2.0 * (1.0 - randnum) + 2.0 * (randnum - 0.5) * (xy^(eta_m + 1));
          deltaq = 1.0 -  val ^ mut_pow ;
       end
       y = y + deltaq * (yU - yL);
       if (y < yL)
           y = yL;
       end
       if (y > yU)
          y = yU; 
       end
       indi(i) = y;
   end    
end


end

