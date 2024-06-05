% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function [vpl, hpl, sig_acc, emt] = araim_baseline_v4_2(G, sigflt2_int, sigflt2_acc, nom_bias_int, nom_bias_acc, p_sat, p_const,...
    gps_idx, gal_idx)

global PTHRES PFC PFA_V PFA_H TOL_PL PHMI_V PHMI_H NES_INT

%%%%%%%%%%%% Determine subsets and associated probabilities %%%%%%%%%%%%%%%
[subsets, pap_subset, pap_multiplier, p_not_monitored]= determine_subsets_v4_2(G, p_sat, p_const, gps_idx, gal_idx, PTHRES, PFC);

%%%%%%%%%%%%% Compute subset position solutions, sigmas, and biases %%%%%%%
[sigma, sigma_ss, bias, bias_ss, s1vec, s2vec, s3vec] = compute_subset_solutions(...
             G, sigflt2_int, sigflt2_acc, nom_bias_int, nom_bias_acc, subsets);

%%%%%%%%%%%%% Filter out modes that cannot be monitored and adjust%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% integrity budget %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [sigma, sigma_ss, bias, bias_ss, ~, ~, s3vec,...
     pap_subset, p_not_monitored] = filter_out_subsets(sigma, sigma_ss, bias,...
     bias_ss, s1vec, s2vec, s3vec, pap_subset, p_not_monitored);

%%%%%%%%%%%%%%%%%%%%%%% Compute test thresholds %%%%%%%%%%%%%%%%%%%%%%%%%%%
[T1, T2, T3] = compute_test_thresholds(sigma_ss, bias_ss, PFA_V, PFA_H);

%%%%%%%%%%%%%%%%%%%%% Compute Vertical Protection Level %%%%%%%%%%%%%%%%%%%
%%%In the ProtectionLevel Eq.42 & Eq.43 of the ADDv4.2 the Pfault multiplier
%%%for all-in-view is 2
    p_fault = pap_subset;
    p_fault(1) = 2;
%%%
%%%Following Appendix A of [1] in ADDv4.2 to solve PL via half-search
    phmi_vert = PHMI_V/NES_INT*(1 - 1/(PHMI_V+PHMI_H)*p_not_monitored);
%%%
[vpl, alloc3]     = compute_protection_level_v4_2(sigma(:,3), bias(:,3) + T3,...
    p_fault, phmi_vert, TOL_PL);

%%%%%%%%%%%%%%%%%%%%% Compute Horizontal Protection Level %%%%%%%%%%%%%%%%%
%%%Following Appendix A of [1] in ADDv4.2 to solve PL via half-search
    phmi_hor = PHMI_H/(2*NES_INT)*(1 - 1/(PHMI_V+PHMI_H)*p_not_monitored);
%%%
[hpl1, alloc1] = compute_protection_level_v4_2(sigma(:,1), bias(:,1) + T1,...
    p_fault,  phmi_hor, TOL_PL);
[hpl2, alloc2] = compute_protection_level_v4_2(sigma(:,2), bias(:,2) + T2,...
    p_fault,  phmi_hor, TOL_PL);
hpl = sqrt(hpl1^2 + hpl2^2);

%Exclude modes that are double counted

idx = find(NES_INT.*(alloc3+alloc2+alloc1)>=pap_multiplier);

if ~isempty(idx)

p_not_monitored = p_not_monitored + sum(p_fault(idx));
idx = setdiff(1:length(p_fault),idx);
s1vec = s1vec(idx,:);
s2vec = s2vec(idx,:);
s3vec = s3vec(idx,:);
sigma = sigma(idx,:);
sigma_ss = sigma_ss(idx,:);      
bias = bias(idx,:);
bias_ss = bias_ss(idx,:);
subsets = subsets(idx,:);
pap_subset= pap_subset(idx);
pap_multiplier = pap_multiplier(idx)

%%%%%%%%%%%%%%%%%%%%%%% Compute test thresholds %%%%%%%%%%%%%%%%%%%%%%%%%%%

[T1, T2, T3] = compute_test_thresholds(sigma_ss, bias_ss, PFA_V, PFA_H);

%%%%%%%%%%%%%%%%%%%%% Compute Vertical Protection Level %%%%%%%%%%%%%%%%%%%

p_fault = pap_subset;
p_fault(1) = 2;
phmi_vert = PHMI_V/NES_INT*(1 - 1/(PHMI_V+PHMI_H)*p_not_monitored);
[vpl, ~]     = compute_protection_level_v4_2(sigma(:,3), bias(:,3) + T3,...
    p_fault, phmi_vert, TOL_PL);

%%%%%%%%%%%%%%%%%%%%% Compute Horizontal Protection Level %%%%%%%%%%%%%%%%%
phmi_hor = PHMI_H/(2*NES_INT)*(1 - 1/(PHMI_V+PHMI_H)*p_not_monitored);
[hpl1, ~] = compute_protection_level_v4_2(sigma(:,1), bias(:,1) + T1,...
    p_fault,  phmi_hor, TOL_PL);
[hpl2, ~] = compute_protection_level_v4_2(sigma(:,2), bias(:,2) + T2,...
    p_fault,  phmi_hor, TOL_PL);
hpl = sqrt(hpl1^2 + hpl2^2);

end


%%%%%%%%%%%%%%%%%%% Compute Effective Monitor threshold %%%%%%%%%%%%%%%%%%%
% idx = find(pap_subset>=P_EMT);
%sigma3_acc = sqrt((s3vec.*s3vec)*sigflt2_acc);
% K_md_emt   = - norminv(.5*P_EMT./pap_subset);
%emt = max(T3(idx) + K_md_emt(idx).*sigma3_acc(idx));
%emt = compute_emt(s3vec, sigflt2_acc, T3, pap_subset, P_EMT);

%%%%%%%%%%%%%%%%%%%% Compute sigma accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%sig_acc = sigma3_acc(1);
sig_acc = 0;
emt = 0;

end
