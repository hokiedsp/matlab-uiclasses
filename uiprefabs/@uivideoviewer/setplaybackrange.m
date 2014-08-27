function setplaybackrange(obj,val)
%UIVIDEOVIEWER/SETPLAYBACKRANGE   PlaybackRange PostSet action
%   SETPLAYBACKRANGE(OBJ)

if nargin>1
   if strcmp(val,'all') % -> must be 'all'
      if obj.isopen()
         obj.pbrng = [1 obj.NumberOfFrames];
      end
   else
      obj.pbrng = val;
   end
end

% nothing to do if not open
if ~obj.isopen(), return; end

% if # of playback frames is less than max allowable # of frames to
% buffer, load all frames
N = diff(obj.pbrng)+obj.Qdec;
if N<obj.Nreadmax
   obj.nbuf = [1 N];
   obj.framedata = obj.vr.read(obj.nbuf);
end

% if partial range, adjust current frame so that it is within the range
frm = obj.getcurrentframe();
if frm<obj.pbrng(1)
   obj.updateframe(obj.pbrng(1));
elseif frm>obj.pbrng(2)
   obj.updateframe(obj.pbrng(2));
end
