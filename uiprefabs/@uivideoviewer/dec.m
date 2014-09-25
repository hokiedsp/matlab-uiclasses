function dec(obj,dec)
%UIVIDEOVIEWER/DEC   Decrement video frame
%   DEC(OBJ,NDEC) updates the displayed video frame of UIVIDEOVIEWER OBJ by
%   decremmenting OBJ.CurrentFrame by NDEC frames.
%
%   DEC(OBJ) increments OBJ.CurrentFrame by one frame.

narginchk(1,2);

if ~isscalar(obj)
   error('OBJ must be a scalar %s object.',class(obj));
end
if nargin<2
   dec = 1;
else
   validateattributes(dec,{'numeric'},{'scalar','integer'});
end

% set frame
obj.setcurrentframe(max(obj.n-dec,1))
