function move_canvas(obj,setH,setV)
%UISCROLLPANEL/MOVE_CANVAS   Adjust canvas position (scrollbar callback)
%   MOVE_CANVAS(OBJ,SETH,SETV)

% Set canvas Units to pixels
pos_canvas = obj.get_canvas_position();

% Configure horizontal
if setH
   pos_canvas(1) = -get(obj.hscrollbars(1),'Value');
end
if setV
   pos_canvas(2) = -get(obj.hscrollbars(2),'Value');
end

% Set new canvas location
obj.set_canvas_position(pos_canvas);
