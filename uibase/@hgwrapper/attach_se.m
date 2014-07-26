function attach_se(obj,h)
%HGWRAPPER/ATTACH_SE   Scalar element attach
%   ATTACH_SE(OBJ,H) attaches a scalar HG handle H to a scalar HGWRAPPER
%   object H.
%
%   If additional handle.listener is added to OBJ.hg_listener, make sure
%   to disable it. All OBJ.hg_listeners will be enabled at the end of the
%   OBJ.attach() method.

% store as handle object
h = handle(h);

% attach
obj.hg = h;

% set HG Delete event listener
obj.hg_listener(end+1) = addlistener(h,...
   'ObjectBeingDestroyed',@(~,~)obj.deletefcn());

% update the instance_manager
hgwrapper.instance_manager('update',obj);
