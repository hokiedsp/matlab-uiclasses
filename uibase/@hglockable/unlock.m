function unlock(obj)
%HGLOCKABLE/UNLOCK   Unlock HG object
%   UNLOCK(OBJ) programmatically unlocks OBJ (does NOT trigger HgIsUnlocked
%   event)

narginchk(1,1);
if isempty(obj), return; end

% OBJ must be valid and attached
if ~(all(isvalid(obj(:)))&&all(obj(:).isattached()))
   error('All HGLOCKABLE objects must be valid to unlock.');
end

% set the lock icon
for n = 1:numel(obj)
   obj(n).unlock_se();
end
