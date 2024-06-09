% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function Map = readWorld(Name)

fid = fopen(Name, 'r');

Map = [];


while true
    
    line = fgetl(fid);
    
    if line == -1
        break;
    end
    
    if ~isempty(line)
        Fields = strsplit(line);
        Map(end+1, :) =  [str2double(Fields{1}), str2double(Fields{2})]; %#ok.
        
    else
        Map(end+1, :) =  [NaN, NaN]; %#ok.
        
    end
    
    
    
end

fclose(fid);

end