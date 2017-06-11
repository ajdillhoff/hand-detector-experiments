% Alex Dillhoff
% June 6, 2017
%
% Demo the evaluation function for detecting a hand candidate and comparing it
% with the ground truth.

annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
dataDir = '/Volumes/ASLLVD/vid/';
signers = {'tb1113', 'lb1113', 'gb1113'};

% Load the video and annotations
signLoader = SignLoader(dataDir, annotationDir, signers);
[vid, meta, annotations] = signLoader.loadSign(500);

% Pick a frame
% We need the surrounding frames, so pick a frame >1
frameIdx = 2;
vidFrameIdx = frameIdx + meta.StartFrame - 1;
currentFrame = vid.read_frame(vidFrameIdx);
previousFrame = vid.read_frame(vidFrameIdx - 1);
nextFrame = vid.read_frame(vidFrameIdx + 1);

% Display the frame
imshow(uint8(currentFrame));

% Generate the boxes for annotations and display
hand1Annotation = annotations{1}(frameIdx, :);
bw = hand1Annotation(3);
bh = hand1Annotation(4);
bx = hand1Annotation(1);
by = hand1Annotation(2);
hand1Box = [bx, by, bw, bh];
rectangle('Position', hand1Box, 'EdgeColor', 'red');

%if annotations{2} ~= []
    %hand2Annotation = annotations{2}(frameIdx, :);
    %bw = hand2Annotation(3);
    %bh = hand2Annotation(4);
    %bx = hand2Annotation(1);
    %by = hand2Annotation(2);
    %hand2Box = [bx, by, bw, bh];
    %rectangle('Position', hand2Box, 'EdgeColor', 'red');
%end

% Detect hands - detection routine returns locations as column-major.
nCandidates = 1;
suppressionFactor = 1;
target = [hand1Annotation(1) + (hand1Annotation(3) / 2), ...
    hand1Annotation(2) + (hand1Annotation(4) / 2)];
[bestErr, bestLocation, bestK] = evaluateFrame(previousFrame, currentFrame, ...,
    nextFrame, suppressionFactor, nCandidates, target);

if bestErr == intmax
    fprintf('No hand candidates for this frame.\n');
end
