function [x t u] = shuttle(tmax, nt, xmax, nx, method, doplot)
% Function for modelling temperature in a space shuttle tile
% D N Johnston  22/1/18
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', true);
%

% Set tile properties
thermcon = 0.141; % W/(m K)
density  = 351;   % 22 lb/ft^3
specheat = 1258;  % ~0.3 Btu/lb/F at 500F

% Some crude data to get you started:
timedata = [0  60 500 1000 1500 1750 4000]; % s
tempdata = [16 16 820 760  440  16   16];   % degrees C

% Better to load surface temperature data from file.
% (you need to have modified and run plottemp.m to create the file first.)
% Uncomment the following line.
% load temp597.mat

% Initialise everything.
dt = tmax / (nt-1);
t = (0:nt-1) * dt;
dx = xmax / (nx-1);
x = (0:nx-1) * dx;
u = zeros(nt, nx);

% set initial conditions to 16C throughout.
% Do this for first two timesteps.
u([1 2], :) = 16;

% Main timestepping loop.
for n = 2:nt - 1
    
    % RHS boundary condition: outer surface. 
    % Use interpolation to get temperature R at time t(n+1).
    R = interp1(timedata, tempdata, t(n+1), 'linear', 'extrap');
    
    % Select method.
    switch method
        case 'forward'
            
        case 'dufort-frankel'

        otherwise
            error (['Undefined method: ' method])
            return
    end
end

if doplot
    % Create a plot here.

end
% End of shuttle function



    