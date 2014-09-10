function unpopulate_panel(obj)
%HGDISGUISE/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   UNPOPULATE_PANEL(OBJ) removes all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% clear the parent listener
delete(obj.p_listener);
obj.p_listener = handle([]);

if strcmp(obj.hg.BeingDeleted,'on')
   obj.hg(:) = []; % copy the handle over to hpanel
   obj.hpanel(:) = [];
else
   % assign obj.hpanel as obj.hg to proceed with uipanelex:unpopulate 
   obj.hg = obj.hpanel; % copy the handle over to hpanel
   obj.hpanel(:) = [];
end
obj.unpopulate_panel@uipanelex();
