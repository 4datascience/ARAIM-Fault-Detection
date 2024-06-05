% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function [T1, T2, T3] = compute_test_thresholds(sigma_ss, bias_ss, pfa_vert, pfa_hor)
%This function computes the test thresholds
%See Eq.36 ADD_V4.2

global NES_CONT

nsets = size(sigma_ss,1);

if nsets>1

    Kfa_1 = - norminv(.25*pfa_hor/((nsets-1)*NES_CONT));
    Kfa_2 = - norminv(.25*pfa_hor/((nsets-1)*NES_CONT));
    Kfa_3 = - norminv(.5*pfa_vert/((nsets-1)*NES_CONT));
    
    T1 = Kfa_1 * sigma_ss(:,1) + bias_ss(:,1);
    T2 = Kfa_2 * sigma_ss(:,2) + bias_ss(:,2);
    T3 = Kfa_3 * sigma_ss(:,3) + bias_ss(:,3);
else
    T1 = 0;
    T2 = 0;
    T3 = 0;
end
    
%add delta to prevent numerical indeterminations. This delta does not
%impact integrity

T1 = T1 + eps;
T2 = T2 + eps;
T3 = T3 + eps;

end