function result = double_gray(input_image)

% function result = double_gray(input_image)
%
% returns a version of the input image that is of type double, and
% grayscale 

if (strcmp(class(input_image), 'double'))
    result = input_image;
else
    result = double(input_image);
end

%    result = 0.3*result(:,:,1) + 0.59*result(:,:,2) + 0.11*result(:,:,3);
result = mean(result, 3);

