% Alex Dillhoff
% June 5, 2017
%
% Detects hands in a frame using pre-trained color data. Adapted from Vassilis
% Athitsos' CSE6367 code.

function [scores, centers] = detectHands(previous, current, next, ...
        handSize, suppressionFactor, nCandidates)
    negHistogram = read_double_image('negatives.bin');
    posHistogram = read_double_image('positives.bin');
    skinScores = detect_skin(current, posHistogram, negHistogram);
    previousGray = double_gray(previous);
    currentGray = double_gray(current);
    nextGray = double_gray(next);
    frameDiff = min(abs(currentGray - previousGray), abs(currentGray - nextGray));
    skinMotionScores = skinScores .* frameDiff;
    scores = imfilter(skinMotionScores, ones(handSize), 'same', 'symmetric');
    centers = topDetectionResults(current, scores, handSize, ...
        suppressionFactor, nCandidates);
