function clrTarget(obj)
%HGPROPSYNC/CLRTARGET   Clear target HG object and its property
%   CLRTARGET(OBJ) clears target HG objects and their properties from the
%   HGPROPSYNC objects in OBJ array.

% delete the listeners
try
delete([obj.dstlis_destroy]);
catch
end

% clear property values
for n = 1:numel(obj)
   obj(n).dstlis_destroy(:) = [];
   obj(n).TargetHandles(:) = [];
   obj(n).TargetProperties(:) = [];
end
