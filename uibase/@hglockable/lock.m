function lock(obj)
%HGLOCKABLE/LOCK   Lock HG object
%   LOCK(OBJ) programmatically locks OBJ (does not trigger HgIsLocked
%   event)

narginchk(1,1);
if isempty(obj), return; end

% OBJ must be valid and attached
if ~(all(isvalid(obj(:)))&&all(obj(:).isattached()))
   error('All HGLOCKABLE objects must be valid to lock.');
end

% set the lock icon
for n = 1:numel(obj)
   obj(n).lock_se();
end
