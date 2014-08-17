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
obj.populate_panel@hgauxctrl();

% set main uicontrol to be left aligned
set(obj.hg,'HorizontalAlignment','left');

% Get file open icon
icon = uiutil.getDefaultToolbarIcon('file_open.png');
SZ = size(icon);
obj.aux_size = SZ([2 1])+4;

% set aux control as a pushbutton
set(obj.aux_h,'Style','pushbutton','String',' ','CData',icon,...
   'Position',[0 0 obj.aux_size],'Visible','on','Callback',@(~,~)obj.promptuser(false));

% layout
obj.layout();

% configure
obj.format_hg();
