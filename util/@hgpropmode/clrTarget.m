function clrTarget(obj)
%HGPROPMODE/CLRTARGET   Clear target HG object and its property
%   CLRTARGET(OBJ) clears target HG objects and their properties from the
%   HGPROPMODE objects in OBJ array.

% delete the listeners
try
delete([obj.lis_prop_postset obj.lis_destroy]);
catch
end

% clear property values
[obj.GraphicsHandle, obj.DefaultValue, obj.lis_prop_postset,obj.lis_destroy] = deal([]);
[obj.PropertyName] = deal('');
[obj.valchg] = deal(false);
