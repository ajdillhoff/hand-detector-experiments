% Author: Alex Dillhoff
% Date: June 2, 2017
% 
% This demo shows how to visualize the hand location annotations on a frame.

annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
dataDir = '/Volumes/ASLLVD/vid/';
signers = {'tb1113', 'lb1113'};

% Load the video and annotations
signLoader = SignLoader(dataDir, annotationDir, signers);
[vid, meta, annotations] = signLoader.loadSign(500);

% Pick a frame
frameIdx = 1;
vidFrameIdx = frameIdx + meta.StartFrame - 1;
frame = vid.read_frame(vidFrameIdx);

% Display the frame
imshow(uint8(frame));

% Generate the boxes for annotations and display
hand1Annotation = annotations{1}(frameIdx, :);
bw = hand1Annotation(3);
bh = hand1Annotation(4);
bx = hand1Annotation(1);
by = hand1Annotation(2);
hand1Box = [bx, by, bw, bh];
rectangle('Position', hand1Box, 'EdgeColor', 'red');

if annotations{2} ~= []
    hand2Annotation = annotations{2}(frameIdx, :);
    bw = hand1Annotation(3);
    bh = hand1Annotation(4);
    bx = hand1Annotation(1);
    by = hand1Annotation(2);
    hand2Box = [bx, by, bw, bh];
    rectangle('Position', hand2Box, 'EdgeColor', 'red');
end
