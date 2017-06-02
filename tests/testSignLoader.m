annotationDir = '/Users/alexdillhoff/Documents/Data Sets/1113_annotations/';
dataDir = '/Volumes/ASLLVD/vid/';
signers = {'tb1113', 'lb1113'};

signLoader = SignLoader(dataDir, annotationDir, signers);
[vid, meta, annotations] = signLoader.loadSign(500);
disp(meta)
