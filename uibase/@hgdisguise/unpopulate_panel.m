function unpopulate_panel(obj)
%HGDISGUISE/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   UNPOPULATE_PANEL(OBJ) removes all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% clear the parent listener
delete(obj.p_listener);
obj.p_listener = handle([]);

% assign obj.hpanel as obj.hg to proceed with uipanelex:unpopulate 
obj.hg = obj.hpanel; % copy the handle over to hpanel
obj.hpanel = handle([]);
obj.unpopulate_panel@uipanelex();
