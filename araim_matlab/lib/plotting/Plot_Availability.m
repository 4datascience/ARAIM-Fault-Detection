% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function Plot_Availability(World, Points, output_folder)
%Plot_Availability
%   Points: 3 column user availability matrix with [lat, lon, availability]
% If there are no Points

Points180 = Points(Points(:,2) == 180, :);
Points180(:,2) = -Points180(:,2);
Points = [Points; Points180];

if ~isempty(Points)
    y = linspace(min(Points(:,1)),max(Points(:,1)),150);
    x = linspace(min(Points(:,2)),max(Points(:,2)),150);
else
    x = []; y = [];
end
[X,Y] = meshgrid(x,y);
Z = scatteredInterpolant(Points(:,2),Points(:,1),Points(:,3));

fig = figure('pos', [300 200 1000 500], 'visible','Off',...
    'PaperUnits', 'normalized');
hold on;
contourf(X,Y,Z(X,Y),100,'LineColor','None');

%colorMap = interp1([0;1],[1 0 0; 0 1 0],linspace(0,1,256));
colormap summer;
c = colorbar;
c.Label.String = 'Availability [%]';

if min(Points(:,3)) < 80
    clim([min(Points(:,3)) 100]);
else
    clim([80 100]);
end


% If there is no Points, remove the axis
if isempty(Points)
    axis off;
end

plot(World(:,1), World(:,2),'k');


title("Horizontal and Vertical PLs availability", 'Fontsize',8);

set(fig, 'PaperPositionMode', 'auto')
filename = fullfile(output_folder, "Availability_Grid.png");
print(fig, '-dpng', filename);

% Close the figure
close(fig);
LogPrint('... -> '+filename);

end

