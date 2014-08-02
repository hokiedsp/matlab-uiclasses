function attach_se(obj,h)
%UIPANELEX/ATTACH_SE   Attaches an HG object
%   ATTACH_SE(OBJ,H) associates the HG object, specified by its handle given
%   in H, with the HGWRAPPER object OBJ. If OBJ is an array of UIPANELEX
%   objects, the number of elements in OBJ and H must agree.
%
%   If OBJ.AutoDetach = 'off' (default) deleting OBJ or H also deletes the
%   other as well. Set OBJ.AutoDetach = 'on' to avoid this behavior.
%
%   See also UIPANELEX, UIPANELEX/UIPANELEX, UIPANELEX/DETACH.

% For all derived classes, call this attach function before adding any
% other listeners to hg_listener array

% call the superclass method
obj.attach_se@hgenable(h);

% populate the panel (if defined by subclass)
obj.populate_panel();

% initial layout (if defined by subclass)
obj.layout();
