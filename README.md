# Hand Detector Experiments

This project evaluates the efficacy of different hand detectors on the ASLLVD
dataset.

# Dependencies

vid_reader - Library for reading .vid files. Available at
http://csr.bu.edu/asl/asllvd/annotate/vid_reader.zip

# Loading Data

Data can be loaded through the SignLoader class. It is initialized with the 
directory locations of the video and annotation data. A sign is loaded by calling
`loadSign(signId)`.

An example of loading a particular sign is given in tests/testSignLoader.m.
