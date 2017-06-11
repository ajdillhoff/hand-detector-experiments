% Author: Alex Dillhoff
% Date: June 5, 2017
% 
% This demo shows how to detect hands in a given image.

annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
dataDir = '/Volumes/ASLLVD/vid/';
signers = {'tb1113', 'lb1113'};

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

if ~isempty(annotations{2})
    hand2Annotation = annotations{2}(frameIdx, :);
    bw = hand2Annotation(3);
    bh = hand2Annotation(4);
    bx = hand2Annotation(1);
    by = hand2Annotation(2);
    hand2Box = [bx, by, bw, bh];
    rectangle('Position', hand2Box, 'EdgeColor', 'red');
end

% Detect hands - detection routine returns locations as column-major.
handSize = [bh bw];
nCandidates = 1;
[scores, centers] = detectHands(previousFrame, currentFrame, nextFrame, ...
    handSize, 1, nCandidates);

% Show detected locations
for i = 1 : nCandidates
    by = centers(1) - (handSize(1) / 2);
    bx = centers(2) - (handSize(2) / 2);
    handBox = [bx by handSize(2) handSize(1)];
    rectangle('Position', handBox, 'EdgeColor', 'blue');
end

% Provide an error for the evaluation
% Annotations do not provide centers, the coordinate is for the top-left of the
% bounding box.
annotationCenter = [hand1Annotation(1) + (hand1Annotation(3) / 2), ...
    hand1Annotation(2) + (hand1Annotation(4) / 2)];

for i = 1 : nCandidates
    detectedLoc = [centers(i, 2) centers(i, 1)];

    err = sqrt((annotationCenter(1) - detectedLoc(1))^2 + ...
        (annotationCenter(2) - detectedLoc(2))^2);
    fprintf('Candidate %d error: %f pixels\n', i, err);
end
