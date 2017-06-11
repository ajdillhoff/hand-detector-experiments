function result = load_video(filename)

[path, name, extension] = fileparts (filename);
if (strcmp (extension, '.vimseq3') == 1)
  result = load_vimseq3 (filename);
else 
  disp (sprintf ('unrecognized extension %s', extension));
  result = '';
end
