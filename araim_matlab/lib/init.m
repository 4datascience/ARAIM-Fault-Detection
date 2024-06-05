% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function init()
    init_default_parameters;
    init_detection_parameters;
    validate_parameters;
    init_col_labels;
    init_scenario;
    init_cnmp_mops;
end