function populate_panel(obj)

obj.populate_panel@uipanelautoresize();

% set panel position
set(obj.hg,'Units','pixels');
pos = get(obj.hg,'Position');
pos(3:4) = obj.panelsize;
if pos(3)==0
   pos(3) = pos(4)*4;
end
set(obj.hg,'Position',pos);

% uses Java jToggleButtons
obj.javainit(); % buttons only drawn if the panel is visible

% if target figure not set, 
obj.TargetFigure = ancestor(obj.hg,'figure');
