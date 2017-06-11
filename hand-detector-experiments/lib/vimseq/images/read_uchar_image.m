function result = read_uchar_image(filename)

% result = read_uchar_image(filename)
% reads an 8-bit matrix in the format we use in the interface c++ program.

result = [];
fp = fopen(filename, 'r');
if fp == -1
    disp(['failed to open ', filename]);
    return;
end

result = read_uchar_image2(fp);
fclose(fp);
