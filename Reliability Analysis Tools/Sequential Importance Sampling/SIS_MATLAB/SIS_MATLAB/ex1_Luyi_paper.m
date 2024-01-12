%% Sequential importance sampling: Ex. 1 Ref. 2 - strongly nonlinear and non-monotonic LSF
%{
---------------------------------------------------------------------------
Created by:
Daniel Koutas
Engineering Risk Analysis Group   
Technische Universitat Munchen
www.bgu.tum.de/era
---------------------------------------------------------------------------
First version: 2022-04
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
2."Global reliability sensitivity estimation based on failure samples"
   Luyi et al.
   Structural Safety 81 (2019) 101871
---------------------------------------------------------------------------
%}

clear; close all; clc;

%% definition of the random variables
d      = 3;          % number of dimensions
pi_pdf = repmat(ERADist('standardnormal','PAR'), 3, 1);   % n independent rv

% % correlation matrix
% R = eye(d);   % independent case
% 
% % object with distribution information
% pi_pdf = ERANataf(pi_pdf, R);    % if you want to include dependence

%% limit state function
g    = @(x) x(:,1).^3+10*x(:,2).^2+0.1*sin(pi*x(:,2))+10*x(:,3).^2+40*sin(pi*x(:,3))+38;

%% Sequential importance sampling
N      = 8000;    % total number of samples for each level
p      = 0.1;     % N/number of chains per level
k_init = 3;       % initial number of Gaussians in the Mixture Model (GM)
burn   = 0;       % burn-in period
tarCOV = 1.5;     % target COV of weights

fprintf('\nSIS method: \n');
method = 'GM';
switch method
   case 'GM'
      [Pf_SIS, lv, samplesU, samplesX, k_fin, S_F1] = SIS_GM(N, p, g, pi_pdf, k_init, burn, tarCOV);
   case 'aCS'
      [Pf_SIS, lv, samplesU, samplesX, S_F1] = SIS_aCS(N, p, g, pi_pdf, burn, tarCOV);
   otherwise
      error('Choose GM or aCS methods');
end

% reference solution
pf_ref    = 0.0062;
MC_S_F1  = [0.0811, 0.0045, 0.0398]; % approximately read and extracted from paper
 
% show results
fprintf('\n***Reference Pf: %g ***', pf_ref);
fprintf('\n***SuS Pf: %g ***\n\n', Pf_SIS);

fprintf('\n***MC sensitivity indices:');
disp(MC_S_F1);
fprintf('\n***SIS sensitivity indices:');
disp(S_F1);