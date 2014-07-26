function remove(obj,el)
%HGLISTENERS/REMOVE   Delete & remove listener
%   REMOVE(OBJ,EL) removes listeners EL from OBJ
%   REMOVE(OBJ,H) removes all listeners listening to HG objects in H

narginchk(2,2)
if ~isscalar(obj)
   error('OBJ must be a scalar object.');
end

if isempty(obj.EventListeners) && isempty(obj.HandleListeners)
   return;
end

isel = isa(el,'event.listener');
ishl = isa(el,'handle.listener');
ishg = all(ishghandle(el));
ishgw = isa(el,'hgwrapper');
if ~(ishl||isel||ishg||ishgw)
   error('EL must be either event.listener or handle.listener or HG object handle.');
end

% if HG handles given, look for their listeners
if ishg || ishgw
   if ishg
      h = handle(el);
   else
      h = [el.GraphicsHandle];
   end

   % first look for event.listeners
   htarget = get(obj.EventListener,{'Object'}); % event.listener
   htarget = [htarget{:}];
   [~,Iel] = intersect(htarget,h);

   if ishgw % potentially additional listeners
      [~,Iel2] = intersect(htarget,el);
      Iel = [Iel(:);Iel2(:)];
   end
   
   % then look for handle.listeners
   htarget = get(obj.HandleListener,{'Container'}); % event.listener
   htarget = [htarget{:}];
   [~,Ihl] = intersect(htarget,h);
   
elseif isel
   Iel = find(obj.EventListeners==el); % event.listener
   Ihl = [];
else
   Ihl = find(obj.HandleListeners==el);
   Iel = [];
end

if ~isempty(Iel)
   removeFrom(obj,Iel,'EventListeners','ELDisableKeyPool');
end

if ~isempty(Ihl)
   removeFrom(obj,Ihl,'HandleListeners','HLDisableKeyPool');
end

end

function removeFrom(obj,Irem,lis_name,pool_name)
   I = false(size(obj.(lis_name)));
   I(Irem) = true;

   % kill the listeners
   delete(obj.(lis_name)(~I));
   
   % remove the listeners
   obj.(lis_name)(I) = [];
   obj.(pool_name)(I) = [];
end
