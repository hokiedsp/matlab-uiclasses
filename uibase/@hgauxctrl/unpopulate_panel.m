function unpopulate_panel(obj)
%HGAUXCTRL/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   This method is empty by default as UICTRLPANEL is a minimal HG wrapper
%   class. This function may be implemented by a subclass, which features
%   components on its panel object.
%
%   UNPOPULATE_PANEL(OBJ) shall remove all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% delete all existing chidren from the panel
delete(obj.aux_h);
obj.aux_h(:) = [];

% call superclass' method
obj.unpopulate_panel@hgdisguise();
