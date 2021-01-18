function h = surfNoEdges(x, y, u, uLimits, clrmap)
%surfNoEdges Wrapper for surf that makes a nicer-looking plot with a large
%number of data points
%   Feed this into animatedPlot.m when doing a 2D simulation, for example:
%   animatedPlot(@(x, y, u) surfNoEdges(x, y, u, [-20, 20], 'jet'), 10, t, u, x, y);
    h = surf(x, y, u, 'LineStyle', 'None');
    axes = gca;
    axes.CLim = uLimits;
    colormap(clrmap);
end

