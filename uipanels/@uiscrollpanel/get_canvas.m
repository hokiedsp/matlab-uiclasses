function val = get_canvas(obj)
%UISCROLLPANEL/GET_CANVAS   Get canvas HG handle
%   GET_CANVAS(OBJ)

val = obj.hcanvas;
try
   val = double(val);
catch
end
