% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function p_not_monitored = compute_p_not_monitored(p_event,r,gps_idx,gal_idx)
%COMPUTE_P_NOT_MONITORED returns an upper bound of the probability of r or more
% of the events with probability p

global TEXP_INT 
global ARAIM_MFD_SAT_GPS ARAIM_MFD_SAT_GAL
global ARAIM_MFD_CONST_GPS ARAIM_MFD_CONST_GAL
global PHMI

svconst = [(~isempty(gps_idx)) (~isempty(gal_idx))];
%multipliers to convert instant event probabilities to probabilities along 
%Time of Exposition
texp_multiplier = (1+TEXP_INT./ [...
    ones(length(gps_idx),1)*ARAIM_MFD_SAT_GPS; ...
    ones(length(gal_idx),1)*ARAIM_MFD_SAT_GAL; ...
    ones(svconst(1),1)*ARAIM_MFD_CONST_GPS; ...
    ones(svconst(2),1)*ARAIM_MFD_CONST_GAL]);

%p_event is a vector containing the probability of n independent events
%Compute probability of single events during Time of Exposition (Texp_int)
p_event_texp = p_event.*texp_multiplier;

%Find events with probability one
idcrtn = find(p_event_texp>=1);
ncrtn = length(idcrtn);

idcmp =setdiff(1:length(p_event_texp),idcrtn);

p_event = p_event(idcmp);
p_event_texp = p_event_texp(idcmp);

r = r-ncrtn;

%Compute probability of no fault over Time of Exposition (Texp_int)
p_no_fault = prod(1-p_event);
p_no_fault_texp = prod(1-p_event_texp);

if r<=0
    p_not_monitored = 1;
end

if r==1
    %If any single satellite fault or constellation fault exceeds PHMI
    if find(p_event_texp > PHMI)
        p_not_monitored = 1;
    else
        p_not_monitored = 1-p_no_fault;
    end
end

if r==2
    p_not_monitored = 1-p_no_fault_texp-p_no_fault*sum(p_event./(1-p_event)...
        .*texp_multiplier);
end

if r==3
    p_not_monitored = 1-p_no_fault_texp-p_no_fault*sum(p_event./(1-p_event).*texp_multiplier)...
     - .5*p_no_fault*(sum(p_event./(1-p_event).*texp_multiplier)^2 - ...
     sum((p_event./(1-p_event).*texp_multiplier).^2));
end

if r>=4 
    p_not_monitored = ((sum(p_event.*texp_multiplier))^r)/prod(1:r);
end
    