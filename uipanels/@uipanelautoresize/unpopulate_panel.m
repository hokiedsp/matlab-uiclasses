function unpopulate_panel(obj)
%UIPANELAUTORESIZE/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   UNPOPULATE_PANEL(OBJ) remove all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% stop monitoring the ResizeFcn
obj.rfmode.clrTarget();

% do the rest
obj.unpopulate_panel@uipanelex();
