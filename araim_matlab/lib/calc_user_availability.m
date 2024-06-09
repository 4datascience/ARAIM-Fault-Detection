function usr_data = calc_user_availability(usrdata, hpl, vpl)
%CALC_USER_AVAILABILITY Summary of this function goes here
%   hpl: matrix size(Nusers, Niterations)
%   vpl: matrix size(Nusers, Niterations)
global COL_USR_AVAIL
global VAL HAL

usrdata(:, COL_USR_AVAIL) = mean(hpl < HAL & vpl < VAL, 2) *100;

usr_data = usrdata;

end

