function inc(obj,inc)
%UIVIDEOVIEWER/INC   Increment video frame
%   INC(OBJ,NINC) updates the displayed video frame of UIVIDEOVIEWER OBJ by
%   incremmenting OBJ.CurrentFrame by NINC frames.
%
%   INC(OBJ) increments OBJ.CurrentFrame by one frame.

narginchk(1,2);

if ~isscalar(obj)
   error('OBJ must be a scalar %s object.',class(obj));
end
if nargin<2
   inc = 1;
else
   validateattributes(inc,{'numeric'},{'scalar','integer'});
end

% video file must be open
if isempty(obj.vr)
   error('Video file is not open.');
end

% increment current frame index
obj.setcurrentframe(obj.n+inc);
