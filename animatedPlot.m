function h = animatedPlot(plotFunction, duration, t, u, varargin)
%ANIMATEDPLOT Creates an interactive animated plot of time-varying data.
%   animatedPlot(plotFunction, duration, t, u, x) creates an animated 2D plot of the
%   data in u. x and t must be vectors, and u must be a 2D matrix with
%   dimensions [length(t), length(x)]. plotFunction must be a handle to
%   an appropriate 2D plot function, such as plot, area or bar. duration is
%   the animation playtime in seconds; setting this to range(t) will result
%   in (approximately) real-time playback.
%
%   animatedPlot(plotFunction, duration, t, u, x, y) creates an animated 3D plot of the
%   data in u. x, y and t must be vectors, and u must be a 3D matrix with
%   dimensions [length(t), length(x), length(y)]. plotFunction must be a handle to
%   an appropriate 3D plot function, such as surf or mesh.
%   * Try using surfNoEdges inside an anonymous function to specify the
%   colourmap and z limits, like so:
%   @(x, y, u) surfNoEdges(x, y, u, [-20, 20], 'jet')
%
%   h = animatedPlot(...) returns a handle to the animated plot figure.

% This function is intended to be a nice data visualisation tool. In
% particular, for 2 or more spatial dimensions it becomes difficult to draw
% a useful static plot to show the data.
% 
% It is not specific to the space shuttle problem; it could be used for any
% data (try it with the drum.m example from lecture 11!)
% To keep things simple I didn't use GUIDE, this is all coded from scratch.

dimensions = size(u);
% Should always be 2 or 3.
nd = length(dimensions);
% Don't count the 1s
nd = nd - length(find(dimensions == 1));

frameTime = duration/length(t);

%% Argument checking

% Check u is either 2- or 3-dimensional
if nd < 2 || nd > 3
    error('u must be a 2- or 3-dimensional matrix');
end

% Check the correct number of spatial vectors was passed in
% varargin represents the spatial dimensions
if length(varargin) ~= nd-1
    error('n-dimensional matrix u requires n-1 spatial vectors');
end

% Check the time vector is the correct length
if dimensions(1) ~= length(t)
    error('size of u and length of time vector t must match');
end

% Check the spatial vectors are the correct length
for n=1:length(varargin)
    if dimensions(n+1) ~= length(varargin{n})
        error('size of u and lengths of spatial vectors must match');
    end
end

%% Figure construction

h = figure; % Initialise the figure

% Initialise the play/pause button
playbtn = uicontrol('Style', 'togglebutton');
playbtn.Position = [20, 20, 50, 50];
playbtn.String = '>';
playbtn.FontSize = 20;

% Calculate initial slider width based on width of figure window
sliderwidth = h.Position(3)-170;

% Initialise the time slider
timeslider = uicontrol('Style', 'slider');
timeslider.Position = [150, 50, sliderwidth, 20];
% The slider value is the index of the timestep
timeslider.Max = length(t);
timeslider.Value = 1;
timeslider.Min = 1;
% The step size is expressed as a fraction of the bar
% length(t)-1 because we want n slider positions, which is n-1 steps
timeslider.SliderStep = [1/(length(t)-1), 10/(length(t)-1)];

% Initialise the timer label (just a static text box)
label = uicontrol('Style', 'text');
label.Position = [80, 45, 60, 20];
label.FontSize = 11;
label.String = 'Time (s)';

% Initialise the timer itself
timer = uicontrol('Style', 'text');
timer.Position = [80, 20, 60, 20];
timer.FontSize = 11;
timer.String = '0.00';

% Slider has 11 ticks along its length, or 10 intervals
nticks = 10;
timeticks = cell(1, 10);
timelabels = cell(1, 10);

% Labels the slider
for n = 0:nticks % n starts from 0 because the first tick is positioned at the start
    % Consequently the indices are all n+1
    % Initialise the tick mark
    timeticks{n+1} = uicontrol('Style', 'text');
    timeticks{n+1}.Position = [169 + n/nticks*(sliderwidth-40), 35, 2, 15];
    timeticks{n+1}.String = '|';
    % Initialise the number
    timelabels{n+1} = uicontrol('Style', 'text');
    timelabels{n+1}.Position = [155 + n/nticks*(sliderwidth-40), 20, 30, 15];
    timelabels{n+1}.String = num2str(t(end)*n/nticks);
end

% Initialise the plot with the initial conditions
% Can't find a way of doing this dynamically for any nd :(
if nd == 2
    % Create the plot itself, using the given plot function
    g = plotFunction(varargin{1}, u(timeslider.Value, :));
    
    % Choose appropriate axis limits
    xlim([min(varargin{1}), max(varargin{1})]);
    ylim([min(min(u)), max(max(u))]);
    
    % Extract input variable names for axis titles
    xlabel(inputname(5));
    ylabel(inputname(4));
    
elseif nd == 3
    
    % Create the plot itself, using the given plot function
    % Without squeeze, the third argument returns a 1xMxN matrix, which is
    % not the same as an MxN matrix.
    g = plotFunction(varargin{2}, varargin{1}, squeeze(u(timeslider.Value, :, :)));
    
    % Choose appropriate axis limits
    xlim([min(varargin{2}), max(varargin{2})]);
    ylim([min(varargin{1}), max(varargin{1})]);
    zlim([min(min(min(u))), max(max(max(u)))]);
    
    % Extract input variable names for axis titles
    xlabel(inputname(6));
    ylabel(inputname(5));
    zlabel(inputname(4));
end

% Retrieve handle to axes and resize them
ax = gca;
% For some reason axes specify their position as a fraction of the figure size
ax.Position = [0.1, 0.3, 0.8, 0.6];

grid on;

%% Main loop

% Each iteration is one 'frame'; stops when the figure is closed
while isvalid(h)
    
    tic; % Start timing this frame
    
    % Update the plot data
    if nd == 2
        g.YData = u(round(timeslider.Value), :);
    elseif nd == 3
        g.ZData = squeeze(u(round(timeslider.Value), :, :));
    end
    
    % Update the displayed timer value
    timer.String = num2str(t(round(timeslider.Value)));
    
    % Update the size of the slider and positions of ticks in case the figure was resized
    sliderwidth = h.Position(3)-170;
    timeslider.Position = [150, 50, sliderwidth, 20];
    for n = 0:nticks
        timeticks{n+1}.Position = [169 + n/nticks*(sliderwidth-40), 35, 2, 15];
        timelabels{n+1}.Position = [155 + n/nticks*(sliderwidth-40), 20, 30, 15];
    end
    
    % Display play or pause symbol on the button depending on its state
    if playbtn.Value
        playbtn.String = 'II';
    else
        playbtn.String = '>';
    end
    
    % If the play button is pressed
    if playbtn.Value
        
        % If the end has been reached...
        if timeslider.Value >= timeslider.Max
            % ...automatically stop and reset the animation
            playbtn.Value = 0;
            timeslider.Value = timeslider.Min;
        else
            % Advance the timestep
            timeslider.Value = timeslider.Value + 1;
            
            % Clamp the new slider value to within the max value
            if timeslider.Value > timeslider.Max
                timeslider.Value = timeslider.Max;
            end
        end
        
        % Make sure the animation plays at the correct speed
        % pause seems to take ~20% longer than it should for arguments of
        % around 0.01s, so this does it in tiny steps and checks when the
        % correct length of time has elapsed
        while(toc < frameTime)
            pause(0.0001); % Pausing also seems to allow the figure to redraw
        end
        
    else % If the play button is not pressed
        drawnow; % Redraw everything in case the slider was moved
    end
end

end