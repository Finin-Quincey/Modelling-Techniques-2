% Script to test the stability and accuracy of the four different methods
% for solving the space shuttle tile problem
% Based on code written by D N Johnston

clear;

tmax = 4000;
nt = 501;
xmax = 0.05;
nx = 21;

i = 0;
testValues = 1:2:101;
solvers = {@fdstep, @dffstep, @bdstep, @cnstep};

for dt = testValues
    i = i+1;
    nt = round(tmax/dt + 1);
    for n = 1:length(solvers)
        for m = 1:5
            tic;
            shuttle(tmax, nt, xmax, nx, solvers{n}, false);
            times(m) = toc;
        end
        time(n, i) = mean(times);
    end
end

plot(testValues, time);
grid on;
legend('Forward Differencing', 'DuFort-Frankel', 'Backward Differencing', 'Crank-Nicolson');
xlabel('Timestep (s)');
ylabel('Computation time (s)');