function tf = hasTarget(obj)
%HGPROPMODE/HASTARGET   True if target is set
%   HASTARGET(OBJ) returns true if OBJ has its target set. If OBJ is an
%   array, it returns a logical array of the same size as OBJ indicating
%   the target-readiness of individual HGPROPMODE object.

tf = false(size(obj));
for n = 1:numel(obj)
   tf(n) = ~isempty(obj(n).GraphicsHandle);
end
