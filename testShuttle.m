%% Solution to the basic problem
% Test script for shuttle.m, so I don't have to keep typing it in manually

tmax = 4000; % Run the simulation for 4000s
nt = 501;
xmax = 0.06; % Tile is 60mm thick
nx = 51;

% Change @cnstep to @fdstep, @dffstep or @bdstep for different solvers
[x, t, u] = shuttle(tmax, nt, xmax, nx, @cnstep, true);