function update_default(obj)
%HGPROPMODE/UPDATE_DEFAULT   Update property value to DefaultValue
%   UPDATE_DEFAULT(OBJ) is called when OBJ.DefaultValue is set. If the
%   property value of the OBJ.GraphicsHandle has not been changed from the
%   default, UPDATE_DEFAULT updates the property value to the new
%   DefaultValue.

% if target is not set or property value has changed, nothing to do
if ~obj.hasTarget() || obj.valchg
   return;
end

% temporarily disable the listener and change the property value
ena = get(obj.lis_prop_postset,'Enabled');
set(obj.lis_prop_postset,'Enabled','off');
set(obj.GraphicsHandle,obj.PropertyName,obj.DefaultValue);
set(obj.lis_prop_postset,'Enabled',ena);
