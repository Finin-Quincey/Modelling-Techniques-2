% Script to test the stability and accuracy of the four different methods
% for solving the space shuttle tile problem
% Based on code written by D N Johnston

clear;

tmax = 4000;
nt = 501;
xmax = 0.05;
nx = 21;

i = 0;
testValues = 0.001:0.00005:0.005;

for dx = testValues
    i = i+1;
    nx = round(xmax/dx + 1);
    for a = 1:10
        tic;
        [~, ~, u] = shuttle(tmax, nt, xmax, nx, @cnstep, false);
        time2(i) = toc;
    end
    time(i) = mean(time2);
end

plot(testValues, time);
%ylim([144, 147]);
grid on;
xlabel('Spatial step (m)');
ylabel('Computation time (s)');