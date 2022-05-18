% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% Coded by An-Da Li based on the code of Yarpiz 
% Email: andali1989@163.com
% This version of NSGA-II adopts a dynamic crowding distance calculation (function SmoothPop)
% method to obain more uniformly distributed solutions





function [NonSolutions, iter_result] = NSGAIIDMS(problem, paramGA)
%% Problem Definition
CostFunction = problem.CostFunction;
nVar = problem.nVar;
VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin = paramGA.VarMin;
VarMax = paramGA.VarMax;
% Number of Objective Functions
nObj=numel(CostFunction(unifrnd(VarMin,VarMax,VarSize)));

% DMS 
beta = paramGA.beta;
alfaini = paramGA.alfaini;
%% NSGA-II Parameters

MaxIt=paramGA.MaxIt;      % Maximum Number of Iterations

nPop = paramGA.nPop; 


%% Initialization

empty_individual = genempty(nObj, alfaini);
pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
end

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop, F]=SortPopulation(pop);
F1=pop(F{1});
disp(['Iteration ' num2str(1) ': Number of F1 Members = ' num2str(numel(F1))]);
%% NSGA-II Main Loop
iter_this = [[1,nPop],{[F1.Cost]'}]; % Save the iterations informations
iter_result = iter_this;
for it= 2 : MaxIt
    
    % Crossover
    popn  = binTourSel( pop, empty_individual, paramGA);
   
    
    % Mutation
    popn=mutation(popn, empty_individual, paramGA);
    for k = 1 : nPop
        popn(k).Cost=CostFunction(popn(k).Position);
    end

    
    % Merge
    pop=[popn;
         pop]; %#ok
     
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop, nPop);

   
    
    
    % added by LAD for getting solutions more smoothly 
    
    % Truncate
    if  length(F{1}) > nPop
        % modified distance calculating
        [pop] = smoothPop(pop, F, nPop);
        F1=pop;
        disp('smooth sorting');
    else
        [ F_fs, F_l, popKeepl, ele ] = checkFronts( F, nPop );
        % Calculate Crowding Distance
        pop=CalcCrowdingDistance(pop,F_fs);
        newPop = [];
        
        for nf = 1 : numel(F_fs)
            newPop = [newPop; pop(F_fs{nf})];
        end
        
        if ele ~= 0
            [pop] = smoothPop(pop, F_l, popKeepl);
            newPop = [newPop; pop];
        end
        % Sort Population
        [pop, F] = SortPopulation(newPop);
        %pop=pop(1:nPop);
        %F = selecF(F, nPop);
        F1=pop(F{1});
    end
  
    % Non-Dominated Sorting
%     [pop, F]=NonDominatedSorting(pop);
% 
%     % Calculate Crowding Distance
%     pop=CalcCrowdingDistance(pop,F);
% 
%     % Sort Population
%     [pop, F]=SortPopulation(pop);
    
    % Store F1
    
   
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    iter_this = [[it, it * nPop],{[F1.Cost]'}]; % Save the iterations informations   
    iter_result = [iter_result; iter_this];
    % Plot F1 Costs
%     figure(1);
%     PlotCosts(F1);
%     pause(0.01);
    
%     if numel(F1)>=5 && change == 1
%         CostFunction=@(x) desirabilityFunc2(x);
%         for i=1:nPop       
%             pop(i).Cost=CostFunction(pop(i).Position);            
%         end        
%         % Non-Dominated Sorting
%         [pop, F]=NonDominatedSorting(pop);
%         
%         % Calculate Crowding Distance
%         pop=CalcCrowdingDistance(pop,F);
%         
%         % Sort Population
%         [pop, F]=SortPopulation(pop);
%         change = 0;
%     end
    
end

% DMS process
disp('DMS process')
evalNum = paramGA.dmseval;
eval_time = 0;

paraDMS.VarMin = paramGA.VarMin;
paraDMS.VarMax = paramGA.VarMax;
paraDMS.nObj = nObj;
paraDMS.alphaini = alfaini;
paraDMS.dir_dense = 1;
paraDMS.CostFunction = CostFunction;

while eval_time < evalNum
    
    
    pollDis = [[F1.pollNum]', [F1.CrowdingDistance]']; 
    [~, index] = sortrows(pollDis, [1 -2]);    
    F1(index(1)).ifpoll = 1;
    F1(index(1)).pollNum = F1(index(1)).pollNum + 1;
    pollCenter = F1(index(1));
    [newSol, eval] = DMS_process(pollCenter, paraDMS);
    eval_time = eval_time + eval;
    
         
    % Non-Dominated Sorting
    % Update F1 with new solution
    [F1, F]=NonDominatedSortingDMS(F1, newSol);
    
    % check and update NS.alfa
    pollInd = find([F1.ifpoll] == 1);
    if ~isempty(pollInd)
        F1(pollInd).ifpoll = 0;
    end
    ind = find([F1.pollNum] == -1);
    if ~isempty(ind) 
        % poll succeed  
       for c = ind
           F1(c).pollNum = 0;
          % F1(c).pollNum = pollCenter.pollNum; 
       end        
    elseif ~isempty(pollInd)
       % poll do not succeed       
       F1(pollInd).alfa = F1(pollInd).alfa * beta;        
    end
    
    
    if  length(F{1}) > nPop
        % modified distance calculating
        [F1] = smoothPop(F1, F, nPop);       
        disp('smooth sorting');
    else        
        % Calculate Crowding Distance
        F1=CalcCrowdingDistance(F1,F);     
    end
    
    disp(['Iteration ' num2str(MaxIt + eval_time / 100) ': Number of F1 Members = ' num2str(numel(F1))]);
    iter_this = [[MaxIt + eval_time / 100, MaxIt * nPop + eval_time],{[F1.Cost]'}]; % Save the iterations informations   
    iter_result = [iter_result; iter_this];
    
    
%     PlotCosts(F1);
%     pause(0.01);
    
end


NonSolutions =mysort(F1);
%NonSolutions = evalPeformance(NonSolutions, rg);

end
%% Results

