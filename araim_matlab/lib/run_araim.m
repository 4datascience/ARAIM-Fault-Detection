function vhpl = run_araim(analysis_interval, user_data, satellite_almanac)
%RUN_ARAIM Executes the ARAIM algorthim as per ADDv4.2
%   For each epoch in analysis_interval, the vertical and horizontal
%   protection levels, the effective monitoring threshold and the sigmas of
%   accuracy are obtained.
%   Returns: [vpl, hpl, sig_acc, emt]
global COL_USR_LL;
global COL_U2S_EL COL_U2S_AZ COL_U2S_VISIBLE COL_U2S_PRN COL_U2S_IPPLL ...
    COL_U2S_SIGNOM COL_U2S_SIGACC COL_U2S_GENU COL_U2S_UID;
global DUAL_FREQUENCY;
global GAMMA_L1_L5;
global CONST_GAMMA_L1L5;
global GPS_SVID_START GAL_SVID_START;
global ARAIM_URA_GPS;
global ARAIM_URA_GAL;
global ARAIM_BNOM_GPS;
global ARAIM_BNOM_GAL;
global ARAIM_URE_GPS;
global ARAIM_URE_GAL;
global ARAIM_BNOM_CONT_GPS;
global ARAIM_BNOM_CONT_GAL;
global ARAIM_PSAT_GPS;
global ARAIM_PSAT_GAL;

    %initialize output
    vhpl = NaN(size(user_data,1),4,length(analysis_interval));
    
    iter = 0;
    for epoch = analysis_interval
        iter = iter + 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Line-of-sight vectors
        sv_data = init_satellites(satellite_almanac,epoch);
        usr2satdata = init_usr2satdata(user_data,sv_data);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Indices of visible satellites
        visib_mask = find(usr2satdata(:,COL_U2S_VISIBLE) == 1);
        usr2sat_abvmask = usr2satdata(visib_mask,:);
        indgps = find(usr2sat_abvmask(:,COL_U2S_PRN) > GPS_SVID_START ...
            & usr2sat_abvmask(:,COL_U2S_PRN) <= GAL_SVID_START);
        indgal = find(usr2sat_abvmask(:,COL_U2S_PRN) > GAL_SVID_START);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Nominal error model ADD V4.2
        ura     = NaN(length(visib_mask),1);
        sig2_if = ones(length(visib_mask),1)*Inf;
        bnom_i  = NaN(length(visib_mask),1);
        psat_i  = NaN(length(visib_mask),1);
        
        psat_i(indgps) = ARAIM_PSAT_GPS;
        psat_i(indgal) = ARAIM_PSAT_GAL;
        
        ura(indgps) = ARAIM_URA_GPS;
        ura(indgal) = ARAIM_URA_GAL;
        
        bnom_i(indgps) = ARAIM_BNOM_GPS;
        bnom_i(indgal) = ARAIM_BNOM_GAL;

        %Troposphere
        sig2_trop=trop_mops(usr2sat_abvmask(:,COL_U2S_EL));

        %Ionosphere
        %Find Ionospheric Pierce Point
        usr2satdata(visib_mask,COL_U2S_IPPLL) = find_ll_ipp(user_data(:,COL_USR_LL),...
                                usr2satdata(:,COL_U2S_EL),...
                                usr2satdata(:,COL_U2S_AZ), visib_mask);
%**
  if DUAL_FREQUENCY == 1
     sig2_if(indgps) = GAMMA_L1_L5*iono_mops(NaN,usr2sat_abvmask(indgps,COL_U2S_EL));
     sig2_if(indgal) = iono_gal(usr2sat_abvmask(indgal,COL_U2S_EL));
  else
     mag_lat = usr2sat_abvmask(:,COL_U2S_IPPLL(1)) + ...
        0.064*180*cosd(usr2sat_abvmask(:,COL_U2S_IPPLL(2))-291.06);

     %mid-latitude klobuchar confidence
     sig2_uire = 20.25*obliquity2(usr2sat_abvmask(:,COL_U2S_EL));
     %low-latitude klobuchar confidence
     idx = find(abs(mag_lat) < 20);
     if(~isempty(idx))
         sig2_uire(idx) = 81*obliquity2(usr2sat_abvmask(idx,COL_U2S_EL));
     end
     %high-latitude klobuchar confidence
     idx = find(abs(mag_lat) > 55);
     if(~isempty(idx))
         sig2_uire(idx) = 36*obliquity2(usr2sat_abvmask(idx,COL_U2S_EL));
     end

     if DUAL_FREQUENCY == 0  
         sig2_if(indgps) = sig2_uire(indgps) + iono_mops(NaN,usr2sat_abvmask(indgps,COL_U2S_EL));
         sig2_if(indgal) = sig2_uire(indgal) + iono_gal(usr2sat_abvmask(indgal,COL_U2S_EL))/GAMMA_L1_L5;  
     elseif DUAL_FREQUENCY == 2
         sig2_if(indgps) = CONST_GAMMA_L1L5^2*sig2_uire(indgps) + iono_mops(NaN,usr2sat_abvmask(indgps,COL_U2S_EL));
         sig2_if(indgal) = CONST_GAMMA_L1L5^2*sig2_uire(indgal) + iono_gal(usr2sat_abvmask(indgal,COL_U2S_EL))/GAMMA_L1_L5;
     end
  end
%**
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %INTEGRITY
        sig2int = ura.^2+ sig2_trop + sig2_if;
        usr2satdata(visib_mask,COL_U2S_SIGNOM) = sqrt(sig2int);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CONTINUITY & ACCURACY
        ure =     NaN(length(visib_mask),1);
        bcont_i = NaN(length(visib_mask),1);
        
        ure(indgps) = ARAIM_URE_GPS;
        ure(indgal) = ARAIM_URE_GAL;
        
        bcont_i(indgps) = ARAIM_BNOM_CONT_GPS;
        bcont_i(indgal) = ARAIM_BNOM_CONT_GAL;
            
        sig2acc = ure.^2+ sig2_trop + sig2_if;        
        usr2satdata(visib_mask,COL_U2S_SIGACC) = sqrt(sig2acc);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        vhpl(1:max(usr2satdata(visib_mask,COL_U2S_UID)),:,iter) = ...
            user_vhpl_araim( usr2satdata(visib_mask,COL_U2S_GENU), ...
                             usr2satdata(visib_mask,COL_U2S_UID), ...
                             usr2satdata(visib_mask,COL_U2S_PRN), ...
                             sig2int, ...
                             sig2acc, bnom_i, bcont_i, psat_i);

    end %End of analysis_interval loop
end

