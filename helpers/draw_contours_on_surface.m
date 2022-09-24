function draw_contours_on_surface(M, landscapeFun)
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
        x = M(1,baseInd+1:baseInd+numPoints);
        y = M(2,baseInd+1:baseInd+numPoints);
        % Add the new points to a list of points to plot.
        toPlot = [toPlot, {x}, {y}, {landscapeFun(x, y)}];
        baseInd = baseInd + numPoints + 1;
    end

    % Plot all the curves in one call to plot3.
    plot3(toPlot{:}, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--')

end