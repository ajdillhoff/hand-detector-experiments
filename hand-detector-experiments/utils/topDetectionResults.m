% June 5, 2017
% Alex Dillhoff
%
% Implementation of top_detection_results.m from Vassilis Athitsos' CSE6367
% course code. Removes the rectangle drawing in order to optimize performance.

function centers = topDetectionResults(current, scores, handSize, ...
        suppressionFactor, nCandidates)
    halfRows = floor(handSize(1) / 2);
    halfCols = floor(handSize(2) / 2);

    centers = zeros(nCandidates, 2);
    rows = size(current, 1);
    cols = size(current, 2);

    for i = 1 : nCandidates
        maxScore = max(max(scores));
        [maxRows, maxCols] = find(scores == maxScore);
        maxLocation = [maxRows(1), maxCols(1)];
        centers(i, :) = maxLocation;

        currentTop = maxLocation(1) - halfRows;
        currentBottom = maxLocation(1) + halfRows;
        currentLeft = maxLocation(2) - halfCols;
        currentRight = maxLocation(2) + halfCols;

        top = max(1, round(maxLocation(1) - halfRows * suppressionFactor));
        bottom = min(rows, round(maxLocation(1) + halfRows * suppressionFactor));
        left = max(1, round(maxLocation(2) - halfCols * suppressionFactor));
        right = min(cols, round(maxLocation(2) + halfCols * suppressionFactor));

        scores(top:bottom, left:right) = 0;
    end
