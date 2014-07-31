function added = add_element(obj,h)
%UIBUTTONGROUPEX/ADD_ELEMENT   Add new element to the grid
%   REGISTER_ELEMENT(OBJ,H) adds an HG object H to the grid maintained by
%   OBJ. H must be a scalar handle and H must already be on
%   OBJ.GraphicsHandle.

% New object must be uicontrol
added = uibuttongroupex.isvalidbutton(h);
if ~added, return; end % do not register if not button

% add
added = obj.add_element@uiflowgridcontainer(h);
if added
   % set-up property listeners for the new objects
   obj.content_listeners(end+1) = addlistener(h,'Style','PostSet',@(~,event)obj.check_child(h,event.NewValue));
end
