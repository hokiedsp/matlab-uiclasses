function populate_panel(obj)
%DIALOGEX/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) covers the dialog figure with pnMain uicontainer,
%   which is controlled by OBJ.pnMain uiflowgridcontainer object. The upper
%   cell of OBJ.pnMain is occupied by a uicontainer object which is
%   assigned to OBJ.ContentPanel and the lower uicontainer forms the
%   control button group.

obj.populate_panel@dialogex();
obj.register_figure(obj.hg);
