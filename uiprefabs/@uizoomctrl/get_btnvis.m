function val = get_btnvis(obj,type)
%ZOOMPANCTRL/GET_BTNVIS   Gets a button's visible property
%   VAL = GET_BTNVIS(OBJ,TYPE)
%   TYPE: 1-Pointer, 2-ZoomIn, 3-ZoomOut, 4-Pan

if isempty(obj.btns)
   val = '';
else
   val = get(obj.btns(type),'Visible');
end
