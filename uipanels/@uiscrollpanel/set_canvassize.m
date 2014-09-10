function set_canvassize(obj,val)
%UISCROLLPANEL/SET_CANVASSIZE   Implements set.CanvasSize

al = obj.autolayout;
obj.autolayout = true;
obj.layout_panel(val);
obj.autolayout = al;
