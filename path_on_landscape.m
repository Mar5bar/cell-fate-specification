function path_on_landscape(p1, p2, initTime, grad, tMax)
%% PATH_ON_LANDSCAPE(p1, p2, initTime, grad, tMax) will plot an energy
%% landscape corresponding to the gradient/slope function grad(p,t), where p
%% is the state and t is the time. Overlaid on the landscape will be a
%% trajectory joining p1 and p2, if one exists in the timeframe initTime +-
%% tMax.

    %% Defaults.
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

    % Compute the path and the time taken between the two points.
    [tEnd, p, t] = time_between_points(p1, p2, initTime, grad, tMax);

    % Use this to define the appropriate ranges for plotting.
    pRange = [min(p1,p2), max(p1,p2)];
    tRange = [0, tEnd];

    % Draw the energy landscape.
    [h, vals, ps, ts] = draw_landscape(grad, pRange, tRange);

    % Form an interpolant object, so that we can track the trajectory on the
    % energy landscape.
    [pM, tM] = meshgrid(ps, ts);
    landscapeFun = griddedInterpolant(pM', tM', vals');
    hold on

    % Plot the trajectory on the energy landscape.
    plot3(p, t, landscapeFun(p, t), 'Color', 'black', 'LineWidth', 2)
    view(0,90)

end
