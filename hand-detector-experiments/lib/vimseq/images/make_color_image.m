function result = make_color_image(matrix)

% function result = make_color_image(matrix)
%
% converts the input matrix into a color (3-band) image of doubles.
% - if it is already 3 bands, just casts to double
% - if it is one band, it repeats the band and casts to double
% - otherwise it puts in all three bands the average value
%   of the pixel across all bands of matrix

  channels = size(matrix, 3);
  vertical = size(matrix, 1);
  horizontal = size(matrix, 2);
  
  if (channels == 3)
    result = double(matrix);
  elseif (channels == 1)
    result = zeros(vertical, horizontal, 3);
    result(:,:, 1) = double(matrix);
    result(:,:, 2) = double(matrix);
    result(:,:, 3) = double(matrix);
  else
    result = zeros(vertical, horizontal, 3);
    average = mean(matrix, 3); 
    result(:,:, 1) = double(average);
    result(:,:, 2) = double(average);
    result(:,:, 3) = double(average);
  end
end

