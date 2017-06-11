function result = read_frame(video, frame)
 
result = [];

if (video.valid == 0)
  return;
end

if (strcmp(video.extension, '.vimseq3') == 1)
  result = read_frame_vimseq3(video, frame);
  return;
  
else 
  disp(sprintf ('unrecognized extension %s', extension));
  result = '';
end
 

