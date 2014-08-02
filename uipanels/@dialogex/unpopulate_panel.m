function unpopulate_panel(obj)
%DIALOGEX/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   UNPOPULATE_PANEL(OBJ) removes all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% clear figure property monitoring
obj.crfmode.clrTarget();
obj.wkpfmode.clrTarget();

% clear figure property synchronizers
obj.propsync.clrSource();
obj.propsync.clrTarget();

% delete the main panel (which also removes other elements)
delete(obj.pnButtonBox.detach());
delete(obj.ContentPanel);

% do the rest
obj.unpopulate_panel@uipanelautoresize();
