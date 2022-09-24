function draw_contours_on_surface(M, grad, landscapeFun)
%% DRAW_CONTOURS_ON_SURFACE(M, landscapeFun) will take the contour segments
%% stored in M (the output of contourc), and plot them as lines at the height
%% specified by landscapeFun(x,y).

    % If there is nothing to plot, simply return.
    if isempty(M)
        return
    end

    % Loop through M, unpacking MATLAB's strange structure.
    baseInd = 1;
    toPlot = {};
    while baseInd < size(M,2)
        numPoints = M(2,baseInd);
        p = M(1,baseInd+1:baseInd+numPoints);
        t = M(2,baseInd+1:baseInd+numPoints);
        % Add the new points to a list of points to plot.
        toPlot = [toPlot, {p}, {t}, {landscapeFun(p, t)}];
        baseInd = baseInd + numPoints + 1;
    end

    % Compute the stability the points (p,t) for fixed t, and record the
    % stable and unstable parts.
    toPlotStable = {};
    toPlotUnstable = {};
    ind = 1;
    while ind < length(toPlot)
        ps = toPlot{ind};
        ts = toPlot{ind+1};
        heights = toPlot{ind+2};
        stability = false(size(ps));
        for j = 1 : length(ts)
            gradFun = @(x) grad(x, ts(j));
            stability(j) = is_stable(ps(j), gradFun);
        end
        
        % Find the points where the stability changes, and we should be
        % plotting a different curve.
        switchInds = find(xor(stability(1:end-1), stability(2:end)));
        blocks = [1, switchInds+1, length(stability)];
        for blockInd = 1 : length(blocks)-1
            blockInds = blocks(blockInd) : blocks(blockInd+1);
            psBlock = ps(blockInds);
            tsBlock = ts(blockInds);
            heightsBlock = heights(blockInds);
            if stability(blocks(blockInd))
                toPlotStable = [toPlotStable, {psBlock}, {tsBlock}, {heightsBlock}];
            else
                toPlotUnstable = [toPlotUnstable, {psBlock}, {tsBlock}, {heightsBlock}];
            end
        end

        ind = ind + 3;
    end

    % Plot all the curves in succinct calls to plot3.
    plot3(toPlotStable{:}, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '-')
    plot3(toPlotUnstable{:}, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--')

end