function populate_panel(obj)
%HGAUXCTRL/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   HGANDLABELS sets up a ObjectChildRemoved listener to intercept child
%   removal to remove the unused listeners associated with the removed child.

% call superclass' method
obj.populate_panel@hgdisguise();

% add 2 uicontrols as the labels
obj.aux_h = uicontrol('Parent',obj.hpanel,'BackgroundColor',get(obj.hpanel,'BackgroundColor'));

% set listener on lock visible property
obj.content_listeners(end+1) = addlistener(obj.aux_h,'Visible','PostSet',@(~,~)obj.layout_panel());
