function set_canvasorigin(obj,val)
%UISCROLLPANEL/SET_CANVASORIGIN   Implements set.CanvasOrigin
%   SET_CANVASORIGIN(OBJ,[X0 Y0])

% Get scrollbar properties
vals = get(obj.hscrollbars,{'Enable','Value','Min','Max'});

% Move only if scrollbar is enabled
setH = strcmp(vals{1,1},'on');
setV = strcmp(vals{2,1},'on');
if ~(setH || setV), return; end

% Apply the new origin
pos0 = get(obj.hcanvas,'Position');
pos = [val(:).' pos0([3 4])];
set(obj.hcanvas,'Position',pos);

% Convert the new position to pixels
units0 = get(obj.hcanvas,'Units');
set(obj.hcanvas,'Units','pixels');
pos = get(obj.hcanvas,'Position'); % pos([1 2]): desired origin in pixels
set(obj.hcanvas,'Units',units0,'Position',pos0);

% Apply the new position to the scrollbar: saturate if goes out of bounds
if setH
   set(obj.hscrollbars(1),'Value',min(max(-pos(1),vals{1,3}),vals{1,4}));
end
if setV
   set(obj.hscrollbars(2),'Value',min(max(-pos(2),vals{2,3}),vals{2,4}));
end

% Move the canvas according to the scrollbar positions
obj.move_canvas(setH,setV);
