%% Sequential importance sampling: Ex. 2 Ref. 2 - linear function of independent exponential
%{
---------------------------------------------------------------------------
Created by:
Sebastian Geyer (s.geyer@tum.de)
Matthias Willer
Daniel Koutas
Engineering Risk Analysis Group   
Technische Universitat Munchen
www.bgu.tum.de/era
---------------------------------------------------------------------------
First version: 2018-05
---------------------------------------------------------------------------
Current version: 2022-04
* Inclusion of sensitivity analysis
---------------------------------------------------------------------------
Comments:
* The SIS method in combination with a Gaussian Mixture model can only be
  applied for low-dimensional problems, since its accuracy decreases
  dramatically in high dimensions.
---------------------------------------------------------------------------
Based on:
1."Sequential importance sampling for structural reliability analysis"
   Papaioannou et al.
   Structural Safety 62 (2016) 66-75
2."MCMC algorithms for subset simulation"
   Papaioannou et al.
   Probabilistic Engineering Mechanics 41 (2015) 83-103.
---------------------------------------------------------------------------
%}
clear; close all; clc;

%% definition of the random variables
% d      = 100;         % number of dimensions
d      = 2;         % number of dimensions
pi_pdf = repmat(ERADist('exponential','PAR',1),d,1);   % n independent rv

% % correlation matrix
% R = eye(d);   % independent case
% 
% % object with distribution information
% pi_pdf = ERANataf(pi_pdf,R);    % if you want to include dependence

%% limit-state function
% Ca = 140;
Ca = 10;
g  = @(x) Ca - sum(x, 2);

%% Implementation of sensitivity analysis: 1 - perform, 0 - not perform
sensitivity_analysis = 1;

%% Samples return: 0 - none, 1 - final sample, 2 - all samples
samples_return = 2;

%% Sequential importance sampling
N      = 3000;    % total number of samples for each level
p      = 0.1;     % N/number of chains per level
k_init = 3;       % initial number of Gaussians in the Mixture Model (GM)
burn   = 0;       % burn-in period
tarCOV = 1.5;     % target COV of weights

fprintf('\nSIS method: \n');
method = 'aCS';
switch method
   case 'GM'
      [Pf_SIS, lv, samplesU, samplesX, k_fin, S_F1] = SIS_GM(N, p, g, pi_pdf, k_init, burn, tarCOV, sensitivity_analysis, samples_return);
   case 'aCS'
      [Pf_SIS, lv, samplesU, samplesX, S_F1] = SIS_aCS(N, p, g, pi_pdf, burn, tarCOV, sensitivity_analysis, samples_return);
   otherwise
      error('Choose GM or aCS methods');
end

%% Reference values
% The reference values for the first order indices
S_F1_ref   = [0.2021, 0.1891];

% Print reference values for the first order indices
fprintf("***Reference first order Sobol' indices: ***\n");
disp(S_F1_ref);

% exact solution
lambda = 1;
pf_ex  = 1 - gamcdf(Ca,d,lambda);

% show p_f results
fprintf('\n***Exact Pf: %g ***', pf_ex);
fprintf('\n***SIS Pf: %g ***\n\n', Pf_SIS);