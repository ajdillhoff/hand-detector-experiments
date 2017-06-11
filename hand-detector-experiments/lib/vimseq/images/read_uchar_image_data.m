function result = read_uchar_image_data(fp, bands, rows, cols)

% result = read_uchar_image_data(fp, bands, rows, cols)
% same as read_uchar_image2, but here we know bands, rows, cols, and
% just read the data

success = 1;
result = zeros(rows, cols, bands);
for band = 1: bands
    [temp, count] = fread(fp, [cols, rows], 'uint8');

    if count ~= rows * cols
        disp(sprintf('failed to read data, count = %li', count));
        success = 0;
    end
    
    result(:,:,band) = temp' ;
end

if success == 0
    result = 0;
end
