function h = detach_se(obj)
%UIPANELEX/DETACH_SE   Detaches HG object from scalar HGWRAPPER object
%   H = DETACH_SE(OBJ) deassociates the UIPANELEX object OBJ with its
%   associated HG object (OBJ.GraphicsHandle). The OBJ is guaranteed to be
%   scalar and OBJ.hg is also guaranteed to be occupied.

% Delete class-dependent HG object w/in the panel
obj.unpopulate_panel();

% call the superclass method
h = obj.detach_se@hgenable();
