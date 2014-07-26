function h = detach_se(obj)
%HGWRAPPER/DETACH_SE   Detaches HG object from scalar HGWRAPPER object
%   H = DETACH_SE(OBJ) deassociates the HGWRAPPER object OBJ with its
%   associated HG object (OBJ.hg). The OBJ is guaranteed to be scalar and
%   OBJ.hg is also guaranteed to be occupied.

% remove all the listeners
delete(obj.hg_listener);
obj.hg_listener(:) = [];

% move h from object to h double array
h = [obj.hg];
obj.hg = [];

% update the instance_manager
hgwrapper.instance_manager('update',obj);

% return double handles for pre-R2014b
if verLessThan('matlab', '8.4.0')
   h = double(h);
end
