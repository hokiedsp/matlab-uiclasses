function tf = islocked(obj)
%HGLOCKABLE/ISLOCKED   Returns true if HG object is locked
%   ISLOCKED(OBJ)

narginchk(1,1);
if isempty(obj), return; end

% OBJ must be valid and attached
if ~(all(isvalid(obj(:)))&&all(obj(:).isattached()))
   error('All HGLOCKABLE objects must be valid to lock.');
end

% set the lock icon
tf = reshape(logical(get([obj.aux_h],'Value')),size(obj));
