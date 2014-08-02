function layout_panel(obj)
%UIPANELAUTORESIZE/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.

if isempty(obj.hg) || ~obj.autolayout, return; end

u = get(obj.hg,'Units');
set(obj.hg,'Units','pixels');
pos = get(obj.hg,'Position');
pos([3 4]) = max(pos([3 4]),obj.MinimumPanelSize);
set(obj.hg,'Position',pos,'Units',u);
