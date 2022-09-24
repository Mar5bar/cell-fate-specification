function sols = find_roots(fun, pRange, numSamples)
%% FIND_ROOTS(grad, pRange, numSamples) attempts to find all the roots of fun
%% (p) within the domain pRange by first evaluating at numSamples points,
%% identifying roots to use as starting guesses for fzero.
    
    if nargin < 3
        numSamples = 1e2;
    end
    
    % Generate sample points and evaluate fun on them.
    samplePoints = linspace(pRange(1), pRange(2), numSamples);
    midpoints = movmean(samplePoints, 2, 'Endpoints', 'discard');
    sampleVals = fun(samplePoints);

    % Coarsely find roots.
    inds = find(sampleVals(1:end-1).*sampleVals(2:end) < 0);

    % For each approximate root, use fzero to find it accurately.
    sols = zeros(length(inds));
    for i = 1 : length(inds)
        sols(i) = fzero(fun, midpoints(inds(i)));
    end

    % Sort and remove any duplicates.
    sols = unique(sort(sols));

    % Remove any outside of the range.
    sols = sols(sols >= pRange(1) & sols <= pRange(2));

end
