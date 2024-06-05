function gps_file = download_gps_yuma(t)
    baseURL = "https://www.navcen.uscg.gov/sites/default/files/gps/almanac/";
    almanacType = "/yuma/";
    almanacExtension = ".alm";
    url = baseURL + t.Year + almanacType + num2str(day(t,"dayofyear"),'%03d') + almanacExtension;
    gps_file = "data/gps_almanac" + "_" + t.Year + "-" + t.Month + "-" + t.Day + ".alm";
    websave(gps_file,url);
end

