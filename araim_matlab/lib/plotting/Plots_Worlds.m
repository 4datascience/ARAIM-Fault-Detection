% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************

function Plots_Worlds(World, Points, output_folder)

global CONST_R_E
Rt = CONST_R_E / 1e3;

LogPrint('Plotting grid...');

%% Plot grid 2D
LogPrint('2D plot...');
fig = figure('pos', [300 200 1000 500],'Visible','Off'); hold on;
plot(World(:,1), World(:,2),'k');
for k=1:length(size(Points, 1))
    plot(Points(:,2), Points(:,1), 'b*', 'markersize', 1);
end

axis([-180 180 -90 90]);
title(['User grid of ',num2str(size(Points, 1)), ' points']);
set(fig, 'PaperPositionMode', 'auto')

filename = fullfile(output_folder, "2D_Grid.png");
print(fig, '-dpng',filename);
close(fig);
LogPrint('... -> '+filename);

%% Plot grid 3D
LogPrint('3D plot...');

% World
Lon_World = World(:,1) .*pi./180;
Lat_World = World(:,2) .*pi./180;
x_World = Rt .* cos(Lat_World) .* cos(Lon_World);
y_World = Rt .* cos(Lat_World) .* sin(Lon_World);
z_World = Rt .* sin(Lat_World);

% Points
Lon_Points = Points(:,2).*pi./180;
Lat_Points = Points(:,1).*pi./180;
x_Points = Rt .* cos(Lat_Points) .* cos(Lon_Points);
y_Points = Rt .* cos(Lat_Points) .* sin(Lon_Points);
z_Points = Rt .* sin(Lat_Points);

% Sphere
[x_sphere,y_sphere,z_sphere] = sphere(30);

% Plot
fig = figure('pos', [300 200 1000 500], 'Visible', 'Off'); hold on;

surf(x_sphere.*Rt,y_sphere.*Rt,z_sphere.*Rt,'FaceColor','w',...
    'EdgeColor',[0.7,0.7,0.7]);
plot3(x_World, y_World, z_World, 'k');

for k=1:size(Points, 1)
    plot3(x_Points(k), y_Points(k), z_Points(k), 'b*', 'markersize', 1);
end

title(['User grid of ',num2str(size(Points, 1)), ' points']);
axis off;
view(50,20);
zoom(1.2);
set(fig, 'PaperPositionMode', 'auto')

filename = fullfile(output_folder, "3D_Grid.png");
print(fig, '-dpng',filename);
close(fig);
LogPrint('... -> '+filename);


end

























