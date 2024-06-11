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

LogPrint('Initializing configured variables...');
init;

% Analysis time (units in seconds)
t_start = datetime(2019,08,06,00,00,00);
t_end = datetime(2019,08,07,00,00,00);
TStep = 300;
analysis_interval = t_start:seconds(TStep):t_end;

% Satellite section
% GPS & GAL
LogPrint('Reading satellite almanacs from /data folder.');
% gps_file = download_gps_yuma(t);
gps_file = 'data/gps_almanac_2019-8-6.alm';
satellite_almanac = {'data/gal_almanac.xml', gps_file};

% User section
LogPrint('Creating world grid of users.');
user_data = init_user;

% Run ARAIM
LogPrint('Running ARAIM algorithm...');
vhpl = run_araim(analysis_interval, user_data, satellite_almanac);

% Plot results
global COL_USR_LL COL_USR_AVAIL
World = readWorld(fullfile("plotting", "world_110m.txt"));
if 0
    LogPrint('Plotting user grid...');
    Plots_Worlds(World, user_data(:,COL_USR_LLH), ".");
end
if 1
    LogPrint('Plotting Protection Levels availability...');
    user_data = calc_user_availability(user_data, squeeze(vhpl(:,2,:)), ...
        squeeze(vhpl(:,1,:)));
    Plot_Availability(World, [user_data(:,COL_USR_LL) ...
        user_data(:,COL_USR_AVAIL)], ".");
end