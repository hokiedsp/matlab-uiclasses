function setcurrentframe(obj,varargin)
%UIVIDEOVIEWER/SETCURRENTFRAME   Display specific frame
%   SETCURRENTFRAME(OBJ,...)

if ~obj.isopen()
   error('CurrentFrame cannot be set unless a video file is open.');
end
obj.updateframe(varargin{:});
