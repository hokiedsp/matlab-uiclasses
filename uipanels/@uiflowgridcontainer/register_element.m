function register_element(obj,h)
%UIFLOWGRIDCONTAINER/REGISTER_ELEMENT   ObjectChildAdded event callback
%   REGISTER_ELEMENT(OBJ,H) registers a subpanel HG object H with
%   OBJ as H is added to OBJ.GraphicsHandle.

if obj.add_element(h)
   obj.update_grid(); % update only if added
end
