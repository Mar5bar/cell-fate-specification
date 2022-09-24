function res = is_stable(x, fun, h)
%% IS_STABLE(x, fun) approximates the stability of the ODE dy/dt = fun(t) at t
%% = x via numerical differentiation of step size h.
    if nargin < 3
        h = 1e-6;
    end
    
    res = fun(x+h) < fun(x - h);

end