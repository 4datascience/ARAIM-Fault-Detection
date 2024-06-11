% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function init_detection_parameters()
% Initialize Fault Detection ARAIM parameters dependant of aircraft Operation
design_parameters;
operation_parameters;
end

function design_parameters()     
    global PHMI_V PHMI_H PHMI
    global PALERT PFA_V PFA_H PFA
    global PTHRES
    global FC
    global NITER
    global TOL_PL

    % Probability hazardous misleading information [^/hour]        
    PHMI_V = 0;
    PHMI = 1e-7;
    PHMI_H = PHMI - PHMI_V;
    % Probability Alert. Continuity budget allocated to disruptions\
    % due to false alert and failed exclusions [^/hour]
    PALERT = 1e-6;
    %%%% False alert allocation [^/h]
    PFA_V = 0;
    PFA_H = 5e-7;
    PFA = PFA_V + PFA_H;
    % Threshold for the integrity risk allocation to not monitored faults [^/h]
    PTHRES = 8e-8;
    % Fault consolidation weight
    FC = 0.01;
    % Maximum number of iterations to compute Protection Levels
    NITER = 10;
    % Protection Level tolerance stop condition [^m]
    TOL_PL = 5e-2;
end

function operation_parameters()
    global TEXP_INT TTA_INT NES_INT
    global TEXP_CONT TTA_CONT NES_CONT;
    global VAL HAL

    % Integrity
    %TEXP_INT = 3600;
    %TTA_INT = 8;    
    % Number of effective exposures, default Time Exposition for
    % RNP=1h. LPV-200 TEXP=150s TTA=6s
    TEXP_INT = 3600;
    TTA_INT = 8;
    NES_INT = TEXP_INT / TTA_INT;
    % Continuity
    TEXP_CONT = 3600;
    TTA_CONT = 8;
    NES_CONT = TEXP_CONT / TTA_CONT;
    % Alert Limits [^m]
    VAL = 1e10;
    HAL = 555.6;
end
