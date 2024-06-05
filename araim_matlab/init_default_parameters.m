% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function init_default_parameters()
% Initialize default ARAIM parameters as per ADDv4.2
% Integrity
global ARAIM_URA_GPS;
global ARAIM_URA_GAL;
global ARAIM_BNOM_GPS;
global ARAIM_BNOM_GAL;
% Accuracy and Continuity
global ARAIM_URE_GPS;
global ARAIM_URE_GAL;
global ARAIM_BNOM_CONT_GPS;
global ARAIM_BNOM_CONT_GAL;
% Failure probabilities
global ARAIM_RSAT_GPS;
global ARAIM_RSAT_GAL;
global ARAIM_RCONST_GPS;
global ARAIM_RCONST_GAL;
global ARAIM_MFD_SAT_GPS;
global ARAIM_MFD_SAT_GAL;
global ARAIM_MFD_CONST_GPS;
global ARAIM_MFD_CONST_GAL;
global ARAIM_PSAT_GPS;
global ARAIM_PSAT_GAL;
global ARAIM_PCONST_GPS;
global ARAIM_PCONST_GAL;

% Integrity
ARAIM_URA_GPS = 2;
ARAIM_URA_GAL = 6;
ARAIM_BNOM_GPS = 0;
ARAIM_BNOM_GAL = 0;
% Accuracy and Continuity
ARAIM_URE_GPS = 1;
ARAIM_URE_GAL = 4;
ARAIM_BNOM_CONT_GPS = 0;
ARAIM_BNOM_CONT_GAL = 0;
% Failure probabilities (MFD measured in seconds)
ARAIM_PSAT_GPS = 1e-7;
ARAIM_PSAT_GAL = 3e-7;
ARAIM_PCONST_GPS = 1e-8;
ARAIM_PCONST_GAL = 2e-6;
ARAIM_MFD_SAT_GPS = 3600;
ARAIM_MFD_SAT_GAL = 5400;
ARAIM_MFD_CONST_GPS = 3600;
ARAIM_MFD_CONST_GAL = 7200;
ARAIM_RSAT_GPS = ARAIM_PSAT_GPS/ARAIM_MFD_SAT_GPS;
ARAIM_RSAT_GAL = ARAIM_PSAT_GAL/ARAIM_MFD_SAT_GAL;
ARAIM_RCONST_GPS = ARAIM_PCONST_GPS/ARAIM_MFD_CONST_GPS;
ARAIM_RCONST_GAL = ARAIM_PCONST_GAL/ARAIM_MFD_CONST_GAL;

% Initialize default GNSS Signal in Space parameters
global GAMMA_L1_L5;
CONST_F1           = 1575.42e6;             % L1 frequency, Hz
CONST_F2           = 1227.60e6;             % L2 frequency, Hz
CONST_F5           = 1176.45e6;             % L5 frequency, Hz
%Multiplying factor due to dual frequency combination
GAMMA_L1_L5 = (CONST_F1^4 + CONST_F5^4)/ (CONST_F1^2 - CONST_F5^2)^2;

%Initialize physical constants
global CONST_R_E;
global CONST_R_IONO;
global CONST_GAMMA;
global CONST_GAMMA_L1L5;
CONST_R_E          = 6378137;               % Earth's semimajor axis, m
CONST_H_IONO       = 350000;                % altitude of the ionosphere, m
CONST_R_IONO       = CONST_R_E + CONST_H_IONO;  % Iono's approximate radius, m
CONST_GAMMA        = (CONST_F1/CONST_F2)^2; % ionospheric constant for L1/L2
CONST_GAMMA_L1L5   = (CONST_F1/CONST_F5)^2; % ionospheric constant for L1-L5

end