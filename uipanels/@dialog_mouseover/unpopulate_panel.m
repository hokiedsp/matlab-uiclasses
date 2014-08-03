function unpopulate_panel(obj)
%DIALOGEX/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   UNPOPULATE_PANEL(OBJ) removes all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% 
obj.unpopulate_panel@dialogex();
obj.unregister_figure();
