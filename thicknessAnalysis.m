% Script to plot graphs of inside surface temperature against time for a
% range of thicknesses

% Clear all the variables, just in case
clear;

% Set constant parameters
tmax = 4000;
nt = 501;
nx = 51;

% Initialise the loop counter and thickness test values
i = 0;
testValues = 0.01:0.01:0.1; % 10mm to 100mm in steps of 10mm

% Loop through each thickness to be tested
for xmax = testValues
    % Increment loop counter
    i = i+1;
    % Run the solver program using the Crank-Nicolson method
    [~, ~, u] = shuttle(tmax, nt, xmax, nx, @cnstep, false);
    % Store the resulting inside temperature vector
    temp(i, :) = u(:, 1);
end

% Generate data series labels (for legend)
i = 0;
for thickness = testValues
    i = i+1;
    labels{i} = ['Thickness ', num2str(thickness), 'm'];
end

% Plot the resulting data
plot(linspace(0, tmax, nt), temp);
grid on;
legend(labels);
xlabel('Time (s)');
ylabel('Inside surface temperature (s)');