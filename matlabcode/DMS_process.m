% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com

function [newSol, eval_time] = DMS_process(pollCenter, parameter)
%DMS_PROCESS Summary of this function goes here
%   perform DMS process
% input: NS---- a set of non-dominated solutions
%        parameter---- parameters for DMS

% output: NS_o ---- updated NS by DMS
%         newSol ---- new solutions generated



%% get parameters
nObj = parameter.nObj; 
alphaini = parameter.alphaini;
ubound = parameter.VarMax;
lbound = parameter.VarMin;

CostFunction = parameter.CostFunction;

dir_dense = parameter.dir_dense;
n = size(pollCenter.Position, 2);
%% Generate the positive basis.
%pollnum=pollnum+1
 if (dir_dense == 0)
    D = [eye(n) -eye(n)];
 else
    v     = 2 * rand(n ,1) - 1;
    [Q,R] = qr(v);
    if ( R(1) > 1 )
       %D = Q * [ eye(n) -eye(n) ];
       D = [ eye(n); -eye(n) ] * Q;
    else
       %D = Q * [ -eye(n) eye(n) ];
       D = [ -eye(n); eye(n) ] * Q;
    end
 end
 nd = size(D, 1); % number of basises to do poll step
empty_individual = genempty(nObj, alphaini);
empty_individual.pollNum = -1;
newSol = repmat(empty_individual,nd,1);
eval_time = nd;
%% poll process
 for i = 1 : nd  
    newSol(i).Position = pollCenter.Position + pollCenter.alfa * D(i, :);
    % make the rpos_temp in the range of [ lbound, ubound]    
    newSol(i).Position(newSol(i).Position >= ubound)=ubound;    
    newSol(i).Position(newSol(i).Position <= lbound)=lbound;

    newSol(i).Cost=CostFunction(newSol(i).Position); 
    newSol(i).alfa = pollCenter.alfa;
    
    
 end
 %% update NS
 
    

end

