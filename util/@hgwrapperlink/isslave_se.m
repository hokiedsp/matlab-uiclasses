function tf = isslave_se(obj)
%HGWRAPPERLINK/ISSLAVE_SE
%   ISSLAVE_SE(OBJ) returns true if OBJ is in a slave mode and its change
%   is applied by the master peer thus do not need to apply the change to
%   its linked peers.

tf = ~obj.link_master;
