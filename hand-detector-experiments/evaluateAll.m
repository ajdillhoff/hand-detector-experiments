% % evaluateAll
% Evaluate the hand detector using the ASLLVD dataset.
% % Syntax
%# results = evaluateAll(dataDir, annotationDir, savePath, signers,
%                        nCandidates, suppressionFactor);
% % Description
% Evaluation of the skin and motion based hand detector against all frames
% in the ASLLVD dataset. The detected locations are compared against the target
% locations and reported in terms of pixel difference.
%
% * dataDir - Path to the ASLLVD dataset.
% * annotationDir - Path to the annotations for the ASLLVD data.
% * savePath - Full path and file name used to save the results.
% * signers - The names of the signers used in the evaluation. Candidates are:
%  - tb1113
%  - lb1113
%  - gb1113
% * nCandidates - The number of hand detection candidates to return from the
% hand detector
% * suppressionFactor - Multiplicative factor for suppressing detection results
% when evaluating multiple candidates. See `topDetectionResults`.

function results = evaluateAll(dataDir, annotationDir, savePath, ...
        signers, nCandidates, suppressionFactor);

    signLoader = SignLoader(dataDir, annotationDir, signers);

    % Check for existing file
    if exist(savePath, 'file')
        load(savePath);
        startIndex = find(cellfun('isempty', results), 1);
    else
        results = cell(1113, 1);
        startIndex = 1;
    end

    for i = startIndex : 1113
        fprintf('Processing sign %d\n', i);
        tic;

        % Load the video and annotations
        [vid, meta, annotations] = signLoader.loadSign(i);

        % Load initial frames
        vidFrameIdx = 2 + meta.StartFrame - 1;
        previousFrame = vid.read_frame(vidFrameIdx - 1);
        currentFrame = vid.read_frame(vidFrameIdx);
        nFrames = meta.EndFrame - meta.StartFrame - 2;
        signResults = zeros(nFrames, 1);

        % Pick a frame
        % We need the surrounding frames, so pick a frame >1
        for frameIdx = 2 : nFrames + 1
            vidFrameIdx = frameIdx + meta.StartFrame - 1;
            nextFrame = vid.read_frame(vidFrameIdx + 1);

            % Generate the boxes for annotations and display
            hand1Annotation = annotations{1}(frameIdx, :);

            % Detect hands - detection routine returns locations as column-major.
            target = [hand1Annotation(1) + (hand1Annotation(3) / 2), ...
                hand1Annotation(2) + (hand1Annotation(4) / 2)];
            [bestErr, bestLocation, bestK] = evaluateFrame(previousFrame, ...
                currentFrame, nextFrame, suppressionFactor, nCandidates, target);

            signResults(frameIdx - 1) = bestErr;
            previousFrame = currentFrame;
            currentFrame = nextFrame;
        end

        results{i} = signResults;
        save(savePath, 'results');
        toc
    end
