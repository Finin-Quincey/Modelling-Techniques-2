function ub = radiant(u, dx, g, isright)
%RADIANT Represents a Robin boundary condition which obeys Fourier's law
% for heat transfer by radiation

sigma = 56.7e-9; % Stefan-Boltzmann constant (W/m^2K^4)

% INCOMPLETE

% q = ?

if isright
    ub = u(end-1) - (2*dx*q)/k;
else
    ub = u(2) + (2*dx*q)/k;
end

end

