% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function satdata = init_satellites(files, t)

    global COL_SAT_PRN COL_SAT_XYZ COL_SAT_XYZDOT COL_SAT_MAX;
    global GPS_SVID_START GAL_SVID_START;
    
    satdata = NaN(1,COL_SAT_MAX);
    svid_0 = 0;
    for k=1:length(files)

        file_exists(files{k})
        
        if contains(files{k},'gps','IgnoreCase',true)            
            sv_data_gps=yumaread(files{k});
            [satPos,satVel,satID] = gnssconstellation(t,sv_data_gps,GNSSFileType="YUMA");
            svid_0 = GPS_SVID_START;
        elseif contains(files{k},'gal','IgnoreCase',true)
            sv_data_gal=galalmanacread(files{k});
            [satPos,satVel,satID] = gnssconstellation(t,sv_data_gal,GNSSFileType="galalmanac");
            svid_0 = GAL_SVID_START;
        end

        nsat=size(satdata,1):size(satdata,1)+size(satID,1)-1;
        satdata(nsat,COL_SAT_PRN) = satID + svid_0;
        satdata(nsat,COL_SAT_XYZ) = satPos;
        satdata(nsat,COL_SAT_XYZDOT) = satVel;
    end
end