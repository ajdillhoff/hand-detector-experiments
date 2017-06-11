classdef Boston_format < video_file
  properties
    image_type;
  end
  
  methods
    function object = Boston_format(filename)
      object.filename = filename;  % Video filename
      object.category = 'Boston_format';     % BU vid file extension
      object.image_type = 'uint8'; % Hardcode uint8; they don't change
      object.channels = 3;         % Assuming 3 channels. I haven't seen any BU vids that aren't.
      object.frame_rate = 30;      % Unknown actual frame rate. I estimate 30 fps
      
      object.valid = 0;
      
      % Open the file and check if it is valid
      [object.file_pointer, info] = vidOpenMex(filename);
      if isempty(info)
        fprintf('Error opening vid file %s\n', filename);
        return;
      end
      
      object.valid = 1;
      
      % Extract frame information
      object.horizontal = info(1);
      object.vertical = info(2);
      object.frames = info(3);
      clear info;
      
      object.current_frame = 1;
    end
    
    function delete(object)
      vidCloseMex(object.file_pointer);
      object.file_pointer = -1;
    end
    
    function result = read_image(object, number)
      % We need to make sure the frame number is in range
      if (number < 1) || (number > object.frames);
        fprintf('frame number %d out of range\n', number);
        result = [];
        object.current_frame = -1;
        return;
      end
      
      % Set our current_frame to the appropriate frame number and read the frame
      object.current_frame = number;
      result = read_next_image(object);
    end
    
    function result = read_image_range(object, start_frame, end_frame)
      % Are the start and end frames in range?
      if (start_frame < 1) || (end_frame > object.frames)
        fprintf('frame range error. start: %d or end: %d\n', start_frame, end_frame);
        result = [];
        object.current_frame = -1;
        return;
      end
      
      num_frames = end_frame - start_frame + 1;
      result = uint8(zeros(object.vertical, object.horizontal, object.channels, num_frames));
      frame_idx = 1;
      
      for frame_num = start_frame:end_frame
        frame = read_image(object, frame_num);
        
        % If any frame is invalid, we return an empty matrix
        if isempty(frame)
          result = [];
          return;
        end
        
        result(:, :, :, frame_idx) = frame;
        frame_idx = frame_idx + 1;
      end
    end
    
    function result = read_next_image(object)
      % Make sure the frame number is in range; return empty matrix if not
      if (object.current_frame < 1) || (object.current_frame > object.frames)
        fprintf('frame number %d out of range\n', number);
        object.current_frame = -1;
        result = [];
        return;
      end
        
      % Read the current frame (vid_reader uses zero indexing, so we sub
      %  one from the frame number to be read).
      result = vidReadMex(object.file_pointer, object.current_frame - 1);
      result = uint8(result); % We have to cast it to uint8
      
      % Validity check
      if isempty(result)
        fprintf('failed to read next frame from %s\n', object.filename);
        object.current_frame = -1;
        return;
      end
      
      object.current_frame = object.current_frame + 1;
    end
    
    function initialize_writing(object)
    end
    
    function write_frame(object, frame)
    end
    
    function write_frame_gray(object, frame)
    end
    
    function finish_writing(object)
    end
    
    function result = bytes_per_pixel(object)
      result = size_of_type(object.image_type) * object.channels;
    end
  end
end