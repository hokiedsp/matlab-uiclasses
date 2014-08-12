function register_element(obj,h)
%UIFLOWGRIDCONTAINER/REGISTER_ELEMENT   ObjectChildAdded event callback
%   REGISTER_ELEMENT(OBJ,H) registers a subpanel HG object H with
%   OBJ as H is added to OBJ.GraphicsHandle.

warning('off','uiflowgridcontainer:GridFull');
if obj.add_element(h)
   obj.update_grid(); % update only if added
end
warning('on','uiflowgridcontainer:GridFull');
