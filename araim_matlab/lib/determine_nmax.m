% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function nmax =determine_nmax(p,p_thres, gps_idx, gal_idx)
%DETERMINE_NMAX determines the maximum size of the subsets to be monitored.

n = length(p);
p_not_monitored = 1;
r = 0;

while ((p_not_monitored>p_thres)&(r<(n+1)))
    r = r+1;
    p_not_monitored = compute_p_not_monitored(p,r,gps_idx,gal_idx);
end

nmax = r-1;
