function added = add_element(obj,h)
%UIBUTTONGROUPEX/REGISTER_ELEMENT   ObjectChildAdded event callback
%   REGISTER_ELEMENT(OBJ,H) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

% New object must be axes
added = strcmp(get(h,'Type'),'axes');
if added
   added = obj.add_element@uiflowgridcontainer(h);
end
