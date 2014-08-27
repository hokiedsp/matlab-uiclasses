function play(obj)
%UIVIDEOVIEWER/PLAY   Starts video playback
%   PLAY(OBJ) starts to play back the video. 

% video file must be open
if isempty(obj.vr)
   error('Video file is not open.');
end

if obj.Enable(2)~='n'
   error('OBJ is not enabled. Set OBJ.Enabled = ''on'' first.');
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
