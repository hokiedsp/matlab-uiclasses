function play(obj)

% video file must be open
if isempty(obj.vr)
   error('Video file is not open.');
end

% start the timer if not already running
if ~obj.isplaying
   try
      start(obj.tmr);
   catch ME
      errordlg('Failed to play the video.');
      ME.getReport();
      return;
   end
end
