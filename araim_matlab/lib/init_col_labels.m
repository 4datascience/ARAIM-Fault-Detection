% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************
function init_col_labels()

global COL_SAT_PRN COL_SAT_XYZ COL_SAT_XYZDOT COL_SAT_MAX
global COL_USR_UID COL_USR_XYZ COL_USR_LL COL_USR_LLH COL_USR_MAX
global COL_U2S_UID COL_U2S_PRN COL_U2S_VISIBLE COL_U2S_GXYZ ...
    COL_U2S_GENU COL_U2S_EL COL_U2S_AZ COL_U2S_SIG2TRP ...
    COL_U2S_SIG2L1MP COL_U2S_SIG2L2MP COL_U2S_IPPLL COL_U2S_IPPXYZ ...
    COL_U2S_TTRACK0 COL_U2S_IVPP COL_U2S_MAX COL_U2S_INITNAN...
    COL_U2S_SIGACC COL_U2S_SIGNOM

% column numbers of specific data in SATDATA, URSDATA;
%   USR2SATDATA matrices
% SAT - satellite / sv
% USR - user

% SATDATA
COL_SAT_PRN    = 1;
COL_SAT_XYZ    = 2:4;
COL_SAT_XYZDOT = 5:7;
COL_SAT_MAX    = 7;

% USRDATA
COL_USR_UID = 1;
COL_USR_XYZ = 5:7;
COL_USR_LL = 2:3;
COL_USR_LLH = 2:4;
COL_USR_MAX = 4;

% USR2SATDATA
COL_U2S_UID = 1;
COL_U2S_PRN = 2;
COL_U2S_VISIBLE = 3;
COL_U2S_GXYZ = 4:6;
COL_U2S_GENU = 7:9;
COL_U2S_EL = 10;
COL_U2S_AZ = 11;
COL_U2S_SIG2TRP = 12;
COL_U2S_SIG2L1MP = 13;
COL_U2S_SIG2L2MP = 14;
COL_U2S_IPPLL = 15:16;
COL_U2S_IPPXYZ = 17:19;
COL_U2S_TTRACK0 = 20;
COL_U2S_IVPP = 21;
COL_U2S_SIGACC = 22;
COL_U2S_SIGNOM = 23;
COL_U2S_MAX = 23;
COL_U2S_INITNAN = 3:23;
