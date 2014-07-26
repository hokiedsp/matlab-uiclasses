function [pos,dispsize] = get_canvas_position(obj,actual)
%UISCROLLPANEL/GET_CANVAS_POSITION
%   [POS,DISPSIZE] = GET_CANVAS_POSITION(OBJ) returns the current canvas
%   position in POS and its maximum display area size in DISPSIZE
%
%   [POS,DISPSIZE] = GET_CANVAS_POSITION(OBJ,true) to account for the
%   always-on scrollbars in determining DISPSIZE

if nargin<2
   actual = false;
end

backup = get(obj.hcanvas,{'Units','Position'});

set(obj.hcanvas,'Units','pixels');
pos = get(obj.hcanvas,'Position');

set(obj.hcanvas,'Units','normalized','Position',[0 0 1 1],'Units','pixels');
dispsize = get(obj.hcanvas,'Position');
dispsize([1 2]) = [];

set(obj.hcanvas,{'Units','Position'},backup);

if actual
   % if obj.onoff and obj.vis are both true, the scrollbar is visible all
   % the time -> reduce the dispsize by the thickness
   dispsize(:) = dispsize - fliplr((obj.onoff&obj.vis)*obj.thickness);
   % v-scroll reduces the width & h-scroll reduces the height
end
