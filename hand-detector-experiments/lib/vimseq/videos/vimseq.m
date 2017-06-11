classdef vimseq < video_file
    
    properties
      % One sequence can have images of different types, as long as each of those
      % types has the same size in bytes, and the images have the same
      % number of bands, rows and cols.
      size_of_type;
      
      % image_type tells us if each pixel value is an 8-bit int, 32-bit
      % int, float, double, and so on.
      image_type;
      
      % frame_size is the number of bytes needed to store information
      % about an entire frame.
      frame_size;
      
      % initial_offset is the byte location where the first frame starts.
      initial_offset;
    end
    
    methods
      function object = vimseq(filename)
        object.filename = filename;
        object.category = 'vimseq';

        object.valid = 0; 

        object.file_pointer = fopen(filename);
%        fprintf('vimseq constructor just called: %d\n', object.file_pointer);
        if (object.file_pointer <= 0)
          fprintf('failed to open %s\n', filename);
          return;
        end

        header = fread(object.file_pointer, 6, 'int32');
        object.frames = header(1);
        object.size_of_type = header(2);
        object.image_type = type_number_to_name(header(3));
        object.vertical = header(4);
        object.horizontal = header(5);
        object.channels = header(6);

        real_size = size_of_type(object.image_type);
        if (real_size ~= object.size_of_type)
          fprintf('type size discrepancy, real size %d, stored size %d, at %s\n', ...
            real_size, object.image_type, filename);
          return;
        end
        
        object.initial_offset = ftell(object.file_pointer);
        object.frame_size = object.horizontal * object.vertical * object.channels * object.size_of_type ...
          + 4 * size_of_type('int32');

        object.valid = 1;
        object.readable = 1;
        object.writable = 0;
        object.current_frame = 1;
        object.current_position = object.initial_offset;
      end
      
      function delete(object)
      end
      
      % read_image reads in the specified frame and returns it in the
      % format that it considers the best. The default just returns
      % a color_image, but it can be overwritten.
      function result = read_image(object, number)
        result = [];
        offset = object.frame_size * (number-1) + object.initial_offset;
        if (offset ~= object.current_position)
          status = fseek(object.file_pointer, offset, 'bof');
          if (status ~= 0)
            fprintf('failed to read frame %d from %s\n', number, object.filename);
            return;
          end
        end
        
        object.current_position = offset;
        object.current_frame = number;
        result = read_next_image(object);
      end
      
      function result = read_next_image(object)
        result = read_uchar_image2(object.file_pointer);
        object.current_position = ftell(object.file_pointer);
        if (isempty(result))
          fprintf('failed to read next frame from %s\n', object.filename);
          object.current_frame = -1;
          return;
        end
        object.current_frame = object.current_frame + 1;
      end
      
      function initialize_writing(object)
      end
      
      function write_frame(object, frame) % writes color image
      end
      
      function write_frame_gray(object, frame) % writes grayscale image 
      end
  
      function finish_writing(object)
      end
        
      function result = bytes_per_pixel(object)
        result = size_of_type(object.image_type) * object.channels;
      end
    end
end
