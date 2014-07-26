function add(obj,el)
%LISTENER_MANAGER/ADD   Add new listener
%   ADD(OBJ,EL) adds event listeners in EL array to OBJ.

narginchk(2,2);
if ~isscalar(obj)
   error('OBJ must be a scalar object.');
end
ishl = isa(el,'handle.listener');
isel = isa(el,'event.listener');
if ~(ishl||isel)
   error('EL must be either event.listener or handle.listener.');
end

if isel
   addTo(obj,el,'EventListeners','ELDisableKeyPool');
else
   addTo(obj,el,'HandleListeners','HLDisableKeyPool');
end

end

function addTo(obj,el,lis_name,pool_name)

Nnew = numel(el);
N = numel(obj.(lis_name));
I = (N+1):(N+Nnew);
obj.(lis_name)(I,1) = el;
obj.(pool_name)(I,1) = deal(cell(0));

end
