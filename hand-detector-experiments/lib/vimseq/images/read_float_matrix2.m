function result = read_float_matrix2(fp)

% result = read_float_matrix2(fp)
% same as read_float_matrix, but here we pass in a file pointer

[header, count] = fread(fp, 4, 'int32');
result = [];

if count ~= 4
    disp('failed to read header');
    return;
elseif header(1) ~= 4
    disp(sprintf('bad entry in header 1: %li', header(1)));
    return;
elseif header(4) ~= 1
    disp(sprintf('bad number of bands: %li', header(4)));
    return;
end

rows = header(2);
cols = header(3);

[result, count] = fread(fp, [cols, rows], 'float32');
result = result';

if count ~= rows * cols
    disp(sprintf('failed to read data, count = %li', count));
    result = [];
end
