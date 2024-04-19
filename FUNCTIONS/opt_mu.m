function mu_opt = opt_mu(varargin)
%mu_opt = OPT_MU Function to optimize the mu value of the iterative
%algorithm
% Parameters:
%   Hbu: Direct channel
%   Hbr: Channel between BS and RIS
%   Hru: Channel between RIS and UE
%   psi: Parameter over we seek the derivative
%   s_n: The gradient with respect x
%   alg: Type of iterative algorithm
Hbu = varargin{1};
Hbr = varargin{2};
Hru = varargin{3};
psi = varargin{4};
s_n = varargin{5};
alg = varargin{6};

if(strcmp(alg,'RSM')) % Iterative algorithm 1 (RSM - Optimize alpha of H)
    % Function to maximize is alpha = inv(trace(inv(H*H')))
    fun = @(mu) trace(inv((Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu)*(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu)'));
end

options = optimset('MaxFunEvals',1e5,'MaxIter',1e3,'TolX',1e-5');
%options = optimset('PlotFcns','optimplotfval','TolX',1e-10);
x0 = 0;
mu_opt = fminsearch(fun,x0,options);

end
