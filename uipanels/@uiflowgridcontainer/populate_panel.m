function populate_panel(obj)
%UIFLOWGRIDCONTAINER/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   UIPANELEX sets up a ObjectChildRemoved listener to intercept child
%   removal to remove the unused listeners associated with the removed child.


% sets up ObjectChildRemoved monitor & initialize obj.content_listener
obj.populate_panel@uipanelautoresize();

% if it is uipanel, add empty Title string so it the title text uicontrol
% will not be considered as a grid member.
if strcmp(get(obj.hg,'Type'),'uipanel')
   set(obj.hg,'Title',' ','Title','');
end

% Add all existing Children to the grid
obj.addElement(get(obj.hg,'Children'));

% set ChildrenAdded listeners for obj.hg to automatically move added
% child over to canvas.
obj.hg_listener(end+1) = addlistener(obj.hg,'ObjectChildAdded',...
   @(~,event)obj.register_element(event.Child));
obj.hg_listener(end+1) = addlistener(obj.hg,'ObjectChildRemoved',...
   @(~,event)obj.unregister_element(event.Child));
