% ARAIM Detection Algorithm

% This script allows the user to run an ARAIM algorithm implementation
% based on the ADDv4.2.
% Fault Detection enabled.
% :TODO: Fault Detection and Exclusion.

% This tool accepts files stored in the 
% data folder.

% The script supports no CLI and is launched without arguments. 
% Variables are defined in ./lib folder.

% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************
clear;

addpath(genpath('lib'),'-end')
addpath(genpath('src'),'-end')

init;

% Analysis time (units in seconds)
t_start = datetime(2019,08,06,00,00,00);
t_end = datetime(2019,08,06,00,10,00);
TStep = 300;
analysis_interval = t_start:seconds(TStep):t_end;

% Satellite section
% GPS & GAL
% gps_file = download_gps_yuma(t);
gps_file = 'data/gps_almanac_2019-8-6.alm';
satellite_almanac = {'data/gal_almanac.xml', gps_file};

% User section
user_data = init_user;

% Run ARAIM
vhpl = run_araim(analysis_interval, user_data, satellite_almanac);