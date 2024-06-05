% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function file_exists(files)
% Check if file(s) exist
i=1;
while i<=size(files,2)
    if iscell(files)
        fid=fopen(files{i});
    else
        fid=fopen(files);
        i = size(files,2);
    end
    if fid==-1
        if iscell(files)
            error('File not found %s.\n', files{i});
        else
            error('File not found %s.\n', files);
        end
    else
        fclose(fid);
    end 
    i=i+1;
end