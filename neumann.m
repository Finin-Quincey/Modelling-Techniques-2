function ub = neumann(u, n, d, g, solver)
%NEUMANN Represents a Neumann boundary condition with gradient g
%   Flow OUT of the boundary is POSITIVE. d is the spatial step size.

%   dimensionNumber is the index of the spatial dimension. For a 1D problem,
%   pass in 0. For a 2D problem, pass in 1 for x and 2 for y.

% Calculate the 'outside value'
u0 = u(n, 2) - 2*d*g;
% Use the supplied solver function to calculate the boundary value
ub = solver(u0, u);

% switch dimensionNumber
%     %% 1 spatial dimension
%     case 0
%         if isright
%             ub = u(end-1) - 2*d*g;
%         else
%             ub = u(2) - 2*d*g;
%         end
%         
%     %% 2 spatial dimensions
%     case 1 % x direction
%         if isright
%             ub = u(end-1, :) - 2*d*g;
%         else
%             ub = u(2, :) - 2*d*g;
%         end
%     case 2 % y direction
%         if isright
%             ub = u(:, end-1) - 2*d*g;
%         else
%             ub = u(:, 2) - 2*d*g;
%         end
% end

end

