% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************
function usrdata = init_user()

    global NUSER COL_USR_UID COL_USR_XYZ COL_USR_LLH COL_USR_MAX;
    global NGRID_POINTS;

    grid = GridSphere(NGRID_POINTS);
    NUSER = size(grid,1);

    usrid = [1:NUSER]';
    usrllh = zeros(NUSER,3);
    usrllh(:,1:2) = grid;
    usrxyz = lla2ecef(usrllh);

    usrdata = NaN(NUSER,COL_USR_MAX);
    usrdata(:,COL_USR_UID) = usrid;
    usrdata(:,COL_USR_XYZ) = usrxyz;
    usrdata(:,COL_USR_LLH) = usrllh;

    % plot user locations
    if 0
        load topo;
        figure;
        contour([1:360], [-89:90], topo, [0 0],'k');
        hold on;
        plot(180+usrllh(:,2),usrllh(:,1),'rx');    
    end
end