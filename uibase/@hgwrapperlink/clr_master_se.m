function clr_master_se(obj)
%HGWRAPPERLINK/CLR_MASTER_SE   Unselect current selection
%   CLR_MASTER_SE(OBJ) unmarks OBJ as the master object among its linked
%   peers.

% no linked peers or OBJ is not the current link master
if isempty(obj.links) || ~obj.link_master, return; end

sobj = obj.links;

% make sure all its linked peers are still valid
tf = ~sobj.isvalid();
if any(tf)
   % if not, remove deleted object from the link list
   sobj(tf) = [];
   obj.links(tf) = []; 
end

% Reset their link_master flag so they can now lead the change
[sobj.link_master] = deal(true);
