function unext = cnstep(u, p, n)
%CNSTEP Computes the next step using the Crank-Nicolson method

dimensions = size(u);
nx = dimensions(2);

i = 2:nx-1;

% Left-hand Neumann boundary
b(1) = 1 + p;
c(1) = -p;
d(1) = (1-p)*u(n, 1) + p*u(n, 2);
% If the LH boundary was a Dirichlet boundary, this would be the code:
% b(1) = 1;
% c(1) = 0;
% d(1) = u(n+1, 1);

% Internal points
a(i) = -p/2;
b(i) = 1 + p;
c(i) = -p/2;
d(i) = (p/2)*u(n, i-1) + (1-p)*u(n, i) + (p/2) * u(n, i+1);

% Right-hand Dirichlet boundary (using pre-calculated temperature data)
a(nx) = 0;
b(nx) = 1;
d(nx) = u(n+1, nx);
% If the RH boundary was a Neumann boundary, this would be the code:
% a(nx) = -p;
% b(nx) = 1 + p;
% d(nx) = (1-p)*u(n, nx) + p*u(n, nx-1);

% Compute the next step using the tri-diagonal matrix method
unext = tdm(a, b, c, d);

end

