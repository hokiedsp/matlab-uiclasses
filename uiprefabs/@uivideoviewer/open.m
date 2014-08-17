function open(obj,filename)
%UIVIDEOVIEWER/OPEN   Open video file
%   OPEN(OBJ,FILENAME) opens the video file with name specified by FILENAME
%   and display the first frame of the video.
%
%   OPEN(OBJ,VROBJ) sets VROBJ as the OBJ's VideoReader object.

narginchk(2,2);

validateattributes(filename,{'char'},{'row'},mfilename,'FILENAME');

% open the video file
obj.openvideo(filename);

% set playback frame rate if FrameRateMode='auto'
if obj.fsauto
   obj.setframerate();
end

% if autoplay flag is set, start playing
if obj.autoplay
   obj.play();
end
