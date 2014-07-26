function val = get_canvassize(obj)
%UISCROLLPANEL/GET_CANVASSIZE   Implements get.CanvasSize
%   VAL = GET_CANVASSIZE(OBJ) returns CanvasSize in CanvasUnits

val = get(obj.hcanvas,'Position');
if ~isempty(val)
   val([1 2]) = [];
end
