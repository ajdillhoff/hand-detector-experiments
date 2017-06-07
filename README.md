# Hand Detector Experiments

This project evaluates the efficacy of different hand detectors on the ASLLVD
dataset.

# Dependencies

 - ASLLVD dataset: http://csr.bu.edu/asl/asllvd/annotate/index-cvpr4hb08-dataset.html
 - vid_reader - Library for reading .vid files. Available at
http://csr.bu.edu/asl/asllvd/annotate/vid_reader.zip
 - CSE6367 supplementary code and data is used for the hand detector.
    - Data: http://vlm1.uta.edu/~athitsos/courses/cse6367_common_data/gesture_videos.zip
    - Code: http://vlm1.uta.edu/~athitsos/courses/cse6367_spring2012/lectures/all_code.zip

# Loading Data

Data can be loaded through the SignLoader class. It is initialized with the 
directory locations of the video and annotation data. A sign is loaded by calling
`loadSign(index)`.

An example of loading a particular sign is given in tests/testSignLoader.m.

# Detection and Evaluation

Running detector is done using the `detectHands` method. Example:

```
[scores, centers] = detectHands(previous, current, next, handSize, ...
            suppressionFactor, nCandidates);
```

Evaluation of a frame consists of detecting the possible hand candidates and
comparing each one against the given target hand location. The call to
`evaluateFrame` returns the best candidate index, location, and error. Example:

```
[bestErr, bestLocation, bestK] = evaluateFrame(previous, frame, next, ...
            handSize, suppressionFactor, nCandidates, target);
```

# TODO

 - Add proper function documentation.
 - Normalization functions.
 - Support for vimseq files.
