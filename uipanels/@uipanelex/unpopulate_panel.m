function unpopulate_panel(obj)
%UIPANELEX/UNPOPULATE_PANEL   (protected) Unpopulate panel
%   This method is empty by default as UIPANELEX is a minimal HG wrapper
%   class. This function may be implemented by a subclass, which features
%   components on its panel object.
%
%   UNPOPULATE_PANEL(OBJ) shall remove all class-dependent components from
%   OBJ.hg, including deleting child objects and listeners and callbacks.

% if currently not enabled, kill all listeners
if ~strcmp(obj.Enable,'on')
   obj.d_revert();
end

% Delete all content listeners
delete(obj.content_listeners);
obj.content_listeners(:) = [];
