function unext = bdstep(u, p, n)
%BDSTEP Computes the next step using the backward differencing method

dimensions = size(u);
nx = dimensions(2);

i = 2:nx-1;

% Left-hand Neumann boundary
b(1) = 1 + 2*p;
c(1) = -2*p;
d(1) = u(n, 1);
% If the LH boundary was a Dirichlet boundary, this would be the code:
% b(1) = 1;
% c(1) = 0;
% d(1) = u(n+1, 1);

% Internal points
a(i) = -p;
b(i) = 1 + 2*p;
c(i) = -p;
d(i) = u(n, i);

% Right-hand Dirichlet boundary (using pre-calculated temperature data)
a(nx) = 0;
b(nx) = 1;
d(nx) = u(n+1, nx);
% If the RH boundary was a Neumann boundary, this would be the code:
% a(nx) = -2*p;
% b(nx) = 1 + 2*p;
% d(nx) = u(n, nx);

% Compute the next step using the tri-diagonal matrix method
unext = tdm(a, b, c, d);

end

