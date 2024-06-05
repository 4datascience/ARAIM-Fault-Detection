% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function S = compute_s_coefficients(G, W, GtW, invcov0, indb)

    GtWindb = G(indb,:)'*W(indb,:);
    GtWindG = invcov0  - GtWindb*G;
    S       = Inf*ones(size(G,2),size(G,1));
        
    not_zero = find(sum(abs(GtWindG))>0);
    n_unk = length(not_zero);
    
    if (size(G,1)-length(indb))>= max(n_unk,4)
       Sred = GtWindG(not_zero,not_zero)\( GtW(not_zero,:) - GtWindb(not_zero,:) );
       S(not_zero,:) = Sred;    
    end 