% drum.m
% ME20021
%
% MATLAB script to predict vibration of a drumskin or tensioned plate
%
% D N Johnston  18/3/08
%
% Exercises:
% Try different frequencies
% Try an initial impulse by entering zero for frequency.

% This version has been modified slightly to demonstrate animatedPlot.m

clear
close all
nx = 101;
ny = 101;
xmax = 1;
ymax = 1;
dx = xmax / (nx-1);
dy = ymax / (ny-1);
x = [0:nx-1] * dx;
y = [0:ny-1] * dy;

nt = 1000;

% beta is a damping factor.
beta = 0.001;

% create dialog box for entering value of frequency
answer = inputdlg('Enter the frequency, or 0 for an impulse response');

% convert from string to number
freq = str2num(answer{1});
% freq is the excitation frequency. Natural frequencies occur at
% sqrt(n^2+m^2), where n and m are integers (including zero)

% initial conditions
u = zeros(nx,ny);

U = zeros(nx, ny, nt);

% This creates a 3D gaussian curve centred at (i, j) = (41, 31) to represent
% an initial impulse.
if freq == 0
    for i=2:nx
        for j=2:ny
            u(i,j)=-exp(-((i-51)^2+(j-51)^2)/10);
        end
    end
end

uold = u;
unew = u;
%figure(1)
% Optionally, set graph to full screen size
%set(1,'OuterPosition',get(0,'ScreenSize'));
%h = surf(y, x, u);
%shading interp
% Change the colormap argument to hsv, hot, cool, spring, summer, autumn,
% winter, bone, copper, pink for different surface colours
%colormap jet
%caxis ([-.1 .1]);
%view(150,20)
%zlim([-1 1]);
%xlabel('\itx\rm - m')
%ylabel('\ity\rm - m')
%zlabel('\itu\rm - mm')

%endless time-stepping loop
for n=1:nt
    if freq > 0 %apply a vibration to one point on the grid
        u(81,81) = sin(freq*n*pi/100);
    end
    
    % main calculations
    for i=2:nx-1
        for j=2:ny-1
            unew(i,j) = ((u(i-1, j)+u(i+1, j) + u(i, j-1) + u(i, j+1))/2 -...
                uold(i,j)*(1-beta))/(1+beta);
        end
    end
    
    % update plot
    %drawnow
    %set(h,'ZData', u);
    %overwrite old values with new
    uold = u;
    u = unew;
    U(:, :, n) = shiftdim(u(:, :), -1);
end

animatedPlot(@(x, y, u) surfNoEdges(x, y, u, [-0.15, 0.15], 'bone'), 10, 1:1000, permute(U, [3, 1, 2]), x, y);