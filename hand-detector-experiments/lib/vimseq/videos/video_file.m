classdef video_file < handle
    % this is the superclass for video objects
    
    properties
      filename;
      category; % "avi" for AVIs, "rle" for RLEs, etc.
      file_pointer;
      horizontal; % number of rows
      vertical; % number of columns
      channels; % number of color bands
      frames;
      frame_rate;

      current_frame;
      current_position; % position in file

      valid;
      readable;
      writable;
    end
    
    methods(Abstract)
      % read_frame reads in the specified frame as a uchar8 color image
      % read_image reads in the specified frame and returns it in the
      % format that it considers the best. The default just returns
      % a color_image, but it can be overwritten.
      read_image(object, number)
      read_next_image(object)
      
      initialize_writing(object)
      write_frame(object, frame) % writes color image
      write_frame_gray(object, frame) % writes grayscale image 
  
      finish_writing(object)
      bytes_per_pixel(object)      
    end
    
    methods
      function delete(object)
%        fprintf('video file destructor just called: %d\n', object.file_pointer);
        if (object.file_pointer > 0)
          fclose(object.file_pointer);
        end
      end
      
      function object = video_file()
        valid = 0;
        readable = 0;
        writable = 0;
      end
      

      % read_frame reads in the specified frame as a uchar8 color image
      function result = read_frame(object, number)
        frame = read_image(object, number);
        result = make_color_image(frame);        
      end
      
      function result = read_frame_range(object, start_frame, end_frame)
        if start_frame < 1 || end_frame > object.frames
          fprintf('frame range error. start: %d or end: %d\n', start_frame, end_frame);
          result = [];
          return;
        end
        
        num_frames = end_frame - start_frame + 1;
        result = zeros(object.vertical, object.horizontal, object.channels, num_frames);
        frame_idx = 1;
        for frame_num = start_frame:end_frame
          frame = read_frame(object, frame_num);
          
          if isempty(frame)
            result = [];
            return;
          end
          
          result(:, :, :, frame_idx) = frame;
          frame_idx = frame_idx + 1;
        end
      end
            
      function result = read_next_frame(object)
        frame = read_next_image(object);
        result = make_color_image(frame);        
      end
      
      function result = read_all(object)
        result = zeros(object.vertical, object.horizontal, object.channels, object.frames);
        for (i = 1:object.frames)
            result(:, :, :, i) = read_frame(object, i);
        end
      end
    end
end

