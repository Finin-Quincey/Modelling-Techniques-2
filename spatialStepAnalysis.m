% Script to test the stability and accuracy of the four different methods
% for solving the space shuttle tile problem over varying spatial steps
% Based on code written by D N Johnston

% Clear all the variables, just in case
clear;

% Set constant parameters
tmax = 4000;
nt = 501;
xmax = 0.05;
nx = 21;

% Initialise the loop counter and timestep test values
i = 0;
testValues = 0.001:0.00005:0.005; % 1mm to 5mm in steps of 0.5mm

% Loop through each timestep to be tested
for dx = testValues
    % Increment loop counter
    i = i+1;
    % Calculate nx from dx
    nx = round(xmax/dx + 1);
    % Run the solver program using each of the four methods
    [~, ~, u] = shuttle(tmax, nt, xmax, nx, @fdstep, false);
    ufd(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, xmax, nx, @dffstep, false);
    udff(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, xmax, nx, @bdstep, false);
    ubd(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, xmax, nx, @cnstep, false);
    ucn(i) = u(end, 1);
end

% Plot the resulting data
plot(testValues, [ufd; udff; ubd; ucn]);
ylim([144, 147]);
legend('Forward Differencing', 'DuFort-Frankel', 'Backward Differencing', 'Crank-Nicolson');
grid on;
xlabel('Spatial step (m)');
ylabel('Final temperature at inner boundary (\circC)');