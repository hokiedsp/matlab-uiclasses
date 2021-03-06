function populate_panel(obj)
%UIPANELEX/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   UIPANELEX sets up descendent's Enable monitoring and a
%   ObjectChildRemoved listener to intercept child removal to remove the
%   unused listeners associated with the removed child.
%
%   Typically, it is better for its derived class to do its own
%   populate_panel actions first then call uipanelex's populate_panel.

% set ChildrenAdded listeners to destroy the content_listeners
obj.hg_listener(end+1) = addlistener(obj.hg,'ObjectChildRemoved',@(~,event)obj.delete_listeners(event.Child));

% if OBJ is currently not enabled, disable/inactivate the descendents of
% the panel as well.
if ~strcmp(obj.Enable,'on')
   obj.enable_action();
end
