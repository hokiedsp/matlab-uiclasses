function clrSource(obj)
%HGPROPSYNC/CLRSOURCE   Clear source HG object and its property
%   CLRTARGET(OBJ) clears source HG objects and their properties from the
%   HGPROPSYNC objects in OBJ array.

% delete the listeners
try
   delete([obj.srclis_prop_postset obj.srclis_destroy]);
catch
end

% clear property values
[obj.SourceHandle,obj.srclis_prop_postset,obj.srclis_destroy] = deal([]);
[obj.SourceHandle(:)] = deal([]);
