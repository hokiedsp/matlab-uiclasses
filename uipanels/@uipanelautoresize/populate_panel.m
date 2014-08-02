function populate_panel(obj)
%UIPANELAUTORESIZE/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.

% call superclass method first
obj.populate_panel@uipanelex();

% set ResizeFcn monitor
obj.rfmode.setTarget(obj.hg,'ResizeFcn',@(~,~)obj.layout_panel());
