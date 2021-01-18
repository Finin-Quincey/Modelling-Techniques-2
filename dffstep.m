function unext = dffstep(u, p, n)
%DFFSTEP Computes the next step using the DuFort-Frankel method
%   Works for both 1 and 2 spatial dimensions; detects which automatically

dimensions = size(u);
nx = dimensions(2);

switch length(dimensions)
    case 2
        %% 1 spatial dimension (main assignment)
        i = 2:nx-1;

        % Internal points
        unext = ((1-2*p)*u(n-1, i) + 2*p*(u(n, i-1) + u(n, i+1))) / (1+2*p);
        
        % Left-hand Neumann boundary
        u(n+1, 1) = ((1-2*p)*u(n-1, 1) + 4*p*u(n, 2)) / (1+2*p);
        
        % Append the boundary conditions
        unext = [u(n+1, 1), unext, u(n+1, nx)];
        
    case 3
        %% 2 spatial dimensions (extension)
        ny = dimensions(3);
        
        i = 2:nx-1;
        j = 2:ny-1;

        % Internal points
        unext = ((1-4*p)*u(n-1, i, j) + 2*p*(u(n, i-1, j) + u(n, i+1, j) + u(n, i, j-1) + u(n, i, j+1))) / (1+4*p);
        
        % North (min x) Neumann boundary
        u(n+1, 1, j) = ((1-4*p)*u(n-1, 1, j) + 2*p*(2*u(n, 2, j) + u(n, 1, j-1) + u(n, 1, j+1))) / (1+4*p);
        
        % Append the boundary conditions
        top    = [u(n+1, 1, 1)          , squeeze(u(n+1, 1, j))' , u(n+1, 1, ny)          ];
        unext  = [squeeze(u(n+1, i, 1))', squeeze(unext)         , squeeze(u(n+1, i, ny))'];
        bottom = [u(n+1, nx, 1)         , squeeze(u(n+1, nx, j))', u(n+1, nx, ny)         ];
        
        unext = [top; unext; bottom];
end

end

