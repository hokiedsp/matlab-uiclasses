function register_element(obj,h,toRegister)
%UIBUTTONGROUPEX/REGISTER_ELEMENT   ObjectChildAdded/ObjectChildRemoved event callback
%   REGISTER_ELEMENT(OBJ,H,TOADD) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

% New object must be uicontrol
% h = setdiff(h,handle(get(obj.hg,'Children')),'stable'); % only process new addition to the
if toRegister
   if any(h==obj.elem_h), return; end % already in the system (just in case)

   valid = uibuttongroupex.isvalidbutton(h);
   if ~valid, return; end % do not register if not button
   
   % set-up property listeners for the new objects
   obj.content_listeners(end+1) = addlistener(h,'Style','PostSet',@(~,event)obj.check_child(h,event.NewValue));
end

% continue on with
obj.register_element@uiflowgridcontainer(h,toRegister);
