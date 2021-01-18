function unext = fdstep(u, p, n)
%FDSTEP Computes the next step using the forward differencing method
%   Works for both 1 and 2 spatial dimensions; detects which automatically

dimensions = size(u);
nx = dimensions(2);

switch length(dimensions)
    case 2
        %% 1 spatial dimension (main assignment)
        i = 2:nx-1;

        % Internal points
        unext = (1-2*p)*u(n, i) + p*(u(n, i-1) + u(n, i+1));
        
        % Left-hand Neumann boundary
        % (I have decided to do boundaries separately because using index
        % manipulation would be inflexible if, for example, we wanted a
        % non-zero gradient)
        u(n+1, 1) = (1-2*p)*u(n, 1) + 2*p*u(n, 2);
        
        % Append the boundary conditions
        unext = [u(n+1, 1), unext, u(n+1, nx)];
        
    case 3
        %% 2 spatial dimensions (extension)
        ny = dimensions(3);
        
        i = 2:nx-1;
        j = 2:ny-1;

        % Internal points
        unext = (1-4*p)*u(n, i, j) + p*(u(n, i-1, j) + u(n, i+1, j) + u(n, i, j-1) + u(n, i, j+1));
        
        % North (min x) Neumann boundary
        u(n+1, 1, j) = (1-4*p)*u(n, 1, j) + p*(2*u(n, 2, j) + u(n, 1, j-1) + u(n, 1, j+1));
        
        % East (min y) Neumann boundary
        %u(n+1, i, 1) = (1-4*p)*u(n, i, 1) + p*(u(n, i-1, 1) + u(n, i+1, 1) + 2*u(n, i, 2));
        
        % West (max y) Neumann boundary
        %u(n+1, i, ny) = (1-4*p)*u(n, i, ny) + p*(u(n, i-1, ny) + u(n, i+1, ny) + 2*u(n, i, ny-1));
        
        % Append the boundary conditions
        top    = [u(n+1, 1, 1)          , squeeze(u(n+1, 1, j))' , u(n+1, 1, ny)          ];
        unext  = [squeeze(u(n+1, i, 1))', squeeze(unext)         , squeeze(u(n+1, i, ny))'];
        bottom = [u(n+1, nx, 1)         , squeeze(u(n+1, nx, j))', u(n+1, nx, ny)         ];
        
        unext = [top; unext; bottom];
end

end

