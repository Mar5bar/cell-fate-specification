function [t, p, sol] = compute_path(p, initTime, grad, tDur)

    opts = odeset('AbsTol', 1e-6, 'RelTol', 1e-6);
    sol = ode15s(@(t,p) grad(p,t), [initTime, initTime + tDur], p, opts);
    t = sol.x;
    p = sol.y;

end