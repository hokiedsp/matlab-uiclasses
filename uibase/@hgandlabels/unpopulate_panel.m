function unpopulate_panel(obj)
%HGANDLABELS/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   This method is empty by default as UICTRLPANEL is a minimal HG wrapper
%   class. This function may be implemented by a subclass, which features
%   components on its panel object.
%
%   UNPOPULATE_PANEL(OBJ) shall remove all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% delete all existing chidren from the panel
if obj.removepanel && strcmp(obj.hg.BeingDeleted,'off')
   obj.removeLabel(obj.labels_h);
   delete(obj.haxes);
   obj.haxes = deal([]);
else
   obj.labels_h(:) = [];
   obj.labels_htext = {};    % text handle for tex/latex text interpreter support
   obj.labels_layout = zeros(0,3);
   obj.labels_margin(:) = [];   % space from the origin of the leading label to the nearest edge of the HG
   obj.labels_interpreter(:) = [];
end

% call superclass' method
obj.unpopulate_panel@hgdisguise();
