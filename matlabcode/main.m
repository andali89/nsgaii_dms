% Copyright (c) 2022, An-Da Li
% All rights reserved. Please read the "license.txt" for license terms.
% The Implementation of NSGAII-DMS algorithm.
% Author: An-Da Li 
% Email: andali1989@163.com

clc;
clear;
close all;
Startcpu=cputime;
% set the runseed for NSGAII
randseed = 1;
RandStream.setGlobalStream(RandStream('mt19937ar','seed',randseed));
% problem definition

problem.CostFunction=@(x) MOP4(x);
problem.nVar=3;             % Number of Decision Variables
methodname = 'NSGAIIDMS';


% GA params

paramGA.MaxIt=100;      % Maximum Number of Iterations
paramGA.nPop=100;        % Population Size
paramGA.pc = 0.9;
paramGA.pm = 1 / problem.nVar;
paramGA.VarMin= -5;          % Lower Bound of Variables
paramGA.VarMax= 5;
paramGA.eta_c = 20;
paramGA.eta_m = 20;
paramGA.dmseval =15000;
paramGA.alfaini = 0.4;
paramGA.beta = 0.85;
% run NSGAII-DMS
[NonSolutions, iter_result] = NSGAIIDMS(problem, paramGA);
PlotCosts(NonSolutions);
finalsolution = perfectpoint(NonSolutions);
CPUtime = cputime-Startcpu;

