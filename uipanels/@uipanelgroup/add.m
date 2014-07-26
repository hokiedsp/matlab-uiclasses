function add(obj,H)
%UIPANELGROUP/ADD   Add subpanels
%   ADD(OBJ,H) adds HG panel objects given in H to a scalar
%   UIPANELGROUP object OBJ. If H must be supported panel type.
%   
%   ADD(OBJ,UIPANELEXOBJ) adds the HG objects associated with a
%   UIPANELEX objects to OBJ.

narginchk(2,2);
if ~isscalar(obj)
   error('OBJ must be a scalar UIPANELGROUP object.');
end
if isempty(obj.hg)
   error('OBJ is not associated with any HG object.');
end

if isa(H,'uipanelex')
   % extract base HG objects from UIPANELEX objects
   H = H.hgbase();
elseif ~all(ishghandle(H)) || ~all(uipanelex.ispanel(H))
   error('H must be valid panel HG objects or UIPANELEX objects.');
end

% set OBJ.GraphicsHandle as their Parent
set(H,'Parent',obj.GraphicsHandle);
