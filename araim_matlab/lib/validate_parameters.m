% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function validate_parameters() 
%{
    validate_parameters(): The list of validated parameters needs to be improved\
        if new parameters are added to the workspace
%}
validate_computation_default_parameters;
validate_detection_parameters;
        end
    

function validate_computation_default_parameters()
%{
    validate_computation_default_parameters(): Validation of ARAIM computation parameters 
%}
    global ARAIM_URA_GPS ARAIM_URA_GAL ARAIM_URE_GPS ARAIM_URE_GAL ARAIM_RSAT_GPS ARAIM_RSAT_GAL ARAIM_RCONST_GPS ARAIM_RCONST_GAL ARAIM_MFD_SAT_GPS ARAIM_MFD_SAT_GAL ARAIM_MFD_CONST_GPS ARAIM_MFD_CONST_GAL ARAIM_PSAT_GPS ARAIM_PSAT_GAL ARAIM_PCONST_GPS ARAIM_PCONST_GAL

    % ISD
    non_negative(ARAIM_URA_GPS)
    non_negative(ARAIM_URA_GAL)
    non_negative(ARAIM_URE_GPS)
    non_negative(ARAIM_URE_GAL)
    probability(ARAIM_RSAT_GPS)
    probability(ARAIM_RSAT_GAL)
    probability(ARAIM_RCONST_GPS)
    probability(ARAIM_RCONST_GAL)
    non_negative(ARAIM_MFD_SAT_GPS)
    non_negative(ARAIM_MFD_SAT_GAL)
    non_negative(ARAIM_MFD_CONST_GPS)
    non_negative(ARAIM_MFD_CONST_GAL)
    probability(ARAIM_PSAT_GPS)
    probability(ARAIM_PSAT_GAL)
    probability(ARAIM_PCONST_GPS)
    probability(ARAIM_PCONST_GAL)
end


function validate_detection_parameters()
%{
    validate_statistic_parameters(): Validation of ARAIM Fault detection parameters
%}
    global PHMI PHMI_V PHMI_H PALERT PFA_V PFA_H PFA PTHRES PFC NITER TOL_PL TEXP_INT TTA_INT NES_INT TEXP_CONT TTA_CONT NES_CONT

    % Design parameters
    probability(PHMI)
    probability(PHMI_V)
    probability(PHMI_H)
    if PHMI - PHMI_V <= 0
        error("The following condition must meet PHMI - PHMI_V > 0")
    end
    if PHMI_V + PHMI_H ~= PHMI
        error("Set PHMI_V + PHMI_H = PHMI")
    end
    probability(PALERT)
    probability(PFA_V)
    probability(PFA_H)
    probability(PFA)
    if PFA_V + PFA_H ~= PFA
        error("Set PFA_V + PFA_H = PFA")
    end
    if PFA > PALERT
        error("The Prob Alert (PALERT: %.2e) budget is exceded by the Prob False Alert (PFA: %.2e) value", PALERT, PFA)
    end
    probability(PTHRES)
    if PTHRES > PHMI
        error("Prob non-monitored faults cannot exceed PHMI budget")
    end
    probability(PFC)
    non_negative(NITER)
    non_negative(TOL_PL)
    % Operation parameters
    non_negative(TEXP_INT)
    non_negative(TTA_INT)
    non_negative(NES_INT)
    if TEXP_INT / TTA_INT ~= NES_INT
        error("[Integrity] Number of Effective Expositions must be equal to the exposition time divided by the TimeToAlert")
    end
    non_negative(TEXP_CONT)
    non_negative(TTA_CONT)
    non_negative(NES_CONT)
    if TEXP_CONT / TTA_CONT ~= NES_CONT
        error("[Continuity] Number of Effective Expositions must be equal to the exposition time divided by the TimeToAlert")
    end
end


function non_negative(value)
    if value < 0
        error("Parameter cannot hold negative values")
    end
end
    

function probability(value)
    if value < 0 | value > 1
        error("Probabilities must be defined between 0 and 1")
    end
end                       
