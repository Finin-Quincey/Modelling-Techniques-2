function [x, t, u] = shuttle(tmax, nt, xmax, nx, solver, doplot)
% Function for modelling temperature in a space shuttle tile
% D N Johnston  22/1/18
% Modified by candidate no. 10083
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% solver - handle to solver step function (@fdstep, @cnstep, etc.)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle(4000, 501, 0.05, 21, @fdstep, true);

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
u = zeros(nt, nx);

% Calculate parameters
alpha = thermcon/(density*specheat);
p = (alpha*dt)/(dx^2);

% Set initial conditions to 16C throughout for first two timesteps
u([1 2], :) = 16;

% Main timestepping loop
for n = 2:nt - 1
    
    % RHS boundary condition: outer surface
    u(n+1, nx) = interp1(xdata, ydata, t(n+1), 'linear', 'extrap');
    
    % LHS Neumann boundary dealt with inside step functions since it is
    % different for each method (I did try a very complex system involving
    % nested function handles and anonymous functions but only got as far
    % as unifying fdstep and dffstep, at which point I gave up!)
    
    % Computes the next step
    u(n+1, :) = solver(u, p, n);
    
end

if doplot
    % Static 3D plot of u versus x and t
    surf(x, t, u, 'LineStyle', 'none');
    colormap('hot');
    xlabel('x (m)');
    ylabel('Time (s)');
    zlabel('Temperature (\circC)');

    % Animated plot GUI
    animatedPlot(@plot, 10, t, u, x);
end