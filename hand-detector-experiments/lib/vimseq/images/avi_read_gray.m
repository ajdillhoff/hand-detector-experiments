function result = avi_read_gray(filename, frame)

% reads a double image in a format compatible with my C++ code

frame_info = aviread(filename, frame);
result = double_gray(frame_info.cdata);
