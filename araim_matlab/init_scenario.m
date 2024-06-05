% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function init_scenario()
%INIT_SCENARIO Setup the satellite/user environment
global NGRID_POINTS;
global DUAL_FREQUENCY;
global ELEVATION_MASK;
global GPS_SVID_START GAL_SVID_START;

NGRID_POINTS = 2500;

%User signals:
% dual_freq = 0 : L1 only / E1 only
% dual_freq = 1 : L1-L5 / E1b-E5b
% dual_freq = 2 : L5 only /E5a only
DUAL_FREQUENCY = 1;

ELEVATION_MASK = 5;

%Set an arbitrary numeration to identify constellation PRNs
GPS_SVID_START = 0;
GAL_SVID_START = 50;

end

