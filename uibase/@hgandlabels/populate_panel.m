function populate_panel(obj)
%HGANDLABELS/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   HGANDLABELS sets up a ObjectChildRemoved listener to intercept child
%   removal to remove the unused listeners associated with the removed child.

% call superclass' method
obj.populate_panel@hgdisguise();

% initialize HgHeightLimits and HgWidthLimits to be tight
set(obj.hg,'Units','pixels');
pos = get(obj.hg,'Position');
obj.wlims = pos([3 3]);
obj.hlims = pos([4 4]);

% initialize the control layout grid
obj.update_gridlims();
