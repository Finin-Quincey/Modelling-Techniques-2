% Script to test the computation time of the four different methods
% for solving the space shuttle tile problem over a range of timesteps

% Clear all the variables, just in case
clear;

% Set constant parameters
tmax = 4000;
xmax = 0.05;
nx = 21;

% Initialise the loop counter, timestep test values and solver cell array
i = 0;
testValues = 1:2:101; % 1s to 101s in steps of 2s
repeats = 5; % Do 5 repeats for each test
solvers = {@fdstep, @dffstep, @bdstep, @cnstep};

% Loop through each timestep to be tested
for dt = testValues
    % Increment loop counter
    i = i+1;
    % Calculate number of timesteps from tmax and dt
    nt = round(tmax/dt + 1);
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
xlabel('Timestep (s)');
ylabel('Computation time (s)');