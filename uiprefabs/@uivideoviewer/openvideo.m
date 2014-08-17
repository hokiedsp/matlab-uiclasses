function openvideo(obj,filename)
%UIVIDEOVIEWER/OPENVIDEO   Open video file (internal use only)
%   OPENVIDEO(OBJ,FILENAME) opens the video file with name specified by FILENAME
%   and display the first frame of the video.
%
%   OPENVIDEO(OBJ,VROBJ) sets VROBJ as the OBJ's VideoReader object.

% closes video if one's open
obj.closevideo();

if isa(filename,'VideoReader') && isscalar(filename)
   obj.vr = filename;
else % try opening the video file
   try
      obj.vr = VideoReader(filename);
   catch ME
      ME.throwAsCaller();
   end
   obj.autounload = true;
end

% set the axes
set(obj.hg,'Visible','off','DataAspectRatio',[1 1 1],...
   'XLim',[0.5 obj.vr.Width+0.5],'YLim',[0.5 obj.vr.Height+0.5]);

% set the image
set(obj.im,'Visible','on','XData',[1 obj.vr.Width],'YData',[1 obj.vr.Height]);

% set the counter
obj.set_txloc()

% update the playback range (to make sure the range is valid for the frame
updated = isnumeric(obj.PlaybackRange);
if updated
   % set playback range to be within the video range
   obj.pbrng(:) = min(obj.pbrng,obj.vr.NumberOfFrames);
   if obj.pbrng(1)>=obj.pbrng(2) % range is completely out for the new video
      obj.pbrng = [0 0]; % set PlaybackRange='all'
   end
elseif strcmp(obj.PlaybackRange,'all')
   obj.pbrng = [1 obj.vr.NumberOfFrames];
   updated = true;
end
if updated
   obj.setplaybackrange();
end
