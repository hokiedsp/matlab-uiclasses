function tf = hasValueChanged(obj)
%HGPROPMODE/HASVALUECHANGED   True if property value has changed
%   TF = HASVALUECHANGED(OBJ) returns true if the target property value has
%   changed since last OBJ.SETPROPERTYTOVALUE() method call. If OBJ is an
%   array of HGPROPMODE, TF is a logical array of the same size as OBJ.
%   

tf = reshape([obj.valchg],size(obj));
