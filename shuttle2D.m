function [x, y, t, u] = shuttle2D(tmax, nt, xmax, nx, ymax, solver, doplot)
% Function for modelling temperature in a space shuttle tile in 2 dimensions
% Based on code written by D N Johnston  22/1/18
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps in the x direction (this will determine
% the step size in both directions, which is the same)
% ymax   - tile length
% solver - handle to solver step function (@fdstep or @dffstep)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector in x
% y      - distance vector in y
% t      - time vector
% u      - temperature matrix
%
% Examples:
% shuttle2D(4000, 501, 0.05, 201, 0.05, @dffstep, true) demonstrates
% wave-like behaviour of DuFort-Frankel

% Set tile properties
thermcon = 0.141; % W/(m K)
density  = 351;   % 22 lb/ft^3
specheat = 1258;  % ~0.3 Btu/lb/F at 500F

% Some crude data to get you started:
%timedata = [0  60 500 1000 1500 1750 4000]; % s
%tempdata = [16 16 820 760  440  16   16];   % degrees C

% Load the NASA data
load tile597.mat xdata ydata
% Convert to celsius
ydata = fahrenheitToCelcius(ydata);

% Fill the rest of the time with 16 degrees, if there is any gap
if tmax > xdata(end)
    dxdata = xdata(2) - xdata(1); % Finds the time interval of the NASA data
    xdata = [xdata, (xdata(end) + dxdata):dxdata:tmax]; % Fills in the rest of the time values
    ydata(end+1:length(xdata)) = 16; % Fills the temperature values with 16
end

% Initialise everything
dt = tmax / (nt-1);
t = (0:nt-1) * dt;
dx = xmax / (nx-1);
x = (0:nx-1) * dx;
ny = floor(ymax/dx);
y = (0:ny-1) * dx;
u = zeros(nt, nx, ny);

% Calculate parameters
alpha = thermcon/(density*specheat);
p = (alpha*dt)/(dx^2);

% * Replaced with animatedPlot function *
% Set up dynamic 2D plot
% if doplot
%     h = plot(x, zeros(1, nx), 'r');
%     ylim([0, 1000]);
%     xlabel('x (m)');
%     ylabel('Temperature (deg C)');
%     grid;
% end

% Set initial conditions to 16C throughout.
% Do this for first two timesteps.
u([1 2], :, :) = 16;

% Main timestepping loop.
for n = 2:nt - 1
    
    % South (max x) boundary condition: outer surface
    u(n+1, nx, :) = interp1(xdata, ydata, t(n+1), 'linear', 'extrap');
    
    % East (min y) boundary condition: front surface (touching adjacent tile)
    u(n+1, :, 1) = interp1(xdata, ydata, t(n+1), 'linear', 'extrap');
    % West (max y) boundary condition: back surface (touching adjacent tile)
    u(n+1, :, ny) = interp1(xdata, ydata, t(n+1), 'linear', 'extrap');
    
    % Other boundaries dealt with inside the step function
    
    % Computes the next step
    u(n+1, :, :) = solver(u, p, n);
end

if doplot
    % Animated plot GUI
    animatedPlot(@(x, y, u) surfNoEdges(x, y, u, [0, 800], 'hot'), 10, t, u, x, y);
end