% Alex Dillhoff
% June 6, 2017
%
% Evaluate the hand detector using the ASLLVD dataset.

annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
dataDir = '/Volumes/ASLLVD/vid/';
signers = {'tb1113'};
signLoader = SignLoader(dataDir, annotationDir, signers);

% Function parameters
nCandidates = 1;
suppressionFactor = 1;

% Result storage
signResults = size(1113, 1);

for i = 1 : 1113
    fprintf('Processing sign %d\n', i);
    tic;

    % Load the video and annotations
    [vid, meta, annotations] = signLoader.loadSign(i);

    signError = 0;

    % Load initial frames
    vidFrameIdx = 2 + meta.StartFrame - 1;
    frame = vidReadMex(vid, vidFrameIdx);
    previous = vidReadMex(vid, vidFrameIdx - 1);

    % Pick a frame
    % We need the surrounding frames, so pick a frame >1
    for frameIdx = 2 : meta.EndFrame - meta.StartFrame - 1
        vidFrameIdx = frameIdx + meta.StartFrame - 1;
        next = vidReadMex(vid, vidFrameIdx + 1);

        % Generate the boxes for annotations and display
        hand1Annotation = annotations{1}(frameIdx, :);

        % Detect hands - detection routine returns locations as column-major.
        handSize = [hand1Annotation(4) hand1Annotation(3)];
        target = [hand1Annotation(1) + (hand1Annotation(3) / 2), ...
            hand1Annotation(2) + (hand1Annotation(4) / 2)];
        [bestErr, bestLocation, bestK] = evaluateFrame(previous, frame, next, ...
            handSize, suppressionFactor, nCandidates, target);

        signError = signError + bestErr;
        previous = frame;
        frame = next;
    end

    signError = signError / (meta.EndFrame - meta.StartFrame - 2);
    signResults(i) = signError;
    toc
end
