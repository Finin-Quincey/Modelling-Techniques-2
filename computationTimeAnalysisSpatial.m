% Script to test the computation time of the four different methods
% for solving the space shuttle tile problem over a range of spatial step
% sizes

% Clear all the variables, just in case
clear;

% Set constant parameters
tmax = 4000;
xmax = 0.05;
nt = 501;

% Initialise the loop counter, spatial step test values and solver cell array
i = 0;
testValues = 0.001:0.0001:0.005; % 1mm to 5mm in steps of 0.1mm
repeats = 5; % Do 5 repeats for each test
solvers = {@fdstep, @dffstep, @bdstep, @cnstep};

% Loop through each timestep to be tested
for dx = testValues
    % Increment loop counter
    i = i+1;
    % Calculate number of timesteps from tmax and dt
    nx = round(xmax/dx + 1);
    % Test each solution method in turn
    for n = 1:length(solvers)
        % Repeats are done since computation time exhibits a degree of
        % randomness
        for m = 1:repeats
            tic; % Start timing
            shuttle(tmax, nt, xmax, nx, solvers{n}, false); % Run the solver program with current parameters
            times(m) = toc; % Record the elapsed time
        end
        % Take an average of the repeats and store it
        time(n, i) = mean(times);
    end
end

% Plot the resulting four data series
plot(testValues, time);
grid on;
legend('Forward Differencing', 'DuFort-Frankel', 'Backward Differencing', 'Crank-Nicolson');
xlabel('Spatial step (m)');
ylabel('Computation time (s)');