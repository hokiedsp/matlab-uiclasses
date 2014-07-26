function populate_panel(obj)
%UIPANELAUTORESIZE/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.

% call superclass method first
obj.populate_panel@uipanelex();

% if ResizeFcnMode='auto', set ResizeFcn
if strcmp(obj.ResizeFcnMode,obj.propopts.ResizeFcnMode.StringOptions{2})
   set(obj.hg,'ResizeFcn',obj.defaultresizefcn);
end
   
% set ChildrenAdded listeners to destroy the content_listeners
obj.hg_listener(end+1) = addlistener(obj.hg,'ResizeFcn','PostSet',...
   @(~,event)obj.check_resizefcn(event.NewValue));
