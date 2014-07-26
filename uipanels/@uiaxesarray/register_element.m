function register_element(obj,h,toRegister)
%UIBUTTONGROUPEX/REGISTER_ELEMENT   ObjectChildAdded/ObjectChildRemoved event callback
%   REGISTER_ELEMENT(OBJ,H,TOADD) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

% New object must be axes
if toRegister && ~strcmp(get(h,'Type'),'axes')
   return;
end

% continue on with
obj.register_element@uiflowgridcontainer(h,toRegister);
