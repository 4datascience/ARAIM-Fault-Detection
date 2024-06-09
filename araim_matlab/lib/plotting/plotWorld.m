% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

% Example script to plot users grid

World = readWorld("./world_110m.txt");

[latlong] = GridSphere(2000);
Plots_Worlds(World, latlong);