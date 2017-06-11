classdef standard_format < video_file
    % this is the superclass for video objects
    
    properties
      reader;
      all_data;
    end
    
    methods
      function object = standard_format(filename)
        object.filename = filename;
        object.category = 'standard';

        object.valid = 0; 
        object.file_pointer = -1;

        object.reader = VideoReader(filename);
        object.vertical = object.reader.Height;
        object.horizontal = object.reader.Width;
        object.frame_rate = object.reader.FrameRate;
        
        object.all_data = cell(0);
        object.frames = 0;
        while (hasFrame(object.reader))
          frame = readFrame(object.reader);
          object.frames = object.frames + 1;
          object.all_data{object.frames} = frame;
        end

        object.valid = 1;
        object.readable = 1;
        object.writable = 0;
        object.current_frame = 1;
      end
      
      function delete(object)
      end
      
      % read_image reads in the specified frame and returns it in the
      % original format in which it was read.
      function result = read_image(object, number)
        result = [];
        
        if ((number < 1) || (number > object.frames))
          return;
        end
        
        result = object.all_data{number};
        object.current_frame = number + 1;
      end
      
      function result = read_next_image(object)
        result = [];
        
        if ((object.current_frame < 1) || (object.current_frame> object.frames))
          return;
        end
        
        result = object.all_data{number};
        object.current_frame = number + 1;
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
