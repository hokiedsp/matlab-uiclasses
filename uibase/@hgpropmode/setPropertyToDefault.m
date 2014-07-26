function setPropertyToDefault(obj)
%HGPROPMODE/SETPROPERTYTODEFAULT   Sets property back to the default
%   SETPROPERTYTODEFAULT(OBJ) sets its target property value back to the
%   default and clears the flag so that isValueChanged() returns false.

for n = 1:numel(obj)
   set(obj(n).GraphicsHandle,obj(n).PropertyName,obj(n).DefaultValue);
   obj(n).valchg = false;
end
