function set_btnena(obj,type,val,btnname)
%ZOOMPANCTRL/SET_BTNENA   Gets a button's Enable property
%   SET_BTNENA(OBJ,TYPE,VAL)
%   TYPE: 1-Pointer, 2-ZoomIn, 3-ZoomOut, 4-Pan

if isempty(obj.btns)
   if ~isempty(val)
      error('If %s button is not specified, %sEnable cannot be set.',btnname,btnname);
   end
else
   val = obj.validateproperty([btnname 'Enable'],val);
   
   % set new property
   obj.jbtns(type).setEnabled(val(2)=='n'); % true if 'on'
end
