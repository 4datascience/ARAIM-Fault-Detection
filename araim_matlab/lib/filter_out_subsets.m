% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function [sigma, sigma_ss, bias, bias_ss, s1vec, s2vec, s3vec,...
     pap_subsets, p_not_monitored] = filter_out_subsets(sigma, sigma_ss, bias,...
     bias_ss, s1vec, s2vec, s3vec, pap_subsets, p_not_monitored)

 idx = find(min(sigma(:,1:3),[],2)<Inf);
 sigma = sigma(idx,:);
 sigma_ss = sigma_ss(idx,:);      
 bias = bias(idx,:);
 bias_ss = bias_ss(idx,:);
 s1vec = s1vec(idx,:);
 s2vec = s2vec(idx,:);
 s3vec = s3vec(idx,:);
 p_not_monitored = p_not_monitored +sum(pap_subsets)-sum(pap_subsets(idx,:));
 pap_subsets =pap_subsets(idx,:);

end