function err = set_master_se(obj,varargin)
%HGWRAPPERLINK/SET_MASTER_SE   Set master object
%   SET_MASTER_SE(OBJ) marks OBJ as the master object to its linked
%   peers (marking them as slaves).

% no linked peers
err = isempty(obj.links);
if err, return; end

% if another linked peer has already claimed to be the master, return err=true
err = ~obj.link_master;
if err, return; end % if empty, returns false

sobj = obj.links;

% make sure all its linked peers are still valid
tf = ~sobj.isvalid();
if any(tf)
   % if not, remove deleted object from the link list
   sobj(tf) = [];
   obj.links(tf) = []; 
end

% Clear their link_master so they cannot lead the change
[sobj.link_master] = deal(false);
