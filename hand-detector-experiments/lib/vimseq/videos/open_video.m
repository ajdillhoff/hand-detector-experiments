function result = open_video(filename)

  result = [];

  [path, name, extension] = fileparts(filename);
  if (strcmpi(extension, '.asf') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.asx') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.avi') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.m4v') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.mj2') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.mov') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.mpg') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.mp4') == 1)
    result = standard_format(filename);

  elseif (strcmpi(extension, '.vid') == 1)
    result = Boston_format(filename);

  elseif (strcmpi(extension, '.vimseq3') == 1)
    result = vimseq(filename);

  elseif (strcmpi(extension, '.wmv') == 1)
    result = standard_format(filename);

  else 
    disp(sprintf ('unrecognized extension %s', extension));
    return;
  end

  if (result.valid == 0)
    result = [];
  end
end
