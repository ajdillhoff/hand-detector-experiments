% Alex Dillhoff
% June 8, 2017
%
% Experiment 1
% ============
%
% Evaluate the effectiveness of a skin + motion based hand detector on signer
% lb1113 from the ASLLVD dataset.
%
% Method
% ------
%
% Motion + skin hand detector is used to detect a single hand candidate.
% Starting with a raw frame, the face is detected. The resulting face bounding
% box is used as the hand size input to the hand detector.
%
% No normalization is applied to the data.
%
% Error is measured as the Euclidean distance between the detected hand center
% and the provided annotation.

% Data directories
dataDir = '/Volumes/ASLLVD/vid/';
annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
savePath = '/Users/alexdillhoff/Documents/Projects/hand-detector-experiments/results/exp_1_results.mat';

% Experiment parameters
signers = {'lb1113'};
nCandidates = 1;
suppressionFactor = 1;

% Run evaluate on all frames
result = evaluateAll(dataDir, annotationDir, savePath, ...
    signers, nCandidates, suppressionFactor);
