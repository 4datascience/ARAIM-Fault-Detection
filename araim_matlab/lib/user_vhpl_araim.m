% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function vhpl = user_vhpl_araim(los_enu, usr_idx, prn, sig2int, sig2acc, bnom_i, bcont_i, psat_i)
%USER_VHPL_ARAIM This function iterates per user location, calculating the
%geometry matrix and subsetting the list of statistics characterizing each
%satellite's error.

global GPS_SVID_START GAL_SVID_START
global ARAIM_PCONST_GPS ARAIM_PCONST_GAL


n_usr=max(usr_idx);
vhpl=NaN(n_usr,4);

for usr=1:n_usr
  svidxgps = find((usr_idx==usr)&(prn > GPS_SVID_START & prn <= GAL_SVID_START)&(sig2int<Inf)&(psat_i<1));
  svidxgal = find((usr_idx==usr)&(prn > GAL_SVID_START)&(sig2int<Inf)&(psat_i<1));
  
  ngps = length(svidxgps);
  ngal = length(svidxgal);
  
  svconst = [(~isempty(svidxgps)) (~isempty(svidxgal))];
  svidx  = [svidxgps; svidxgal];
           
  n_view=length(svidx);
  if(n_view>3)  
     
    clk_gps = [ones(ngps,svconst(1)); zeros(ngal,svconst(1))];
    clk_gal = [zeros(ngps,svconst(2)); ones(ngal,svconst(2))];
      
    G = [ los_enu(svidx,1:3) clk_gps  clk_gal];
    
    p_const = [ones(svconst(1),1)*ARAIM_PCONST_GPS; ones(svconst(2),1)*ARAIM_PCONST_GAL];
    
    sigflt2_int   = sig2int(svidx);
    sigflt2_acc   = sig2acc(svidx);
    nom_bias_int = bnom_i(svidx);
    nom_bias_acc = bcont_i(svidx);
    p_sat        = psat_i(svidx);
  
    [vpl, hpl, sig_acc, emt] = araim_baseline_v4_2 ...
        (G, sigflt2_int, sigflt2_acc, nom_bias_int, nom_bias_acc, p_sat, p_const, 1:ngps, ngps+1:ngps+ngal);
  
    vhpl(usr,1)= vpl;
    vhpl(usr,2)= hpl;
    vhpl(usr,3)= sig_acc;
    vhpl(usr,4)= emt;
   
  else                      
    vhpl(usr,1)=Inf;
    vhpl(usr,2)=Inf;                 
    vhpl(usr,3)=Inf;
    vhpl(usr,4)=Inf;
  end
end

end

