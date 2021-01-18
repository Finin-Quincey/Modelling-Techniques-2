% Script to plot image of measured temperature, and trace it using the mouse.
%
% Image from http://www.columbiassacrifice.com/techdocs/techreprts/AIAA_2001-0352.pdf
% Now available at 
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.26.1075&rep=rep1&type=pdf
%
% D N Johnston 23/01/17

name = 'temp597';
img=imread([name '.jpg']);

figure (4);
image(img);
hold on
% You can adapt the following code to enter data interactively or automatically.

timedata = [];
tempdata = [];

while 1 % infinite loop
    [x, y, button] = ginput(1); % get one point using mouse
    if button ~= 1 % break if anything except the left mouse button is pressed
        break
    end
    plot(x, y, 'og') % 'og' means plot a green circle.
    
    % Add data point to vectors. Note that x and y are pixel coordinates.
    % You need to locate the pixel coordinates of the axes, interactively
    % or otherwise, and scale the values into time (s) and temperature (F, C or K).
    timedata = [timedata, x];
    tempdata = [tempdata, y];
end
hold off

% sort data and remove duplicate points.
[timedata, index] = unique(timedata);
tempdata = tempdata(index);

%save data to .mat file with same name as image file
save(name, 'timedata', 'tempdata')

