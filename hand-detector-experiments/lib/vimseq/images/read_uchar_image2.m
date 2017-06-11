function result = read_uchar_image2(fp)

% result = read_integer_matrix2(fp)
% same as read_integer_matrix, but here we pass in a file pointer

[header, count] = fread(fp, 4, 'int32');
result = [];

if count ~= 4
    disp('failed to read header');
    return;
elseif (header(1) ~= 6 )
    disp(sprintf('bad entry in header 1: %li', header(1)));
    return;
elseif header(4) <= 0
    disp(sprintf('bad number of bands: %li', header(4)));
    return;    
end

rows = header(2);
cols = header(3);
bands = header(4);

result = read_uchar_image_data(fp, bands, rows, cols);

