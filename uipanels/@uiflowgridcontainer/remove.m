function remove(obj,H,delopt)
%UIFLOWGRIDCONTAINER/REMOVE   Remove elements
%   REMOVE(OBJ,H) deletes HG panel objects given in H from a scalar
%   UIFLOWGRIDCONTAINER object OBJ.
%   
%   REMOVE(OBJ,UIPANELEXOBJ) deletes the HG objects associated with a
%   UIPANELEX objects to OBJ.
%
%   REMOVE(...,REMOVE_OPTION) specifies whether to delete H
%   (REMOVE_OPTION='delete', default) or to remove H from OBJ but keep them
%   on the associated HG object (REMOVE_OPTION='remove').

narginchk(2,3);
if ~isscalar(obj)
   error('OBJ must be a scalar UIFLOWGRIDCONTAINER object.');
end
if isempty(obj.hg)
   error('OBJ is not associated with any HG object.');
end

if isa(H,'hgwrapper')
   H = obj.hgbase();
elseif ~all(ishghandle(H))
   error('H must be an array of valid HG or HGWRAPPER objects.');
end

if nargout>2
   delopt = validatestring(delopt,{'delete','remove'});
else
   delopt = 'd';
end

if delopt(1)=='d'
   % just kill'em
   delete(H);
else
   % just remove them from the grid
   obj.remove_elements(H);
end
