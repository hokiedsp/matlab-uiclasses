function unregister_element(obj,h)
%UIFLOWGRIDCONTAINER/UNREGISTER_ELEMENT   ObjectChildAdded/ObjectChildRemoved event callback
%   REGISTER_ELEMENT(OBJ,H,TOADD) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

obj.remove_elements(h);
obj.update_grid();
