function clrTarget(obj)
%HGPROPMODE/CLRTARGET   Clear target HG object and its property
%   CLRTARGET(OBJ) clears target HG objects and their properties from the
%   HGPROPMODE objects in OBJ array.

% delete the listeners
delete([obj.lis_prop_postset obj.lis_destroy]);

% clear property values
[obj.GraphicsHandle, obj.DefaultValue, obj.lis_prop_postset,obj.lis_destroy] = deal([]);
[obj.PropertyName] = deal('');
[obj.valchg] = deal(false);
