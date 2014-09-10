function val = get_btnena(obj,type)
%ZOOMPANCTRL/GET_BTNENA   Gets a button's Enable property
%   VAL = GET_BTNENA(OBJ,TYPE)
%   TYPE: 1-Pointer, 2-ZoomIn, 3-ZoomOut, 4-Pan

if isempty(obj.btns(type))
   val = '';
elseif obj.jbtns(type).isEnabled()
   val = 'on';
else
   val = 'off';
end
