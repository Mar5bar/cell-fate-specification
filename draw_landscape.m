function [h, vals, ps, ts] = draw_landscape(grad, pRange, tRange)
%% DRAW_LANDSCAPE(grad, pRange, tRange) will plot an energy landscape
%% corresponding to the gradient/slope function grad(p,t), where p is the
%% state and t is the time. pRange, tRange are ranges of p and t to draw the
%% landscape. Specifying either one as scalar will result in a line plot; a
%% surface plot is constructed if both have two elements. 
%%
%% Outputs: plot-object handle;
%%          vector/matrix of computed landscape values;
%%          scalar/vector of states sampled;
%%          scalar/vector of times sampled.
    
    if nargin < 1
        % Default gradient function, of state p and time t.
        grad = @(p,t) (1-p.^2).*p + t;
    end

    if nargin < 2
        % Default range of state to draw.
        pRange = [-1.1,1.1];
    end

    if nargin < 3
        % Default range of time.
        tRange = 0;
    end

    % Prepare the grid (potentially 1D) for plotting.
    ps = linspace(pRange(1),pRange(end),1e3);
    ts = linspace(tRange(1),tRange(end),1e3);
    ps = unique(ps);
    ts = unique(ts);

    [pM,tM] = meshgrid(ps,ts);

    % Integrate the negative gradient in p.
    vals = cumtrapz(ps, -grad(pM,tM), 2);

    % Check if the plot was already being held.
    origHold = get(gca,'NextPlot');
    hold on
    if length(ts) == 1
        % Plot as a function of p if only one time is specified.
        h = plot(ps, vals, 'Color', 'black');
        xlabel('$p$')
        set(gca,'YTick',[])

        % Form an interpolant to easily plot the steady states.
        landscapeFun = griddedInterpolant(ps, vals);
        gradFun = @(x) grad(x, ts(1));
        stst = find_roots(gradFun, pRange);
        stability = is_stable(stst, gradFun);
        scatter(stst(stability),landscapeFun(stst(stability)), 100, 'LineWidth', 2, 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black')
        scatter(stst(~stability),landscapeFun(stst(~stability)), 100, 'LineWidth', 2, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'black')

    elseif length(ps) == 1
        % Plot as a function of t if only one state is specified.
        h = plot(ts, vals, 'Color', 'black');
        xlabel('$t$')
        set(gca,'YTick',[])

        % Form an interpolant to easily plot the steady states.
        landscapeFun = griddedInterpolant(ts, vals);
        gradFun = @(x) grad(ps(1), x);
        stst = find_roots(gradFun, tRange);
        stability = is_stable(stst, gradFun);
        scatter(stst(stability),landscapeFun(stst(stability)), 100, 'LineWidth', 2, 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black')
        scatter(stst(~stability),landscapeFun(stst(~stability)), 100, 'LineWidth', 2, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'black')

    else
        % Otherwise, construct a surface.
        h = surf(ps, ts, vals, 'LineStyle', 'none');
        % Plot slices of the landscape 10 sampled t in the range.
        for i = round(1:(length(ts)-1)/10:length(ts))
            plot3(ps, ts(i)*ones(size(ps)), vals(i,:), 'Color', 'black')
        end

        % Form an interpolant object for the landscape.
        landscapeFun = griddedInterpolant(pM', tM', vals');

        % Plot the approximate location of roots.
        [M, c] = contour(pM, tM, grad(pM, tM), [0,0]);
        delete(c);
        draw_contours_on_surface(M, landscapeFun);

        xlabel('$p$')
        ylabel('$t$')
        set(gca,'ZTick',[])
    end
    % Restore the old hold value.
    set(gca,'NextPlot', origHold);
end