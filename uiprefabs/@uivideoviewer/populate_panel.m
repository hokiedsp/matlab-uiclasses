function populate_panel(obj)
%UIVIDEOVIEWER/POPULATE_PANEL   (protected) Populate axes with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   UIVIDEOVIEWER sets up descendent's Enable monitoring and a
%   ObjectChildRemoved listener to intercept child removal to remove the
%   unused listeners associated with the removed child.
%
%   Typically, it is better for its derived class to do its own
%   populate_panel actions first then call uipanelex's populate_panel.

% set axes 
set(obj.hg,'Box','on','XTick',[],'YTick',[],'YDir','reverse',...
   'DrawMode','fast','Visible','on');

% build UI
obj.im = handle(image('Parent',obj.hg,'CDataMapping','direct','XData',[],'YData',[],'CData',[]));
obj.tx = handle(text('Parent',obj.hg,'Units','normalized','Color','y'));
