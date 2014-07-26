function val = get_canvasorigin(obj)
%UISCROLLPANEL/GET_CANVASORIGIN   Implements get.CanvasOrigin
%   VAL = GET_CANVASORIGIN(OBJ)

% Get canvas position in CanvasUnits
val = get(obj.hcanvas,'Position');
val(3:4) = [];

h = obj.hscrollbars;

% temporarily match scrollbar units to that of the canvas
set(h,'Units',obj.CanvasUnits);

% if scrollbar is shown at low location, adjust
if obj.loclo(2) && strcmp(get(h(2),'Visible'),'on')
   val(1) = val(1) - obj.thickness;
end
if obj.loclo(1) && strcmp(get(h(1),'Visible'),'on')
   val(2) = val(2) - obj.thickness;
end

% revert the scrollbar units to the default pixels
set(h,'Units','pixels');
