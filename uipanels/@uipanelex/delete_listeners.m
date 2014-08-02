function delete_listeners(obj,h)
%UIPANELEX/DELETE_LISTENERS   Remove unused listeners
%   DELETE_LISTENERS(OBJ,H) is the UIPANELEX's ObjectChildRemoved event
%   callback to remove unused listeners, which were setup by its derived
%   classes on the Children of the panel (i.e., obj.hg).
%
%   All listeners in obj.content_listeners are searched for their Container
%   properties. If the Container property matches one of H, the handle of
%   the graphics object that has been removed, then that listener will be
%   deleted and removed from obj.content_listners array.

if ~(isvalid(obj) && obj.indelete), return; end

if ~isempty(obj.content_listeners)
   hlistened = get(obj.content_listeners,{'Container'});
   hlistened = [hlistened{:}];
   idx = ismember(hlistened,h);
   delete(obj.content_listeners(idx));
   obj.content_listeners(idx) = [];
end

% hlistened = cell2mat(get(obj.content_listeners,'Container'))
% for n = 1:numel(h)
%    % find the relevant listeners
%    I = find(handle(h)==hlistened,1);
%
%    % remove the listeners
%    delete(obj.content_listeners(I));
%    obj.content_listeners(I) = [];
% end
