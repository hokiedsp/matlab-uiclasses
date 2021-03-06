function removeElement(obj,H,delopt)
%UIFLOWGRIDCONTAINER/REMOVEELEMENT   Remove elements
%   REMOVEELEMENT(OBJ,H) deletes HG panel objects given in H from a scalar
%   UIFLOWGRIDCONTAINER object OBJ.
%   
%   REMOVEELEMENT(OBJ,UIPANELEXOBJ) deletes the HG objects associated with a
%   UIPANELEX objects to OBJ.
%
%   REMOVEELEMENT(...,REMOVE_OPTION) specifies whether to delete H
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
   H = H.hgbase();
elseif ~all(ishghandle(H))
   error('H must be an array of valid HG or HGWRAPPER objects.');
end

if nargin>2
   delopt = validatestring(delopt,{'delete','remove'});
else
   delopt = 'd';
end

if delopt(1)=='d'
   % kill'em
   delete(H); % -> will trigger unregister_element callback function
else
   % just remove them from the grid
   obj.remove_elements(H);

   % update the grid
   obj.update_grid();
end
