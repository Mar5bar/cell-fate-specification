function [t, p, h] = plot_path(p, initTime, grad, tDur)

    %% Defaults.
    if nargin < 1
        p1 = -1;
    end

    if nargin < 2
        initTime = 0;
    end

    if nargin < 3
        grad = @(p,t) (1-p.^2).*p + 1;
    end

    if nargin < 4
        tDur = 1e2;
    end

    % Compute the path.
    [t, p] = compute_path(p, initTime, grad, tDur);
    
    h = plot(t, p, 'LineWidth', 2, 'Color', 'black');

end