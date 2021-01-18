% Script to test the stability and accuracy of the four different methods
% for solving the space shuttle tile problem over varying timesteps
% Based on code written by D N Johnston

% Clear all the variables, just in case
clear;

% Set constant parameters
tmax = 4000;
xmax = 0.05;
nx = 21;

% Initialise the loop counter and timestep test values
i = 0;
testValues = 1:2:101; % 1s to 101s in steps of 2s

% Loop through each thickness to be tested
for dt = testValues
    % Increment loop counter
    i = i+1;
    % Calculate nt from dt
    nt = round(tmax/dt + 1);
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
ylim([0, 200]);
legend('Forward Differencing', 'DuFort-Frankel', 'Backward Differencing', 'Crank-Nicolson');
grid on;
xlabel('Timestep (s)');
ylabel('Final temperature at inner boundary (\circC)');