function set_btnvis(obj,type,val,btnname)
%ZOOMPANCTRL/SET_BTNVIS   Gets a button's Visible property
%   SET_BTNVIS(OBJ,TYPE,VAL)
%   TYPE: 1-Pointer, 2-ZoomIn, 3-ZoomOut, 4-Pan

if isempty(obj.btns)
   if ~isempty(val)
      error('If %s button is not specified, %sVisible cannot be set.',btnname,btnname);
   end
else
   val = obj.validateproperty([btnname 'Visible'],val);
   
   % set new property
   try
      set(obj.btns(type),'Visible',val);
   catch ME
      ME.throwAsCaller();
   end
end
