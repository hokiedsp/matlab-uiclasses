function populate_panel(obj)
%HGLOCKABLE/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) shall initialize OBJ.hg, including populating it
%   with necessary child objects and setting up listeners and callback.
%   However, it shall not layout the panel, which should be performed in
%   OBJ.layout_panel method.
%
%   HGANDLABELS sets up a ObjectChildRemoved listener to intercept child
%   removal to remove the unused listeners associated with the removed child.

% call superclass' method
obj.populate_panel@hgauxctrl();

% set the aux control as a checkbox
set(obj.aux_h,'Style','checkbox','String','',...
   'Value',0,'Min',0,'Max',1,'Callback',@(~,~)obj.lock_clicked());

% just in case, use the exact set string options from the HG object
obj.propopts.LockVisible.StringOptions = set(obj.aux_h,'Visible');
obj.propopts.LockEnable.StringOptions = set(obj.aux_h,'Enable');

% layout the panel
obj.layout();

% initialize to unlocked position
obj.unlock_se();
