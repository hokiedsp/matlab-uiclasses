function set_canvas_position(obj,pos)
%UISCROLLPANEL/SET_CANVAS_POSITION
%   SET_CANVAS_POSITION(OBJ,POS)

u = get(obj.hcanvas,'Units');
set(obj.hcanvas,'Units','pixels');
set(obj.hcanvas,'Position',pos);
set(obj.hcanvas,'Units',u);
