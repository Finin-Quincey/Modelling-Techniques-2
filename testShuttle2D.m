%% Solution to the 2D version of the problem
% Test script for shuttle2D.m, so I don't have to keep typing it in manually

tmax = 4000; % Run the simulation for 4000s
nt = 501;
xmax = 0.06; % Tile is 60mm thick
nx = 51;
ymax = 0.15; % Tile is 150mm long (taken from NASA - Wings In Orbit [3])

% Change @dffstep to @fdstep to use forward differencing (forward differencing
% only works with about 11 timesteps or less, or it goes unstable!)
[x, y, t, u] = shuttle2D(tmax, nt, xmax, nx, ymax, @dffstep, true);