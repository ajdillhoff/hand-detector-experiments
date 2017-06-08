% Alex Dillhoff
% June 6, 2017
%
% Detect hands in a single frame using skin and motion detection. Returns error
% and location of the top candidate.

function [bestErr, bestLocation, bestK] = evaluateFrame(previousFrame, ...
        currentFrame, nextFrame, suppressionFactor, nCandidates, target)

    bestErr = intmax;
    bestK = 0;
    bestLocation = [];

    % TODO: We have 3 frames to use for detection
    faceDetector = vision.CascadeObjectDetector();
    faceBox = step(faceDetector, uint8(currentFrame));
    if isempty(faceBox)
        return
    else
        handSize = faceBox(1, 3:4);
    end

    [scores, centers] = detectHands(previousFrame, currentFrame, ...
        nextFrame, handSize, suppressionFactor, nCandidates);

    for k = 1 : nCandidates
        detectedLoc = [centers(k, 2) centers(k, 1)];

        % Compare center to annotation
        err = detectionError(detectedLoc, target);

        if err < bestErr
            bestErr = err;
            bestK = k;
            bestLocation = detectedLoc;
        end
    end
end
