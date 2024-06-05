% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ******************************************************************************************

function usr2satdata = init_usr2satdata(usrdata,satdata)

global COL_USR_UID COL_USR_LL ELEVATION_MASK;
global COL_SAT_PRN COL_SAT_XYZ;
global COL_U2S_UID COL_U2S_PRN COL_U2S_VISIBLE COL_U2S_MAX ...
    COL_U2S_INITNAN COL_U2S_GENU COL_USR_LLH COL_U2S_AZ COL_U2S_EL ...
    COL_U2S_GXYZ;

nusr = size(usrdata,1);
nsat = size(satdata,1);
nlos = nsat*nusr;
usr2satdata = NaN(nlos,COL_U2S_MAX);
[t1, t2]=meshgrid(usrdata(:,COL_USR_UID),satdata(:,COL_SAT_PRN));
usr2satdata(:,COL_U2S_UID) = reshape(t1,nlos,1);    % user_id
usr2satdata(:,COL_U2S_PRN) = reshape(t2,nlos,1);    % svid
usr2satdata(:,COL_U2S_INITNAN) = NaN;

%Find geometry vectors
%Iterate per user position
for n=1:nusr
    LOS_ENU = NaN(nsat, 3);
    LOS_XYZ = NaN(nsat, 3);
    LAT_LON = usrdata(:,COL_USR_LL);
    i_start=(n-1)*nsat + 1;
    i_end=n*nsat;

    %Azimuth, Elevation and Visibility
    [usr2satdata(i_start:i_end,COL_U2S_AZ), ...
        usr2satdata(i_start:i_end,COL_U2S_EL), ...
        usr2satdata(i_start:i_end,COL_U2S_VISIBLE)] = ...
        lookangles(usrdata(n,COL_USR_LLH),satdata(:,COL_SAT_XYZ),ELEVATION_MASK);

    t1=double(usr2satdata(i_start:i_end,COL_U2S_VISIBLE));
    t1(t1==0)=NaN;
    %ENU Geometry matrix
    LOS_ENU(:,1)=sind(usr2satdata(i_start:i_end,COL_U2S_AZ)).*t1;
    LOS_ENU(:,2)=cosd(usr2satdata(i_start:i_end,COL_U2S_AZ)).*t1;
    LOS_ENU(:,3)=sind(usr2satdata(i_start:i_end,COL_U2S_EL)).*t1;
    %normalize first three columns
    mag=sqrt(sum(LOS_ENU(:,1:3)'.^2))';
    LOS_ENU(:,1)=LOS_ENU(:,1)./mag;
    LOS_ENU(:,2)=LOS_ENU(:,2)./mag;
    LOS_ENU(:,3)=LOS_ENU(:,3)./mag;
    usr2satdata(i_start:i_end,COL_U2S_GENU)=LOS_ENU;

    %ECEF Geometry matrix
    [LOS_XYZ(:,1),LOS_XYZ(:,2),LOS_XYZ(:,3)] = enu2ecefv(LOS_ENU(:,1),...
        LOS_ENU(:,2), LOS_ENU(:,3), ...
        repmat(LAT_LON(n,1),nsat,1), repmat(LAT_LON(n,2),nsat,1));
    %normalize first three columns    
    mag=sqrt(sum(LOS_XYZ(:,1:3)'.^2))';
    LOS_XYZ(:,1)=LOS_XYZ(:,1)./mag;
    LOS_XYZ(:,2)=LOS_XYZ(:,2)./mag;
    LOS_XYZ(:,3)=LOS_XYZ(:,3)./mag;
    usr2satdata(i_start:i_end,COL_U2S_GXYZ)=LOS_XYZ;

end

end

