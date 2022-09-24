function [tEnd, p, t] = time_between_points(p1, p2, initTime, grad, tMax)

    % Defaults.
    if nargin < 1
        p1 = -1;
    end

    if nargin < 2
        p2 = 1;
    end

    if nargin < 3
        initTime = 0;
    end

    if nargin < 4
        grad = @(p,t) (1-p.^2).*p + 1;
    end

    if nargin < 5
        tMax = 1e2;
    end

    % Try to join p1 to p2, stopping if we arrive.
    opts = odeset('AbsTol',1e-6,'RelTol',1e-6,'Events',@(t,p,varargin) odeabort(t,p,p2,varargin));
    [t,p,tEnd] = ode15s(@(t,p) grad(p,t), linspace(initTime, initTime + tMax,1e3), p1, opts);

    % If we failed, let the user know, unless an argument has been assigned.
    if isempty(tEnd) & nargout == 0
        disp(['Cannot go from p1 to p2 within ', num2str(tMax), ' of the initial time.'])
    end
end

function [value,isterminal,direction] = odeabort(t,p,target,varargin)
    % Test to see if we've crossed p = target.
    value(1) = p - target;
    isterminal(1) = 1;
    direction(1) = 0;
end