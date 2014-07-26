function d_revert(obj)
%UIPANELEX/D_REVERT   Revert descendents Enable properties
%   D_REVERT(OBJ)

% delete all event.listeners
delete(obj.d_hg_listeners);
obj.d_hg_listeners(:) = [];
delete(obj.d_hgw_listeners);
obj.d_hgw_listeners(:) = [];

% restore Enable properties of all (valid) HG handles
I = ~ishghandle(obj.d_hgs);
obj.d_hgs(I) = [];
obj.d_hg_states(I) = [];
set(obj.d_hgs,{'Enable'},obj.d_hg_states(:));
obj.d_hgs(:) = [];
obj.d_hg_states(:) = [];

% restore Enable properties of set all (valid) hgwrapper objects
I = ~isvalid(obj.d_hgws);
obj.d_hgws(I) = [];
obj.d_hgw_states(I) = [];
set(obj.d_hgws,{'Enable'},obj.d_hgw_states(:));
obj.d_hgws(:) = [];
obj.d_hgw_states(:) = [];
