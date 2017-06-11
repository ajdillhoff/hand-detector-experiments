function result = avi_read_frame(filename, frame)

% reads a double image in a format compatible with my C++ code

frame_info = aviread(filename, frame);
result = double(frame_info.cdata);
